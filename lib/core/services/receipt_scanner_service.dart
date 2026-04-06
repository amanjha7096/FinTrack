import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

class ScanResult {
  /// The parsed amount in INR. Null if no valid amount was found in the image.
  final double? amount;

  /// The parsed transaction date. Null if no valid date was found.
  final DateTime? date;

  /// The inferred category key based on receipt text.
  final String? categoryKey;

  /// The guessed merchant name. Null if extraction failed.
  final String? merchant;

  /// The full raw OCR text joined from all blocks.
  final String rawText;

  const ScanResult({
    required this.amount,
    required this.date,
    required this.categoryKey,
    required this.merchant,
    required this.rawText,
  });

  /// True if at least an amount was found.
  bool get hasUsefulData => amount != null;
}

@lazySingleton
class ReceiptScannerService {
  final _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _picker = ImagePicker();

  /// Opens the rear camera. Returns null if the user cancels.
  Future<ScanResult?> scanFromCamera() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;
    return _processImage(photo.path);
  }

  /// Opens the photo gallery. Returns null if the user cancels.
  Future<ScanResult?> scanFromGallery() async {
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (photo == null) return null;
    return _processImage(photo.path);
  }

  Future<ScanResult> _processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognized = await _recognizer.processImage(inputImage);
    final allBlocks = recognized.blocks;
    final rawText = recognized.text;
    final normalizedText = rawText.replaceAll('\r', '');

    return ScanResult(
      amount: _parseAmount(allBlocks),
      date: _parseDate(normalizedText),
      categoryKey: _inferCategory(normalizedText),
      merchant: _parseMerchant(allBlocks),
      rawText: normalizedText,
    );
  }

  double? _parseAmount(List<TextBlock> blocks) {
    final flat = blocks.map((b) => b.text).join('\n').toLowerCase();

    double? tryParse(String raw) {
      final cleaned = raw.replaceAll(',', '');
      final value = double.tryParse(cleaned);
      if (value == null) return null;
      if (value <= 0) return null;
      if (value > 999999) return null;
      if (value < 1) return null;
      return value;
    }

    final patterns = [
      RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false),
      RegExp(r'(?:Rs\.?|INR)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false),
      RegExp(r'(?:total|amount due|net payable|grand total|subtotal)[^\d]{0,6}([\d,]+\.\d{2})',
          caseSensitive: false),
      RegExp(r'\b([\d,]+\.\d{2})\b'),
      RegExp(r'\b([\d]{3,6})\b'),
    ];

    for (int i = 0; i < 3; i++) {
      final matches = patterns[i].allMatches(flat).toList();
      if (matches.isEmpty) continue;
      final values = matches
          .map((m) => tryParse(m.group(1) ?? ''))
          .whereType<double>()
          .toList();
      if (values.isEmpty) continue;
      return values.reduce((a, b) => a > b ? a : b);
    }

    for (int i = 3; i < patterns.length; i++) {
      final match = patterns[i].firstMatch(flat);
      if (match == null) continue;
      final value = tryParse(match.group(1) ?? '');
      if (value != null) return value;
    }

    return null;
  }

  String? _parseMerchant(List<TextBlock> blocks) {
    if (blocks.isEmpty) return null;

    final firstLine = blocks.first.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .firstOrNull;

    if (firstLine == null) return null;

    if (RegExp(r'^\d{1,2}[/\-]\d{1,2}').hasMatch(firstLine)) return null;
    if (RegExp(r'^[\d\s]+$').hasMatch(firstLine)) return null;
    if (firstLine.contains('₹') || firstLine.toLowerCase().contains('rs')) return null;
    if (firstLine.length < 3 || firstLine.length > 50) return null;

    return firstLine
        .toLowerCase()
        .split(' ')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  DateTime? _parseDate(String text) {
    final lowerText = text.toLowerCase();
    final keywordRegex = RegExp(r'\b(date|invoice|bill)\b', caseSensitive: false);
    final numericDateRegex = RegExp(
      r'(\b\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}\b)|(\b\d{4}[\/\-]\d{1,2}[\/\-]\d{1,2}\b)',
    );
    final monthNameRegex = RegExp(
      r'\b(\d{1,2})\s*(jan|january|feb|february|mar|march|apr|april|may|jun|june|jul|july|aug|august|sep|sept|september|oct|october|nov|november|dec|december)\s*(\d{2,5})\b',
    );
    final monthNameRegexAlt = RegExp(
      r'\b(jan|january|feb|february|mar|march|apr|april|may|jun|june|jul|july|aug|august|sep|sept|september|oct|october|nov|november|dec|december)\s*(\d{1,2})[,]?\s*(\d{2,5})\b',
    );

    String? rawDate;
    final lines = lowerText.split('\n');
    for (final line in lines) {
      if (!keywordRegex.hasMatch(line)) continue;
      rawDate = monthNameRegex.firstMatch(line)?.group(0) ??
          monthNameRegexAlt.firstMatch(line)?.group(0) ??
          numericDateRegex.firstMatch(line)?.group(0);
      if (rawDate != null) break;
    }

    rawDate ??= monthNameRegex.firstMatch(lowerText)?.group(0) ??
        monthNameRegexAlt.firstMatch(lowerText)?.group(0) ??
        numericDateRegex.firstMatch(lowerText)?.group(0);
    if (rawDate == null) return null;

    DateTime? parsed = _parseMonthNameDate(rawDate) ?? _parseNumericDate(rawDate);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  DateTime? _parseMonthNameDate(String raw) {
    final match = RegExp(
      r'\b(\d{1,2})\s*(jan|january|feb|february|mar|march|apr|april|may|jun|june|jul|july|aug|august|sep|sept|september|oct|october|nov|november|dec|december)\s*(\d{2,5})\b',
    ).firstMatch(raw);
    final matchAlt = RegExp(
      r'\b(jan|january|feb|february|mar|march|apr|april|may|jun|june|jul|july|aug|august|sep|sept|september|oct|october|nov|november|dec|december)\s*(\d{1,2})[,]?\s*(\d{2,5})\b',
    ).firstMatch(raw);
    if (match == null && matchAlt == null) return null;

    final months = {
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'sept': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    };

    String? monthToken;
    String? dayToken;
    String? yearToken;

    if (match != null) {
      dayToken = match.group(1);
      monthToken = match.group(2);
      yearToken = match.group(3);
    } else if (matchAlt != null) {
      monthToken = matchAlt.group(1);
      dayToken = matchAlt.group(2);
      yearToken = matchAlt.group(3);
    }

    final month = months[monthToken ?? ''] ?? 0;
    final day = int.tryParse(dayToken ?? '') ?? 0;
    int year = int.tryParse(yearToken ?? '') ?? 0;
    if (yearToken != null && yearToken.length > 4) {
      year = int.tryParse(yearToken.substring(yearToken.length - 4)) ?? 0;
    }
    if (year > 0 && year < 100) {
      year += 2000;
    }

    if (year <= 0 || month <= 0 || day <= 0) return null;
    if (month > 12 || day > 31) return null;
    final parsed = DateTime(year, month, day);
    if (parsed.month != month || parsed.day != day) return null;
    return parsed;
  }

  DateTime? _parseNumericDate(String raw) {
    final parts = raw.split(RegExp(r'[\/\-]'));
    if (parts.length != 3) return null;

    int year;
    int month;
    int day;

    if (parts[0].length == 4) {
      year = int.tryParse(parts[0]) ?? 0;
      month = int.tryParse(parts[1]) ?? 0;
      day = int.tryParse(parts[2]) ?? 0;
    } else {
      day = int.tryParse(parts[0]) ?? 0;
      month = int.tryParse(parts[1]) ?? 0;
      year = int.tryParse(parts[2]) ?? 0;
      if (year > 0 && year < 100) {
        year += 2000;
      }
    }

    if (year <= 0 || month <= 0 || day <= 0) return null;
    if (month > 12 || day > 31) return null;

    final parsed = DateTime(year, month, day);
    if (parsed.month != month || parsed.day != day) return null;
    return parsed;
  }

  String? _inferCategory(String text) {
    final lowerText = text.toLowerCase();
    final rules = <String, List<String>>{
      'food': ['restaurant', 'cafe', 'food', 'dine', 'pizza', 'burger', 'swiggy', 'zomato'],
      'transport': ['uber', 'ola', 'taxi', 'metro', 'bus', 'train', 'fuel', 'petrol'],
      'shopping': ['mall', 'fashion', 'clothing', 'amazon', 'flipkart', 'store', 'shopping'],
      'entertainment': ['movie', 'cinema', 'theatre', 'concert', 'netflix', 'prime'],
      'health': ['pharmacy', 'medical', 'hospital', 'clinic', 'doctor', 'medicine'],
      'utilities': ['electricity', 'water', 'gas', 'bill', 'recharge', 'utility'],
      'education': ['school', 'college', 'tuition', 'course', 'class', 'exam'],
      'travel': ['flight', 'hotel', 'airline', 'booking', 'travel'],
      'personal': ['salon', 'spa', 'gym', 'personal'],
      'home': ['rent', 'home', 'apartment', 'furniture'],
      'salary': ['salary', 'payroll', 'payout'],
      'other_income': ['refund', 'interest', 'cashback', 'bonus'],
    };

    for (final entry in rules.entries) {
      for (final keyword in entry.value) {
        if (lowerText.contains(keyword)) {
          return entry.key;
        }
      }
    }

    return null;
  }

  void dispose() => _recognizer.close();
}