import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../widget/columns.dart';

/// A StatefulWidget that represents the Doctor Edit popup dialog.
///
/// This widget allows the user to edit the details of a doctor, such as their name, mobile number, and email.
/// It provides a form for editing the doctor's information and allows for resetting the doctor's password.
/// Upon successful editing, the doctor’s data is updated in the database.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
/// The [data] contains the current doctor's data that is being edited.
/// The [documentId] is the unique identifier of the doctor document in the database.
/// The [onClose] callback is triggered when the user closes the popup.
class DoctorEditPopup extends StatefulWidget {
  final Client client;
  final Map<String, dynamic> data;
  final String documentId;
  final VoidCallback onClose;

  const DoctorEditPopup({
    super.key,
    required this.client,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  State<DoctorEditPopup> createState() => _DoctorEditPopupState();
}

class _DoctorEditPopupState extends State<DoctorEditPopup> {
  bool showEditForm = false;
  late Databases db;
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);
    final data = widget.data;
    nameController = TextEditingController(text: data['name'] ?? '');
    mobileController = TextEditingController(text: data['mobile'] ?? '');
    emailController = TextEditingController(text: data['email'] ?? '');
  }

  /// Updates the doctor’s details in the database with the new data entered in the form.
  Future<void> _updateChanges() async {
    try {
      final updatedData = {
        'name': nameController.text.trim(),
        'mobile': mobileController.text.trim(),
        'email': emailController.text.trim(),
      };

      await db.updateDocument(
        databaseId: '67e14dc00025fa9f71ad',
        collectionId: '67e293bc001845f81688',
        documentId: widget.documentId,
        data: updatedData,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Doctor updated successfully")),
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E4346)),
      ),
      child: Row(
        children: [
          // Static Info Card
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
                  Image.asset(
                    'assets/images/doctor/48-481383_doctor-icon-png-transparent-png.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.data['name'] ?? '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: const Color(0xFF1A86AD),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Reset Password"),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Doctor Details",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  buildColumnWithTextField(
                    "Email",
                    emailController,
                    "Enter email",
                    true,
                  ),
                  const SizedBox(height: 10),

                  buildColumnWithTextField(
                    "Name",
                    nameController,
                    "Enter name",
                    false,
                  ),
                  const SizedBox(height: 10),
                  buildColumnWithTextField(
                    "Mobile",
                    mobileController,
                    "Enter mobile number",
                    false,
                    isNumber: true,
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

  /// Builds a stat card that displays a count and label with an icon.
  ///
  /// [count] The count value to be displayed on the stat card.
  /// [label] The label for the stat card.
  /// [icon] The icon associated with the stat.
  /// [color] The background color of the stat card.
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

  /// Helper widget for displaying label-value pairs.
  ///
  /// [label] The label for the value.
  /// [value] The value to be displayed.
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

  /// Helper widget for displaying a row with a label and value.
  ///
  /// [label] The label for the value.
  /// [value] The value to be displayed.
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
