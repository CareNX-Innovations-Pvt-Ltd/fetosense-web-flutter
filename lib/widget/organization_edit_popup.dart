import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'columns.dart';

/// A StatefulWidget that represents the Organization Edit Popup.
///
/// This widget is used to edit the details of an organization. It allows the user to update
/// fields such as organization name, contact person, mobile number, email, address, status,
/// designation, state, and city. It uses a form with various input fields, including text fields
/// and dropdowns, to collect the new values. The changes are then sent to the database when the user
/// presses the "Update" button.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
/// The [data] represents the current organization data that will be populated into the form fields.
/// The [documentId] is the unique ID of the organization document that is being edited.
/// The [onClose] is a callback that is called when the popup is closed.
class OrganizationEditPopup extends StatefulWidget {
  final Client client;
  final Map<String, dynamic> data;
  final String documentId;
  final VoidCallback onClose;

  const OrganizationEditPopup({
    super.key,
    required this.client,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  State<OrganizationEditPopup> createState() => _OrganizationEditPopupState();
}

class _OrganizationEditPopupState extends State<OrganizationEditPopup> {
  bool showEditForm = false;
  late Databases db;
  late TextEditingController nameController;
  late TextEditingController contactPersonController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  String? selectedType;
  String? selectedDesignation;
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);
    final data = widget.data;
    nameController = TextEditingController(
      text: data['organizationName'] ?? '',
    );
    contactPersonController = TextEditingController(
      text: data['contactPerson'] ?? '',
    );
    mobileController = TextEditingController(text: data['mobile'] ?? '');
    emailController = TextEditingController(text: data['email'] ?? '');
    addressController = TextEditingController(text: data['addressLine'] ?? '');
    selectedType =
        ['sold', 'demo', 'testing'].contains(data['status'])
            ? data['status']
            : null;
    selectedDesignation =
        ['Admin', 'Staff'].contains(data['designation'])
            ? data['designation']
            : null;
    selectedState =
        ['Gujarat', 'Maharashtra'].contains(data['state'])
            ? data['state']
            : null;
    selectedCity =
        ['Ahmedabad', 'Mumbai'].contains(data['city']) ? data['city'] : null;
  }

  /// Updates the organization with the new values entered in the form fields.
  /// This function sends the updated data to the database using the Appwrite client.
  Future<void> _updateChanges() async {
    try {
      final updatedData = {
        'organizationName': nameController.text.trim(),
        'status': selectedType,
        'contactPerson': contactPersonController.text.trim(),
        'designation': selectedDesignation,
        'mobile': mobileController.text.trim(),
        'email': emailController.text.trim(),
        'addressLine': addressController.text.trim(),
        'state': selectedState,
        'city': selectedCity,
      };

      await db.updateDocument(
        databaseId: '67ece4a7002a0a732dfd',
        collectionId: '67f36a7e002c46ea05f0',
        documentId: widget.documentId,
        data: updatedData,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Organization updated successfully")),
        );
      }
      widget.onClose();
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  /// Builds the widget layout for the organization edit popup, which includes the form fields
  /// and buttons for submitting or canceling the changes.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        color: const Color(0xFF181A1B),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E4346)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181A1B),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF3E4346)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.business,
                    color: Color(0xFF3E91C8),
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.data['organizationName'] ?? 'Organization Name',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    widget.data['mobile'] ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _statCard(
                        count: widget.data['mother']?.toString() ?? "0",
                        label: "Mothers",
                        icon: Icons.pregnant_woman,
                        color: Colors.red.shade900,
                      ),
                      const SizedBox(width: 10),
                      _statCard(
                        count: widget.data['test']?.toString() ?? "0",
                        label: "Tests",
                        icon: Icons.monitor_heart,
                        color: Colors.teal.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _tileCard(
                    label: "Address",
                    value:
                        addressController.text.isEmpty
                            ? "NA"
                            : addressController.text,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Organization Details",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: buildColumnWithTextField(
                          "Organization Name",
                          nameController,
                          "Enter organization name",
                          false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildColumnWithDropdown(
                          "Type",
                          ['sold', 'demo', 'testing'],
                          selectedType,
                          "Select type",
                          (val) => setState(() => selectedType = val),
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: buildColumnWithTextField(
                          "Contact Person",
                          contactPersonController,
                          "Enter contact person",
                          false,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: buildColumnWithDropdown(
                          "Designation",
                          ['Admin', 'Staff'],
                          selectedDesignation,
                          "Select designation",
                          (val) => setState(() => selectedDesignation = val),
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: buildColumnWithTextField(
                          "Mobile",
                          mobileController,
                          "Enter mobile",
                          false,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: buildColumnWithTextField(
                          "Email",
                          emailController,
                          "Enter email",
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  buildColumnWithTextField(
                    "Address",
                    addressController,
                    "Enter address",
                    false,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: buildColumnWithDropdown(
                          "State",
                          ['Gujarat', 'Maharashtra'],
                          selectedState,
                          "Select state",
                          (val) => setState(() => selectedState = val),
                          false,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: buildColumnWithDropdown(
                          "City",
                          ['Ahmedabad', 'Mumbai'],
                          selectedCity,
                          "Select city",
                          (val) => setState(() => selectedCity = val),
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Subtle Save Button
                      OutlinedButton(
                        onPressed: _updateChanges,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1A86AD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(color: Color(0xFF1A86AD)),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Highlighted Cancel Button
                      ElevatedButton(
                        onPressed: widget.onClose,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A86AD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tileCard({required String label, required String value}) {
    return Container(
      width: double.infinity, // Full width of parent
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF121314),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Min height based on content
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _statCard({
    required String count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelValueColumn(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value?.toString() ?? '0',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
