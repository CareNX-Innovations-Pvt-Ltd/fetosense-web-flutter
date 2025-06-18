import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizationHeader extends StatelessWidget {
  const OrganizationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                "Organization Details",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => context.read<OrganizationCubit>().downloadExcel(),
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }
}
