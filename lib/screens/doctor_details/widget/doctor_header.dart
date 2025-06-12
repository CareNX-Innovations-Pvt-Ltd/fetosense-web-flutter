import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorDetailsCubit>();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
                "Doctor Details",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () async {
              try {
                final state = cubit.state;
                await ExcelExportService.exportDoctorsToExcel(
                  context,
                  state.filteredDoctors,
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
              }
            },
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }
}
