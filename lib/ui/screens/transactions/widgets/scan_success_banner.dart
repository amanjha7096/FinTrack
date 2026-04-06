import 'package:flutter/material.dart';

class ScanSuccessBanner extends StatelessWidget {
  const ScanSuccessBanner({
    super.key,
    required this.isVisible,
    required this.amountFound,
    required this.merchantFound,
  });

  final bool isVisible;
  final bool amountFound;
  final bool merchantFound;

  @override
  Widget build(BuildContext context) {
    final message = amountFound && merchantFound
        ? 'Receipt scanned — amount and merchant filled in'
        : amountFound
            ? 'Amount found — review and add a note if needed'
            : 'Receipt read — no amount found, please enter manually';

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      offset: isVisible ? const Offset(0, 0) : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        opacity: isVisible ? 1 : 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1D9E75),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}