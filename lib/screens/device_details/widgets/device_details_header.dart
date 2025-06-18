import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';

class DeviceDetailsHeader extends StatelessWidget {
  const DeviceDetailsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1F2223),
        border: Border(
          bottom: BorderSide(color: Color(0xFF3E4346), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.apartment, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Device Details",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed:
                () => context.read<DeviceDetailsCubit>().downloadExcel(context),
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }
}
