import 'package:flutter/material.dart';

Widget customDatePicker({
  required BuildContext context,
  required String label,
  required DateTime? selectedDate,
  required TextEditingController controller,
  required VoidCallback onDateCleared,
  required ValueChanged<DateTime> onDateSelected,
}) {
  return TextFormField(
    readOnly: true,
    controller: controller,
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder:
            (context, child) => Theme(data: ThemeData.dark(), child: child!),
      );
      if (picked != null) {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
        onDateSelected(picked);
      }
    },
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      hintText: 'Select date',
      hintStyle: const TextStyle(color: Colors.white),
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF181A1B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      suffixIcon: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A86AD),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 1, height: 30, color: Colors.white24),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              tooltip: 'Clear date',
              onPressed:
                  selectedDate != null
                      ? () {
                        controller.clear();
                        onDateCleared();
                      }
                      : null,
            ),
          ],
        ),
      ),
    ),
  );
}
