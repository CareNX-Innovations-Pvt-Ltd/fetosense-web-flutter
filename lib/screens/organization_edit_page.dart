import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

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

  @override
  void dispose() {
    nameController.dispose();
    contactPersonController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _textField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1F2223),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF3E4346)),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: options.contains(value) ? value : null,
      items:
          options.map((val) {
            return DropdownMenuItem(
              value: val,
              child: Text(val, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
      onChanged: onChanged,
      dropdownColor: const Color(0xFF1F2223),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1F2223),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF3E4346)),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
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
        databaseId: '67e14dc00025fa9f71ad',
        collectionId: '67e293bc001845f81688',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        color: const Color(0xFF181A1B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Organization Card (static info)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2223),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3E4346)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.apartment, color: Colors.white, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    widget.data['organizationName'] ?? 'Organization Name',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    widget.data['mobile'] ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.grey),
                  _infoText("Mothers", widget.data['mother']),
                  _infoText("Tests", widget.data['test']),
                  _infoText("Devices", widget.data['device']),
                  _infoText("Doctors", widget.data['doctors']),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address:",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    '${widget.data['addressLine'] ?? ''}, ${widget.data['city'] ?? ''}, ${widget.data['state'] ?? ''}, ${widget.data['country'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Right: Edit form
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Organization Details",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _textField("Organization Name", nameController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdown(
                          "Type",
                          selectedType,
                          ['sold', 'demo', 'testing'],
                          (val) {
                            setState(() => selectedType = val!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          "Contact Person",
                          contactPersonController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdown(
                          "Designation",
                          selectedDesignation,
                          ['Admin', 'Staff'],
                          (val) {
                            setState(() => selectedDesignation = val!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _textField("Mobile", mobileController)),
                      const SizedBox(width: 10),
                      Expanded(child: _textField("Email", emailController)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _textField("Address", addressController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          "State",
                          selectedState,
                          ['Gujarat', 'Maharashtra'],
                          (val) {
                            setState(() => selectedState = val!);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdown(
                          "City",
                          selectedCity,
                          ['Ahmedabad', 'Mumbai'],
                          (val) {
                            setState(() => selectedCity = val!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A86AD),
                        ),
                        child: const Text("Save"),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: widget.onClose,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
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

  Widget _infoText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.grey)),
          Text(
            value?.toString() ?? '0',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
