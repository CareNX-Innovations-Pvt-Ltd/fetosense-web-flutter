import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/services/excel_services/mothers_excel_download.dart';
import '../utils/fetch_mothers.dart';

/// A StatefulWidget that represents the Mother Details page.
///
/// This page displays a list of mothers along with their details such as name, organization, device, doctor, and tests.
/// It provides search and filtering functionality based on date range and allows the user to download the filtered
/// mothers data in Excel format. The page is responsible for fetching, filtering, and displaying mother-related data.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
class MotherDetailsPage extends StatefulWidget {
  final Client client;

  const MotherDetailsPage({super.key, required this.client});

  @override
  State<MotherDetailsPage> createState() => _MotherDetailsPageState();
}

class _MotherDetailsPageState extends State<MotherDetailsPage> {
  late Databases db;
  List<models.Document> allMothers = [];
  List<models.Document> filteredMothers = [];

  DateTime? fromDate;
  DateTime? tillDate;

  late TextEditingController fromDateController;
  late TextEditingController tillDateController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);
    fromDateController = TextEditingController();
    tillDateController = TextEditingController();
    searchController.addListener(_applySearchFilter);
    _fetchMothers();
  }

  @override
  void dispose() {
    fromDateController.dispose();
    tillDateController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// Fetches the list of mothers from the database based on the date range and updates the state with the results.
  Future<void> _fetchMothers() async {
    try {
      final result = await fetchMothers(
        db,
        fromDate: fromDate,
        tillDate: tillDate,
      );

      setState(() {
        allMothers = result;
        filteredMothers = result;
      });

      _applySearchFilter();
    } catch (e) {
      print("Error fetching mothers: $e");
    }
  }

  /// Applies the search filter based on the text entered in the search input field.
  /// It filters the mothers list by the organization name.
  void _applySearchFilter() {
    final keyword = searchController.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      setState(() => filteredMothers = allMothers);
    } else {
      setState(() {
        filteredMothers =
            allMothers.where((org) {
              final name =
                  org.data['organizationName']?.toString().toLowerCase() ?? '';
              return name.contains(keyword);
            }).toList();
      });
    }
  }

  /// Downloads the filtered mothers data in Excel format.
  void _downloadExcel() async {
    try {
      await ExcelExportService.exportMothersToExcel(context, filteredMothers);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
    }
  }

  /// Builds the layout for the Mother Details page, including the date pickers, search field,
  /// and a data table displaying the filtered mother details.
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181A1B),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF272A2C), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1F2223),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF3E4346), width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.apartment, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Mother Details",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: _downloadExcel,
                    tooltip: 'Download Excel',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 15.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: customDatePicker(
                          context: context,
                          label: "From Date",
                          selectedDate: fromDate,
                          controller: fromDateController,
                          onDateCleared: () => setState(() => fromDate = null),
                          onDateSelected:
                              (picked) => setState(() => fromDate = picked),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: customDatePicker(
                          context: context,
                          label: "Till Date",
                          selectedDate: tillDate,
                          controller: tillDateController,
                          onDateCleared: () => setState(() => tillDate = null),
                          onDateSelected:
                              (picked) => setState(() => tillDate = picked),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _fetchMothers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: Color(0xFF1A86AD)),
                          ),
                          child: const Text(
                            "Get Data",
                            style: TextStyle(color: Color(0xFF1A86AD)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF181A1B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xFF181A1B),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Organization",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Device",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Doctor",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Test",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      filteredMothers.map((org) {
                        final data = org.data;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                data['name'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Text(
                                data['organizationName']?.toString() ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Text(
                                data['deviceName']?.toString() ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Text(
                                data['doctorName']?.toString() ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Text(
                                data['noOfTests']?.toString() ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
