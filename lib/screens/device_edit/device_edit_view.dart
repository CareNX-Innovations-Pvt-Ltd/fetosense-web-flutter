import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';

import 'device_edit_cubit.dart';

/// A popup widget for editing device details.
///
/// Wraps the [_DeviceEditView] with a [BlocProvider] and initializes the cubit with device data.
class DeviceEditPopup extends StatelessWidget {
  /// The device data to edit.
  final Map<String, dynamic> data;

  /// The document ID of the device.
  final String documentId;

  /// Callback to close the popup.
  final VoidCallback onClose;

  /// Creates a [DeviceEditPopup] widget.
  const DeviceEditPopup({
    super.key,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final client = locator<AppwriteService>().client;
    final db = Databases(client);

    return BlocProvider(
      create:
          (_) =>
              DeviceEditCubit(db: db, documentId: documentId)..initialize(data),
      child: _DeviceEditView(data: data, onClose: onClose),
    );
  }
}

/// Internal widget that builds the device edit UI.
///
/// Uses [BlocBuilder] to listen to [DeviceEditCubit] state and renders the edit form.
class _DeviceEditView extends StatelessWidget {
  /// The device data to edit.
  final Map<String, dynamic> data;

  /// Callback to close the popup.
  final VoidCallback onClose;

  /// Creates a [_DeviceEditView] widget.
  const _DeviceEditView({required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeviceEditCubit>();

    return BlocListener<DeviceEditCubit, DeviceEditState>(
      listener: (context, state) {
        if (state is DeviceEditSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Device updated successfully')),
          );
          onClose();
        } else if (state is DeviceEditError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        decoration: BoxDecoration(
          color: const Color(0xFF181A1B),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF3E4346)),
        ),
        child: Row(
          children: [_deviceInfoCard(data, context), _editForm(cubit)],
        ),
      ),
    );
  }

  Widget _deviceInfoCard(Map<String, dynamic> data, BuildContext context) {
    final tabletSerial =
        context.read<DeviceEditCubit>().tabletSerialNumberController.text;

    return Expanded(
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
              data['deviceName'] ?? "NA",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              data['deviceCode'] ?? "NA",
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              data['email'] ?? "NA",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _statCard(
                  data['mother']?.toString() ?? "0",
                  "Mothers",
                  Icons.pregnant_woman,
                  Colors.red.shade900,
                ),
                const SizedBox(width: 10),
                _statCard(
                  data['test']?.toString() ?? "0",
                  "Tests",
                  Icons.monitor_heart,
                  Colors.teal.shade700,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _tileCard(
                  'assets/images/device/tablet.png',
                  'Tablet Serial No.',
                  tabletSerial.isEmpty ? 'NA' : tabletSerial,
                ),
                const SizedBox(width: 10),
                _tileCard(
                  'assets/images/device/fetosense kit.png',
                  'Kit Id',
                  data['deviceCode'] ?? 'NA',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _editForm(DeviceEditCubit cubit) {
    return Expanded(
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
            _buildTextField(
              "KIT Id",
              cubit.deviceCodeController,
              "Enter KIT Id",
              true,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Serial number",
              cubit.tabletSerialNumberController,
              "Enter tablet serial number",
              false,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Device Id",
              cubit.deviceNameController,
              "Enter bluetooth Id",
              true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: cubit.updateChanges,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1A86AD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Color(0xFF1A86AD)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onClose,
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    bool enabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF121314),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _statCard(String count, String label, IconData icon, Color color) {
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

  Widget _tileCard(String imagePath, String label, String value) {
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
}
