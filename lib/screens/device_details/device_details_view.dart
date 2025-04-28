import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/device_edit/device_edit_view.dart';
import 'package:fetosense_mis/screens/device_edit_popup.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_details_cubit.dart';

class DeviceDetailsView extends StatelessWidget {
  const DeviceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceDetailsCubit()..init(),
      child: const _DeviceDetailsView(),
    );
  }
}

class _DeviceDetailsView extends StatelessWidget {
  const _DeviceDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceDetailsCubit, DeviceDetailsState>(
      builder: (context, state) {
        final cubit = context.read<DeviceDetailsCubit>();

        return Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF181A1B),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFF272A2C)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              _buildFilters(context, cubit, state),
              const SizedBox(height: 20),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildDataTable(context, state),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
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

  Widget _buildFilters(
    BuildContext context,
    DeviceDetailsCubit cubit,
    DeviceDetailsState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "From Date",
                  selectedDate: state.fromDate,
                  controller: TextEditingController(
                    text: formatDate(state.fromDate?.toIso8601String()),
                  ),
                  onDateSelected: cubit.updateFromDate,
                  onDateCleared: () => cubit.updateFromDate(null),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "Till Date",
                  selectedDate: state.tillDate,
                  controller: TextEditingController(
                    text: formatDate(state.fromDate?.toIso8601String()),
                  ),
                  onDateSelected: cubit.updateTillDate,
                  onDateCleared: () => cubit.updateTillDate(null),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: cubit.fetchDeviceData,
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
            onChanged: cubit.applySearch,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF181A1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, DeviceDetailsState state) {
    return DataTable(
      columnSpacing: 16,
      headingRowColor: WidgetStateProperty.all(const Color(0xFF181A1B)),
      columns: [
        _tableHeader("Doppler Number"),
        _tableHeader("Device Code"),
        _tableHeader("Organization"),
        _tableHeader("Mother"),
        _tableHeader("Test"),
        _tableHeader("CreatedOn"),
        _tableHeader("Version"),
        _tableHeader("Action"),
      ],
      rows:
          state.filteredDevices
              .map((device) => _buildDataRow(context, device))
              .toList(),
    );
  }

  static DataColumn _tableHeader(String title) {
    return DataColumn(
      label: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  static DataRow _buildDataRow(BuildContext context, models.Document device) {
    final data = device.data;
    return DataRow(
      cells: [
        _tableCell(data['deviceName']),
        _tableCell(data['deviceCode']),
        _tableCell(data['organizationName']),
        _tableCell(data['noOfMother']),
        _tableCell(data['noOfTests']),
        _tableCell(formatDate(data['createdOn'])),
        _tableCell(data['appVersion']),
        DataCell(
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => Dialog(
                      insetPadding: const EdgeInsets.all(20),
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 600,
                        child: DeviceEditPopup(
                          data: device.data,
                          documentId: device.$id,
                          onClose: () => Navigator.pop(context),
                        ),
                      ),
                    ),
              );
            },
            child: const Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ),
      ],
    );
  }

  static DataCell _tableCell(dynamic value) {
    return DataCell(
      Text(
        value?.toString() ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
