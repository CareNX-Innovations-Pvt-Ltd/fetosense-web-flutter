import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizationFilters extends StatelessWidget {
  final TextEditingController fromDateController;
  final TextEditingController tillDateController;
  final TextEditingController searchController;

  const OrganizationFilters({
    Key? key,
    required this.fromDateController,
    required this.tillDateController,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "From Date",
                  selectedDate:
                      context.read<OrganizationCubit>().state.fromDate,
                  controller: fromDateController,
                  onDateCleared:
                      () => context.read<OrganizationCubit>().setFromDate(null),
                  onDateSelected:
                      (picked) =>
                          context.read<OrganizationCubit>().setFromDate(picked),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "Till Date",
                  selectedDate:
                      context.read<OrganizationCubit>().state.tillDate,
                  controller: tillDateController,
                  onDateCleared:
                      () => context.read<OrganizationCubit>().setTillDate(null),
                  onDateSelected:
                      (picked) =>
                          context.read<OrganizationCubit>().setTillDate(picked),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed:
                      () =>
                          context
                              .read<OrganizationCubit>()
                              .fetchOrganizations(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Color(0xFF1A86AD)),
                  ),
                  child: const Text(
                    "Get Data",
                    style: TextStyle(color: Color(0xFF1A86AD)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF181A1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
