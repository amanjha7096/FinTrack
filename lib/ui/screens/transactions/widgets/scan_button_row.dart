import 'package:flutter/material.dart';

class ScanButtonRow extends StatelessWidget {
  const ScanButtonRow({
    super.key,
    required this.onCamera,
    required this.onGallery,
    required this.isScanning,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF1D9E75);
    if (isScanning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(color: teal, strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text('Reading receipt...', style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: onCamera,
          icon: const Icon(Icons.camera_alt_outlined, size: 18),
          label: const Text('Scan receipt'),
          style: OutlinedButton.styleFrom(
            foregroundColor: teal,
            side: const BorderSide(color: teal, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onGallery,
          icon: const Icon(Icons.photo_library_outlined, size: 18),
          label: const Text('From gallery'),
          style: OutlinedButton.styleFrom(
            foregroundColor: teal,
            side: const BorderSide(color: teal, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}