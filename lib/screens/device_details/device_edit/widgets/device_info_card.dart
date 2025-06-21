import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_stat_card.dart';
import 'device_tile_card.dart';
import '../device_edit_cubit.dart';

class DeviceInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const DeviceInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tabletSerial =
        context.read<DeviceEditCubit>().tabletSerialNumberController.text;

    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF202324), Color(0xFF181A1B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFF3E4346)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/device/doppler.png', height: 70),
            const SizedBox(height: 12),
            Text(
              data['deviceName'] ?? "NA",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data['deviceCode'] ?? "NA",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              data['email'] ?? "NA",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                DeviceStatCard(
                  count: data['mother']?.toString() ?? "0",
                  label: "Mothers",
                  icon: Icons.pregnant_woman,
                  color: Colors.red.shade900,
                ),
                const SizedBox(width: 8),
                DeviceStatCard(
                  count: data['test']?.toString() ?? "0",
                  label: "Tests",
                  icon: Icons.monitor_heart,
                  color: Colors.teal.shade700,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                DeviceTileCard(
                  imagePath: 'assets/images/device/tablet.png',
                  label: 'Tablet Serial No.',
                  value: tabletSerial.isEmpty ? 'NA' : tabletSerial,
                ),
                const SizedBox(width: 8),
                DeviceTileCard(
                  imagePath: 'assets/images/device/fetosense kit.png',
                  label: 'Kit Id',
                  value: data['deviceCode'] ?? 'NA',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
