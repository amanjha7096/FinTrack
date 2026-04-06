import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/receipt_scanner_service.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../data/repositories/i_goal_repository.dart';
import '../../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../../logic/transaction_bloc/transaction_event.dart';
import 'scan_button_row.dart';
import 'scan_success_banner.dart';

class AddEditTransactionSheet extends StatefulWidget {
  const AddEditTransactionSheet({
    super.key,
    this.transaction,
  });

  final TransactionModel? transaction;

  @override
  State<AddEditTransactionSheet> createState() => _AddEditTransactionSheetState();
}

class _AddEditTransactionSheetState extends State<AddEditTransactionSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _type = 'expense';
  String? _category;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _amountError;
  String? _categoryError;
  bool _isScanning = false;
  bool _showBanner = false;
  ScanResult? _lastScan;
  late final ReceiptScannerService _scanner;
  late final IGoalRepository _goalRepository;
  List<String> _customCategories = [];

  @override
  void initState() {
    super.initState();
    _scanner = getIt<ReceiptScannerService>();
    _goalRepository = getIt<IGoalRepository>();
    if (widget.transaction != null) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount.toStringAsFixed(0);
      _noteController.text = tx.note ?? '';
      _type = tx.type;
      _category = tx.category;
      _date = tx.date;
    }
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    final settings = await _goalRepository.getAppSettings();
    if (!mounted) return;
    setState(() => _customCategories = List<String>.from(settings.customCategories));
  }

  Future<void> _createCustomCategory() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _CreateCategoryDialog(),
    );
    final trimmed = (name ?? '').trim();
    if (trimmed.isEmpty) return;
    final settings = await _goalRepository.getAppSettings();
    final existing = settings.customCategories.map((e) => e.toLowerCase()).toSet();
    if (!existing.contains(trimmed.toLowerCase()) &&
        !Categories.allKeys.map((e) => e.toLowerCase()).contains(trimmed.toLowerCase())) {
      settings.customCategories = [...settings.customCategories, trimmed];
      await _goalRepository.saveAppSettings(settings);
    }
    if (!mounted) return;
    HapticFeedback.selectionClick();
    setState(() {
      _customCategories = List<String>.from(settings.customCategories);
      _category = trimmed;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _amountError = null;
      _categoryError = null;
    });
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() => _amountError = 'Amount must be greater than 0');
      return;
    }
    if (_category == null) {
      setState(() => _categoryError = 'Select a category');
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now();
    final bloc = context.read<TransactionBloc>();

    if (widget.transaction == null) {
      final tx = TransactionModel();
      tx.uuid = const Uuid().v4();
      tx.amount = amount;
      tx.type = _type;
      tx.category = _category!;
      tx.date = DateHelpers.normalizeDate(_date);
      tx.note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
      tx.createdAt = now;
      tx.updatedAt = now;
      tx.isSeeded = false;
      bloc.add(AddTransaction(tx));
    } else {
      final tx = widget.transaction!;
      tx.amount = amount;
      tx.type = _type;
      tx.category = _category!;
      tx.date = DateHelpers.normalizeDate(_date);
      tx.note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
      tx.updatedAt = now;
      bloc.add(UpdateTransaction(tx));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.transaction == null ? 'Transaction added' : 'Transaction updated'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleScan(Future<ScanResult?> scanFuture) async {
    setState(() => _isScanning = true);
    try {
      final result = await scanFuture;
      if (result == null) {
        return;
      }

      _lastScan = result;

      if (result.amount != null) {
        final formatted = result.amount! % 1 == 0
            ? result.amount!.toInt().toString()
            : result.amount!.toStringAsFixed(2);
        _amountController.text = formatted;
      }

      if (result.date != null) {
        _date = result.date!;
      }

      if (result.categoryKey != null && Categories.byKey(result.categoryKey!) != null) {
        _category = result.categoryKey;
      }

      if (result.merchant != null) {
        if (_noteController.text.trim().isEmpty) {
          _noteController.text = result.merchant!;
        }
      }

      HapticFeedback.lightImpact();
      setState(() => _showBanner = true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showBanner = false);
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not read receipt — please enter amount manually'),
          backgroundColor: Color(0xFFA32D2D),
          duration: Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaction != null;
    final availableCategories = Categories.withCustom(_customCategories);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showBanner ? null : 0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: ScanSuccessBanner(
                  isVisible: _showBanner,
                  amountFound: _lastScan?.amount != null,
                  merchantFound: _lastScan?.merchant != null,
                ),
              ),
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit transaction' : 'Add transaction',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (widget.transaction == null) ...[
                const SizedBox(height: 12),
                ScanButtonRow(
                  isScanning: _isScanning,
                  onCamera: () => _handleScan(_scanner.scanFromCamera()),
                  onGallery: () => _handleScan(_scanner.scanFromGallery()),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  errorText: _amountError,
                  hintText: '0',
                ),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'income', label: Text('Income')),
                  ButtonSegment(value: 'expense', label: Text('Expense')),
                ],
                selected: {_type},
                onSelectionChanged: (value) => setState(() => _type = value.first),
              ),
              const SizedBox(height: 16),
              Text('Category', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _createCustomCategory,
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('Custom category'),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableCategories
                    .map(
                      (cat) => InkWell(
                        onTap: () => setState(() => _category = cat.key),
                        child: Container(
                          width: 72,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _category == cat.key
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(cat.icon, color: cat.color, size: 20),
                              const SizedBox(height: 4),
                              Text(cat.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (_categoryError != null) ...[
                const SizedBox(height: 4),
                Text(_categoryError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _date = picked);
                  }
                },
                child: Text('Date: ${_date.day}/${_date.month}/${_date.year}'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Add a note...'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                      : Text(isEdit ? 'Update' : 'Save'),
                ),
              ),
              if (isEdit) ...[
                TextButton(
                  onPressed: () {
                    context.read<TransactionBloc>().add(DeleteTransaction(widget.transaction!.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Transaction deleted'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _CreateCategoryDialog extends StatefulWidget {
  const _CreateCategoryDialog();

  @override
  State<_CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<_CreateCategoryDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create custom category'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: 'Category name'),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
