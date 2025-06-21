import 'package:flutter/material.dart';

Widget _buildLabel(String label, bool isRequired) {
  return Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      if (isRequired)
        const Text(
          ' *',
          style: TextStyle(color: Colors.redAccent, fontSize: 13),
        ),
    ],
  );
}

InputDecoration _inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),

    filled: true,
    fillColor: const Color(0xFF1F2123),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF3E91C8), width: 1.5),
    ),
  );
}

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
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A2D2F), Color(0xFF1F2123)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
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

Widget buildColumnWithDropdown(
  String label,
  List<String> items,
  String? selectedValue,
  String hintText,
  Function(String?) onChanged,
  bool isRequired,
) {
  final bool isDisabled = items.isEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label, isRequired),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A2D2F), Color(0xFF1F2123)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: items.contains(selectedValue) ? selectedValue : null,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: isDisabled ? null : onChanged,
          decoration: _inputDecoration(hintText),
          dropdownColor: const Color(0xFF1F2123),
          validator:
              isRequired
                  ? (val) =>
                      (val == null || val.isEmpty) ? "$label is required" : null
                  : null,
        ),
      ),
    ],
  );
}
