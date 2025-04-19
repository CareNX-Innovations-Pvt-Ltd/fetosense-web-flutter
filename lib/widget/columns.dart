import 'package:flutter/material.dart';

/// Builds a label widget for a form field.
///
/// This function generates a row containing a text label for a form field.
/// It conditionally adds a red asterisk (`*`) if the `isRequired` parameter is true.
///
/// [label] The text label to display for the form field.
/// [isRequired] A boolean indicating whether the field is required. If true, an asterisk is added to the label.
Widget _buildLabel(String label, bool isRequired) {
  return Row(
    children: [
      Text(label, style: TextStyle(color: Colors.white)),
      if (isRequired) Text(' *', style: TextStyle(color: Colors.red)),
    ],
  );
}

/// Returns an [InputDecoration] for form fields with consistent styling.
///
/// This function provides a standard input decoration with custom styling, including a dark fill color,
/// a border with rounded corners, and a hint text style.
///
/// [hintText] The hint text that will be displayed in the form field.
InputDecoration _inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
    filled: true,
    fillColor: Color(0xFF181A1B),
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(1),
      borderSide: BorderSide(color: Color(0xFF373B3E)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(1),
      borderSide: BorderSide(color: Color(0xFF373B3E)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(1),
      borderSide: BorderSide(color: Color(0xFF373B3E), width: 1),
    ),
  );
}

/// Builds a form field with a text input.
///
/// This widget includes a label, a text field, and validation for required fields.
///
/// [label] The label for the form field.
/// [controller] The controller to manage the text input.
/// [hintText] The hint text to be displayed in the form field.
/// [isRequired] A boolean indicating if the field is required. If true, validation is applied.
/// [isNumber] A boolean indicating if the input should accept numeric values (defaults to false).
Widget buildColumnWithTextField(
  String label,
  TextEditingController controller,
  String hintText,
  bool isRequired, {
  bool isNumber = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label, isRequired),
      SizedBox(height: 6),
      SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.grey),
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: _inputDecoration(hintText),
          validator:
              isRequired
                  ? (value) =>
                      (value == null || value.isEmpty)
                          ? "$label is required"
                          : null
                  : null,
        ),
      ),
    ],
  );
}

/// Builds a form field with a dropdown.
///
/// This widget includes a label, a dropdown list, and validation for required fields.
///
/// [label] The label for the form field.
/// [items] The list of items to be displayed in the dropdown.
/// [selectedValue] The currently selected value in the dropdown.
/// [hintText] The hint text to be displayed in the form field.
/// [onChanged] The callback to handle when the selected value changes.
/// [isRequired] A boolean indicating if the field is required. If true, validation is applied.
Widget buildColumnWithDropdown(
  String label,
  List<String> items,
  String? selectedValue,
  String hintText,
  Function(String?) onChanged,
  bool isRequired,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label, isRequired),
      SizedBox(height: 8),
      SizedBox(
        height: 40,
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(hintText),
          dropdownColor: Colors.black45,
        ),
      ),
    ],
  );
}
