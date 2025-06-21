import 'package:flutter/material.dart';
import '../device_edit_cubit.dart';
import 'device_textfield.dart';

class DeviceEditForm extends StatelessWidget {
  final DeviceEditCubit cubit;
  final VoidCallback onClose;

  const DeviceEditForm({super.key, required this.cubit, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF202324), Color(0xFF181A1B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Device Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Container(height: 2, width: 50, color: const Color(0xFF1A86AD)),
            const SizedBox(height: 16),
            DeviceTextField(
              label: "KIT Id",
              controller: cubit.deviceCodeController,
              hint: "Enter KIT Id",
              enabled: true,
            ),
            const SizedBox(height: 12),
            DeviceTextField(
              label: "Serial number",
              controller: cubit.tabletSerialNumberController,
              hint: "Enter tablet serial number",
              enabled: false,
            ),
            const SizedBox(height: 12),
            DeviceTextField(
              label: "Device Id",
              controller: cubit.deviceNameController,
              hint: "Enter Bluetooth Id",
              enabled: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: cubit.updateChanges,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1A86AD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: Color(0xFF1A86AD),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A86AD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
