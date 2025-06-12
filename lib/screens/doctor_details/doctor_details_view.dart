import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/widget/doctor_edit_popup.dart'
    show DoctorEditPopup;
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The main view for displaying doctor details.
///
/// Provides a [DoctorDetailsCubit] to manage state and renders the doctor details UI,
/// including filters, search, and a table of doctor data.
class DoctorDetailsView extends StatelessWidget {
  /// Creates a [DoctorDetailsView] widget.
  const DoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorDetailsCubit>();
    cubit.fetchDoctorsId();
    final fromDateController = TextEditingController();
    final tillDateController = TextEditingController();
    final searchController = TextEditingController();

    searchController.addListener(() {
      cubit.applySearchFilter(searchController.text);
    });

    return BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
      builder: (context, state) {
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 15.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: customDatePicker(
                              context: context,
                              label: "From Date",
                              selectedDate: state.fromDate,
                              controller: fromDateController,
                              onDateCleared: () => cubit.updateFromDate(null),
                              onDateSelected:
                                  (picked) => cubit.updateFromDate(picked),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: customDatePicker(
                              context: context,
                              label: "Till Date",
                              selectedDate: state.tillDate,
                              controller: tillDateController,
                              onDateCleared: () => cubit.updateTillDate(null),
                              onDateSelected:
                                  (picked) => cubit.updateTillDate(picked),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: cubit.fetchDoctorsId,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(
                                  color: Color(0xFF1A86AD),
                                ),
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
                ),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildDataTable(context, state.filteredDoctors),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                final state = context.read<DoctorDetailsCubit>().state;
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

  Widget _buildDataTable(BuildContext context, List<models.Document> doctors) {
    if (doctors.isEmpty) {
      return const Center(
        child: Text("No data available", style: TextStyle(color: Colors.white)),
      );
    }
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 16,
        headingRowColor: WidgetStateProperty.all(const Color(0xFF181A1B)),
        columns: [
          DataColumn(label: _columnText("Name")),
          DataColumn(label: _columnText("Email")),
          DataColumn(label: _columnText("Organization")),
          DataColumn(label: _columnText("Mother")),
          DataColumn(label: _columnText("Test")),
          DataColumn(label: _columnText("CreatedOn")),
          DataColumn(label: _columnText("L.O.T")),
          DataColumn(label: _columnText("Version")),
          DataColumn(label: _columnText("Action")),
        ],
        rows:
            doctors.map((doc) {
              final data = doc.data;
              return DataRow(
                cells: [
                  _dataCell(data['name']),
                  _dataCell(data['email']),
                  _dataCell(data['organizationName']),
                  _dataCell(data['noOfMother']),
                  _dataCell(data['noOfTests']),
                  _dataCell(formatDate(data['createdOn'])),
                  _dataCell(formatDate(data['lastLoginTime'])),
                  _dataCell(data['appVersion']),
                  DataCell(
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (context) => Dialog(
                                insetPadding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 600,
                                  child: DoctorEditPopup(
                                    data: data,
                                    documentId: doc.$id,
                                    onClose: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                        );
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  static Text _columnText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    );
  }

  static DataCell _dataCell(dynamic value) {
    return DataCell(
      Text(
        value?.toString() ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
