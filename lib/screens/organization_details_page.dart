import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class OrganizationDetailsPage extends StatefulWidget {
  final Client client;

  const OrganizationDetailsPage({super.key, required this.client});

  @override
  State<OrganizationDetailsPage> createState() =>
      _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
  late Databases db;
  List<models.Document> organizations = [];

  DateTime? fromDate;
  DateTime? tillDate;

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    try {
      final result = await db.listDocuments(
        databaseId: '67e14dc00025fa9f71ad', // Replace with your DB ID
        collectionId: '67e293bc001845f81688', // Replace with your Collection ID
      );
      setState(() {
        organizations = result.documents;
      });
    } catch (e) {
      print("Error fetching organizations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.apartment, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "Organization Details",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: Colors.white),
            const SizedBox(height: 20),

            // Filter Row
            Row(
              children: [
                _datePicker("From Date"),
                const SizedBox(width: 16),
                _datePicker("Till Date"),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _fetchOrganizations,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text("Get Data"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowColor: MaterialStateProperty.all(
                      const Color(0xFF333333),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Device",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Doctors",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Mother",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Test",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Mobile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Status",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Created On",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Address",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Action",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows:
                        organizations.map((org) {
                          final data = org.data;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  data['name'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['device']?.toString() ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['doctors']?.toString() ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['mother']?.toString() ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['test']?.toString() ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['mobile'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['status'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['created_on'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['address'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['email'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),

            // Pagination Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  const Text(
                    "Items per page:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    dropdownColor: const Color(0xFF2A2A2A),
                    value: 5,
                    items:
                        [5, 10, 25, 50, 100].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    onChanged: (_) {},
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "1–${organizations.length} of ${organizations.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePicker(String label) {
    DateTime? selectedDate = label == "From Date" ? fromDate : tillDate;

    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            builder:
                (context, child) =>
                    Theme(data: ThemeData.dark(), child: child!),
          );
          if (picked != null) {
            setState(() {
              if (label == "From Date") {
                fromDate = picked;
              } else {
                tillDate = picked;
              }
            });
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              hintText:
                  selectedDate != null
                      ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                      : 'Select date',
              hintStyle: const TextStyle(color: Colors.white),
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
