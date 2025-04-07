import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../widget/columns.dart';

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

  Future<void> _updateChanges() async {
    try {
      final updatedData = {
        'name': nameController.text.trim(),
        'mobile': mobileController.text.trim(),
        'email': emailController.text.trim(),
      };

      await db.updateDocument(
        databaseId: '67ece4a7002a0a732dfd',
        collectionId: '67f36a7e002c46ea05f0',
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
                  // ElevatedButton.icon(
                  //   onPressed: () => setState(() => showEditForm = true),
                  //   icon: const Icon(Icons.edit, size: 14),
                  //   label: const Text("Edit"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF1A86AD),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
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
