// import 'package:fetosense_mis/core/network/appwrite_config.dart';
// import 'package:fetosense_mis/core/network/dependency_injection.dart';
// import 'package:fetosense_mis/widget/custom_date_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
// import 'package:fetosense_mis/core/services/excel_services.dart';
// import '../utils/fetch_devices.dart';
// import '../utils/format_date.dart';
// import 'device_edit/device_edit_view.dart';
// import 'device_edit_popup.dart';
//
// /// A StatefulWidget that represents the Device Details page.
// ///
// /// This page displays a table of device details, which includes columns like device name, device code,
// /// organization, mother, test, created date, and version. It also provides functionality for filtering the devices
// /// by date range and searching by organization name. Additionally, users can export the filtered device data as an Excel file.
// ///
// /// The page also provides a button to open the device edit popup for modifying device details.
// ///
// /// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
// class DeviceDetailsPage extends StatefulWidget {
//   const DeviceDetailsPage({super.key});
//
//   @override
//   State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
// }
//
// class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
//   late Databases db;
//   final client = locator<AppwriteService>().client;
//
//   List<models.Document> allDevices = [];
//   List<models.Document> filteredDevices = [];
//
//   DateTime? fromDate;
//   DateTime? tillDate;
//
//   late TextEditingController fromDateController;
//   late TextEditingController tillDateController;
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     db = Databases(client);
//     fromDateController = TextEditingController();
//     tillDateController = TextEditingController();
//     searchController.addListener(_applySearchFilter);
//     _fetchDevices();
//   }
//
//   @override
//   void dispose() {
//     fromDateController.dispose();
//     tillDateController.dispose();
//     searchController.dispose();
//     super.dispose();
//   }
//
//   /// Fetches device data from the database, filtering by the selected date range.
//   Future<void> _fetchDevices() async {
//     try {
//       final result = await fetchDevices(
//         db,
//         fromDate: fromDate,
//         tillDate: tillDate,
//       );
//
//       setState(() {
//         allDevices = result;
//         filteredDevices = result;
//       });
//
//       _applySearchFilter();
//     } catch (e) {
//       print("Error fetching devices: $e");
//     }
//   }
//
//   /// Applies the search filter to the list of devices based on the text entered in the search field.
//   void _applySearchFilter() {
//     final keyword = searchController.text.trim().toLowerCase();
//
//     if (keyword.isEmpty) {
//       setState(() => filteredDevices = allDevices);
//     } else {
//       setState(() {
//         filteredDevices =
//             allDevices.where((org) {
//               final name =
//                   org.data['organizationName']?.toString().toLowerCase() ?? '';
//               return name.contains(keyword);
//             }).toList();
//       });
//     }
//   }
//
//   /// Downloads the filtered device data as an Excel file.
//   void _downloadExcel() async {
//     try {
//       await ExcelExportService.exportDevicesToExcel(context, filteredDevices);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.topCenter,
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF181A1B),
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: const Color(0xFF272A2C), width: 1),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(bottom: 8),
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1F2223),
//                 border: Border(
//                   bottom: BorderSide(color: Color(0xFF3E4346), width: 0.5),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.apartment, color: Colors.white, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         "Device Details",
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.download, color: Colors.white),
//                     onPressed: _downloadExcel,
//                     tooltip: 'Download Excel',
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 15.0,
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: customDatePicker(
//                           context: context,
//                           label: "From Date",
//                           selectedDate: fromDate,
//                           controller: fromDateController,
//                           onDateCleared: () => setState(() => fromDate = null),
//                           onDateSelected:
//                               (picked) => setState(() => fromDate = picked),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: customDatePicker(
//                           context: context,
//                           label: "Till Date",
//                           selectedDate: tillDate,
//                           controller: tillDateController,
//                           onDateCleared: () => setState(() => tillDate = null),
//                           onDateSelected:
//                               (picked) => setState(() => tillDate = picked),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       SizedBox(
//                         height: 40,
//                         child: ElevatedButton(
//                           onPressed: _fetchDevices,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             side: const BorderSide(color: Color(0xFF1A86AD)),
//                           ),
//                           child: const Text(
//                             "Get Data",
//                             style: TextStyle(color: Color(0xFF1A86AD)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: searchController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.search, color: Colors.white),
//                       hintText: 'Search',
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Color(0xFF181A1B),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: DataTable(
//                   columnSpacing: 16,
//                   headingRowColor: WidgetStateProperty.all(
//                     const Color(0xFF181A1B),
//                   ),
//                   columns: const [
//                     DataColumn(
//                       label: Text(
//                         "Doppler Number",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "Device Code",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "Organization",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "Mother",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "Test",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "CreatedOn",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "Version",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         "Action",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                   rows:
//                       filteredDevices.map((org) {
//                         final data = org.data;
//                         return DataRow(
//                           cells: [
//                             DataCell(
//                               Text(
//                                 data['deviceName'] ?? '',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               Text(
//                                 data['deviceCode']?.toString() ?? '',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               Text(
//                                 data['organizationName']?.toString() ?? '',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               Text(
//                                 data['noOfMother']?.toString() ?? '',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               Text(
//                                 data['noOfTests']?.toString() ?? '',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               Text(
//                                 formatDate(data['createdOn']),
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               Text(
//                                 data['appVersion']?.toString() ?? '',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             DataCell(
//                               TextButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     barrierDismissible: false,
//                                     builder: (context) {
//                                       return Dialog(
//                                         insetPadding: const EdgeInsets.all(20),
//                                         backgroundColor: Colors.transparent,
//                                         child: SizedBox(
//                                           width:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width *
//                                               0.6,
//                                           height: 600,
//                                           child: DeviceEditPopup(
//                                             data:
//                                                 org.data, // pass full org data here
//                                             documentId: org.$id,
//                                             onClose:
//                                                 () => Navigator.pop(context),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: const Text(
//                                   "Edit",
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
