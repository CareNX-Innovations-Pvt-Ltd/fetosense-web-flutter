import 'package:flutter/material.dart';

class CaptchaCheckbox extends StatefulWidget {
  final Function(bool) onVerified;

  const CaptchaCheckbox({super.key, required this.onVerified});

  @override
  State<CaptchaCheckbox> createState() => _CaptchaCheckboxState();
}

class _CaptchaCheckboxState extends State<CaptchaCheckbox> {
  bool _isChecked = false;
  bool _captchaPassed = false;

  Future<void> _showCaptchaDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey.shade900, // dark teal
            title: const Text(
              "Verify you're human",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Please confirm that you're not a robot.",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("I'm not a robot"),
              ),
            ],
          ),
    );

    if (result == true) {
      setState(() {
        _captchaPassed = true;
        _isChecked = true;
      });
      widget.onVerified(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (value) {
              if (_captchaPassed) {
                setState(() => _isChecked = value ?? false);
                widget.onVerified(_isChecked);
              } else {
                _showCaptchaDialog();
              }
            },
            activeColor: Colors.tealAccent[700],
            checkColor: Colors.white,
          ),
          const Text(
            "I'm not a robot",
            style: TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          Icon(
            Icons.verified_user,
            color: _isChecked ? Colors.green : Colors.white70,
          ),
        ],
      ),
    );
  }
}
