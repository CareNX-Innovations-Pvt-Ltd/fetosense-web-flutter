import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../widget/columns.dart';

/// A StatefulWidget that represents the device edit popup dialog.
///
/// This popup allows the user to edit the details of a device, such as the device code, tablet serial number,
/// and device name. It also provides functionality to update the device information in the database and close the popup.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
/// The [data] contains the current device data that is being edited.
/// The [documentId] is the unique identifier of the device document in the database.
/// The [onClose] callback is triggered when the user closes the popup.
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

  /// Fetches the tablet serial number associated with the device from the database.
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

  /// Updates the device information in the database.
  Future<void> _updateChanges() async {
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
        border: Border.all(color: const Color(0xFF3E4346)),
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
                border: Border.all(color: const Color(0xFF3E4346)),
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

                  buildColumnWithTextField(
                    "KIT Id",
                    deviceCodeController,
                    "Enter KIT Id",
                    true,
                  ),
                  const SizedBox(height: 10),
                  buildColumnWithTextField(
                    "Serial number",
                    tabletSerialNumberController,
                    "Enter tablet serial number",
                    false,
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

  /// A helper widget for building a tile card with an image, label, and value.
  ///
  /// [imagePath] The path to the image to be displayed on the tile.
  /// [label] The label for the tile.
  /// [value] The value to be displayed on the tile.
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

  /// A helper widget for building a stat card that displays a count and label with an icon.
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
}
