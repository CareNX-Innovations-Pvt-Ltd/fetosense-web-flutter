// import 'package:flutter/material.dart';
//
// import 'column_dropdown.dart';
//
// String? selectedOrganizationId;
// String? selectedOrganizationName;
//
// List<Map<String, String>> organizationList = [];
//
// Widget buildOrganizationDropdown() {
//   return buildColumnWithDropdown(
//     "Organization",
//     organizationList.map((e) => e['name']!).toList(),
//     selectedOrganizationName,
//     "Select Organization",
//     (value) {
//       final selected = organizationList.firstWhere((e) => e['name'] == value);
//       setState(() {
//         selectedOrganizationName = selected['name'];
//         selectedOrganizationId = selected['id'];
//       });
//     },
//     true,
//   );
// }
