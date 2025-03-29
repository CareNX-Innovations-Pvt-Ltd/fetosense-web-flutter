import 'package:flutter/material.dart';

Widget _buildLabel(String label, bool isRequired) {
  return Row(
    children: [
      Text(label, style: TextStyle(color: Colors.white)),
      if (isRequired) Text(' *', style: TextStyle(color: Colors.red)),
    ],
  );
}

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
