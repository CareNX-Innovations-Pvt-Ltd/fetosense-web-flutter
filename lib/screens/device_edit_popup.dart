import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../widget/columns.dart';

class DeviceEditPopup extends StatefulWidget {
  final Client client;
  final Map<String, dynamic> data;
  final String documentId;
  final VoidCallback onClose;

  const DeviceEditPopup({
    super.key,
    required this.client,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  State<DeviceEditPopup> createState() => _DeviceEditPopupState();
}

class _DeviceEditPopupState extends State<DeviceEditPopup> {
  bool showEditForm = false;
  late Databases db;
  late TextEditingController deviceCodeController;
  late TextEditingController tabletSerialNumberController;
  late TextEditingController deviceNameController;

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);
    final data = widget.data;
    deviceCodeController = TextEditingController(
      text: data['deviceCode'] ?? '',
    );
    deviceNameController = TextEditingController(text: data['deviceId'] ?? '');
    tabletSerialNumberController = TextEditingController();
    _fetchTabletSerialNumber();
  }

  Future<void> _fetchTabletSerialNumber() async {
    try {
      final result = await db.listDocuments(
        databaseId: '67e14dc00025fa9f71ad',
        collectionId: '67e676d9bd35888f7291',
        queries: [Query.equal('documentId', widget.documentId)],
      );

      if (result.documents.isNotEmpty) {
        tabletSerialNumberController.text =
            result.documents.first.data['tabletSerialNumber'] ?? '';
      }
    } catch (e) {
      print("Tablet serial number fetch error: $e");
    }
  }

  Future<void> _saveChanges() async {
    try {
      // Update user collection (deviceCode, deviceId)
      await db.updateDocument(
        databaseId: '67e14dc00025fa9f71ad',
        collectionId: '67e293bc001845f81688',
        documentId: widget.documentId,
        data: {
          'deviceCode': deviceCodeController.text.trim(),
          'deviceName': deviceNameController.text.trim(),
        },
      );

      // Update tabletSerialNumber collection
      final tabletResult = await db.listDocuments(
        databaseId: '67e14dc00025fa9f71ad',
        collectionId: '67e293bc001845f81688',
        queries: [Query.equal('documentId', widget.documentId)],
      );

      if (tabletResult.documents.isNotEmpty) {
        final tabletDocId = tabletResult.documents.first.$id;
        await db.updateDocument(
          databaseId: '67e14dc00025fa9f71ad',
          collectionId: '67e64eba00363f40d736',
          documentId: tabletDocId,
          data: {
            'tabletSerialNumber': tabletSerialNumberController.text.trim(),
          },
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Device updated successfully")),
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
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        color: const Color(0xFF181A1B),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // Static Info Card
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF181A1B),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/device/doppler.png', height: 70),
                  const SizedBox(height: 10),
                  Text(
                    widget.data['deviceName'] ?? "NA",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.data['deviceCode'] ?? "NA",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    widget.data['email'] ?? "NA",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => showEditForm = true),
                    icon: const Icon(Icons.edit, size: 15),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: const Color(0xFF1A86AD),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _tileCardWithImage(
                        imagePath: 'assets/images/device/tablet.png',
                        label: "Tablet Serial No.",
                        value:
                            tabletSerialNumberController.text.isEmpty
                                ? "NA"
                                : tabletSerialNumberController.text,
                      ),
                      const SizedBox(width: 10),
                      _tileCardWithImage(
                        imagePath: 'assets/images/device/fetosense kit.png',
                        label: "Kit Id",
                        value: widget.data['deviceCode'] ?? "NA",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (showEditForm)
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Device Details",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: buildColumnWithTextField(
                            "KIT Id",
                            deviceCodeController,
                            "Enter KIT Id",
                            true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildColumnWithTextField(
                            "Serial number",
                            tabletSerialNumberController,
                            "Enter tablet serial number",
                            false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildColumnWithTextField(
                      "Device Id",
                      deviceNameController,
                      "Enter bluetooth Id",
                      true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A86AD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text("Save"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: widget.onClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A86AD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
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

  Widget _tileCardWithImage({
    required String imagePath,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF121314),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 60),
            const SizedBox(height: 8),
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
}
