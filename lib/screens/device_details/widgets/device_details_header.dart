import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';

class DeviceDetailsHeader extends StatelessWidget {
  const DeviceDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeviceDetailsCubit>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.apartment, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            "Device Details",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => cubit.downloadExcel(context),
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }
}
