import 'package:flutter/material.dart';

/// Custom date picker widget with a text field.
///
/// This widget is a custom implementation of a date picker that displays a text field.
/// When the field is tapped, it opens a date picker dialog. The selected date is displayed
/// in the text field, and the user can clear the date using a button next to the text field.
///
/// [context] The build context, required to display the date picker dialog.
/// [label] The label text for the date picker input field.
/// [selectedDate] The currently selected date. If null, the current date is used as the initial value.
/// [controller] The [TextEditingController] that manages the text input.
/// [onDateCleared] A callback function that is called when the user clears the date.
/// [onDateSelected] A callback function that is called when a date is selected.
Widget customDatePicker({
  required BuildContext context,
  required String label,
  required DateTime? selectedDate,
  required TextEditingController controller,
  required VoidCallback onDateCleared,
  required ValueChanged<DateTime> onDateSelected,
}) {
  //random comment
  return TextFormField(
    readOnly: true,
    controller: controller,
    onTap: () async {
      // Show the date picker dialog when the user taps the field.
      final picked = await showDatePicker(
        context: context,
        initialDate:
            selectedDate ??
            DateTime.now(), // Use selected date or current date.
        firstDate: DateTime(2000), // The earliest selectable date.
        lastDate: DateTime(2100), // The latest selectable date.
        builder:
            (context, child) => Theme(data: ThemeData.dark(), child: child!),
      );
      // If a date is picked, update the controller and trigger the callback.
      if (picked != null) {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
        onDateSelected(picked);
      }
    },
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label, // The label displayed on the field.
      hintText: 'Select date', // The hint text when the field is empty.
      hintStyle: const TextStyle(color: Colors.white),
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF181A1B), // Dark background color.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4), // Rounded corners.
        borderSide: BorderSide.none, // Remove border line.
      ),
      suffixIcon: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A86AD), // Button background color.
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1,
              height: 30,
              color: Colors.white24,
            ), // Divider line.
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ), // Clear button icon.
              tooltip: 'Clear date', // Tooltip for the clear button.
              onPressed:
                  selectedDate !=
                          null // Only allow clear action if a date is selected.
                      ? () {
                        controller.clear(); // Clear the date in the text field.
                        onDateCleared(); // Call the callback when cleared.
                      }
                      : null,
            ),
          ],
        ),
      ),
    ),
  );
}
