import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_edit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../organization_details_cubit.dart';

class OrganizationDataTableWidget extends StatelessWidget {
  const OrganizationDataTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationCubit, OrganizationState>(
      builder: (context, state) {
        switch (state.status) {
          case OrganizationStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case OrganizationStatus.error:
            return Center(child: Text('Error: ${state.errorMessage}'));

          case OrganizationStatus.loaded:
            if (state.filteredOrganizationDetails.isEmpty) {
              return const Center(child: Text('No organizations found'));
            }

            return DataTable2(
              columnSpacing: 16,
              horizontalMargin: 12,
              headingRowHeight: 48,
              dataRowHeight: 60,
              minWidth: 1400,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E1F21)),
              dataRowColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.grey.shade800;
                }
                return const Color(0xFF121314);
              }),
              border: TableBorder.all(color: Colors.grey.shade700, width: 1),
              columns: [
                _buildDataColumn('Name', flex: 2),
                _buildDataColumn('Device'),
                _buildDataColumn('Doctors'),
                _buildDataColumn('Mother'),
                _buildDataColumn('Test'),
                _buildDataColumn('Mobile'),
                _buildDataColumn('Status'),
                _buildDataColumn('Created On', flex: 2),
                _buildDataColumn('Address', flex: 3),
                _buildDataColumn('Email', flex: 2),
                _buildDataColumn('Action'),
              ],
              rows:
                  state.filteredOrganizationDetails.map((orgDetail) {
                    final data = orgDetail.organizations.first.data;
                    log(data.toString());

                    return DataRow(
                      cells: [
                        _buildDataCell(data['organizationName'], flex: 2),
                        _buildDataCell(data['deviceName']),
                        _buildDataCell(data['doctors']),
                        _buildDataCell(data['mother']),
                        _buildDataCell(data['test']),
                        _buildDataCell(data['mobileNo']),
                        _buildDataCell(data['status']),
                        _buildDataCell(
                          data['createdOn'] != null
                              ? DateFormat(
                                'dd MMM, yyyy',
                              ).format(DateTime.parse(data['createdOn']))
                              : '',
                          flex: 2,
                        ),
                        _buildDataCell(
                          '${data['addressLine'] ?? ''}, ${data['city'] ?? ''}, ${data['state'] ?? ''}, ${data['country'] ?? ''}',
                          flex: 3,
                        ),
                        _buildDataCell(data['email'], flex: 2),
                        DataCell(
                          TextButton(
                            onPressed: () {
                              _showEditDialog(context, data);
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
            );

          default:
            return const Center(child: Text('No organizations loaded'));
        }
      },
    );
  }

  // Common header style
  static const TextStyle _headerStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle _cellStyle = TextStyle(color: Colors.white);

  DataColumn2 _buildDataColumn(String label, {int flex = 1}) {
    return DataColumn2(
      label: Text(label, style: _headerStyle),
      size: ColumnSize.M,
      fixedWidth: flex > 1 ? null : 100, // optional
    );
  }

  DataCell _buildDataCell(dynamic value, {int flex = 1}) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: flex * 120),
        child: Text(
          value?.toString() ?? '',
          style: _cellStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    Map<String, dynamic> organization,
  ) {
    final cubit = context.read<OrganizationCubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.all(20),
            backgroundColor: Colors.transparent,
            child: BlocProvider.value(
              value: cubit,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 600,
                child: OrganizationEditPopup(
                  data: organization,
                  documentId: organization['organizationId'],
                  onClose: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
    );
  }
}
