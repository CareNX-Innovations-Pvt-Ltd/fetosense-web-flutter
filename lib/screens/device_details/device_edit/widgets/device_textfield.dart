import 'package:flutter/material.dart';

class DeviceTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool enabled;

  const DeviceTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF121314),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
