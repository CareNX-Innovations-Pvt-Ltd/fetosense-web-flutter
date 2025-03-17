import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class OrganizationDetailsPage extends StatefulWidget {
  final Client client;

  OrganizationDetailsPage({required this.client});

  @override
  _OrganizationDetailsPageState createState() => _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
  late Databases databases;
  List<Document> organizations = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    databases = Databases(widget.client);
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '67d500bc0013d0c4a9d9',
        collectionId: '67d7b2720010111a41cb', 
      );
      setState(() {
        organizations = response.documents;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching organizations: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchOrganizations(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Document> filteredOrganizations = organizations
        .where((org) =>
            org.data['name'].toString().toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Organization Details"),
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: _searchOrganizations,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Organization Table
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : DataTable(
                      columnSpacing: 12,
                      headingRowColor:
                          MaterialStateColor.resolveWith((_) => Colors.black54),
                      dataRowColor: MaterialStateColor.resolveWith(
                          (_) => Colors.black87),
                      columns: [
                        DataColumn(
                            label: Text("Name",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Device",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Doctors",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Mothers",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Tests",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Mobile",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Status",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Created On",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Address",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Email",
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text("Action",
                                style: TextStyle(color: Colors.white))),
                      ],
                      rows: filteredOrganizations.map((org) {
                        return DataRow(cells: [
                          DataCell(Text(org.data['name'],
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['device'].toString(),
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['doctors'].toString(),
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['mothers'].toString(),
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['tests'].toString(),
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['mobile'],
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['status'],
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['created_on'],
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['address'],
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text(org.data['email'] ?? "N/A",
                              style: TextStyle(color: Colors.white))),
                          DataCell(
                            TextButton(
                              onPressed: () {
                                // Implement Edit Action
                              },
                              child: Text("Edit",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
