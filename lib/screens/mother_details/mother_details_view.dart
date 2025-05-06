import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mother_details_cubit.dart';

class MotherDetailsView extends StatelessWidget {
  const MotherDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MotherDetailsCubit(),
      child: const MotherDetails(),
    );
  }
}

class MotherDetails extends StatelessWidget {
  const MotherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = context.read<MotherDetailsCubit>();

    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181A1B),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF272A2C), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildFilterSection(context),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MotherDetailsCubit, MotherDetailsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return _buildDataTable(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cubit = context.read<MotherDetailsCubit>();

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
                "Mother Details",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => cubit.downloadExcel(context),
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final cubit = context.read<MotherDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<MotherDetailsCubit, MotherDetailsState>(
                  buildWhen:
                      (previous, current) =>
                          previous.fromDate != current.fromDate,
                  builder: (context, state) {
                    return customDatePicker(
                      context: context,
                      label: "From Date",
                      selectedDate: state.fromDate,
                      controller: cubit.fromDateController,
                      onDateCleared: cubit.clearFromDate,
                      onDateSelected: cubit.setFromDate,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BlocBuilder<MotherDetailsCubit, MotherDetailsState>(
                  buildWhen:
                      (previous, current) =>
                          previous.tillDate != current.tillDate,
                  builder: (context, state) {
                    return customDatePicker(
                      context: context,
                      label: "Till Date",
                      selectedDate: state.tillDate,
                      controller: cubit.tillDateController,
                      onDateCleared: cubit.clearTillDate,
                      onDateSelected: cubit.setTillDate,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: cubit.fetchMothersId,
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
            controller: cubit.searchController,
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
            onChanged: cubit.setSearchQuery,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(MotherDetailsState state) {
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 16,
        headingRowColor: WidgetStateProperty.all(const Color(0xFF181A1B)),
        columns: const [
          DataColumn(
            label: Text(
              "Name",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              "Organization",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              "Device",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              "Doctor",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              "Test",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows:
            state.filteredMothers.map((org) {
              final data = org.data;
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      data['name'] ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      data['organizationName']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      data['deviceName']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      data['doctorName']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      data['noOfTests']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
