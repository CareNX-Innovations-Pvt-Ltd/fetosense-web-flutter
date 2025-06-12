import 'package:appwrite/models.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizationsTableWidget extends StatelessWidget {
  final OrganizationState state;
  final void Function(BuildContext, Document) onEdit;

  const OrganizationsTableWidget({
    Key? key,
    required this.state,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.status == OrganizationStatus.loading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.1,
            child: DataTable2(
              columnSpacing: 20,
              horizontalMargin: 16,
              dividerThickness: 1,
              border: const TableBorder(
                verticalInside: BorderSide(color: Colors.grey, width: 1),
                horizontalInside: BorderSide(color: Colors.grey, width: 1),
                bottom: BorderSide(color: Colors.grey),
                top: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),

              headingRowColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                return Color(0xFF181A1B);
              }),

              dataRowColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                return const Color(
                  0xFF121314,
                ); // uniform row color for all states
              }),
              columns: _buildColumns(),
              rows:
                  state.filteredOrganizations.map((org) {
                    final data = org.data;
                    return DataRow(
                      cells: [
                        _buildFlexibleDataCell(data['name'], flex: 2),
                        _buildFlexibleDataCell(data['device']?.toString()),
                        _buildFlexibleDataCell(data['doctors']?.toString()),
                        _buildFlexibleDataCell(data['mother']?.toString()),
                        _buildFlexibleDataCell(data['test']?.toString()),
                        _buildFlexibleDataCell(data['mobile'], flex: 2),
                        _buildFlexibleDataCell(data['status']),
                        _buildFlexibleDataCell(
                          formatDate(data['createdOn']),
                          flex: 2,
                        ),
                        _buildFlexibleDataCell(
                          '${data['addressLine'] ?? ''}, ${data['city'] ?? ''}, ${data['state'] ?? ''}, ${data['country'] ?? ''}',
                          flex: 3,
                        ),
                        _buildFlexibleDataCell(data['email'], flex: 2),
                        DataCell(
                          TextButton(
                            onPressed: () => onEdit(context, org),
                            child: const Text(
                              "Edit",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn2> _buildColumns() {
    return [
      _buildDataColumn("Name", flex: 2),
      _buildDataColumn("Device"),
      _buildDataColumn("Doctors"),
      _buildDataColumn("Mother"),
      _buildDataColumn("Test"),
      _buildDataColumn("Mobile", flex: 2),
      _buildDataColumn("Status"),
      _buildDataColumn("Created On", flex: 2),
      _buildDataColumn("Address", flex: 3),
      _buildDataColumn("Email", flex: 2),
      _buildDataColumn("Action"),
    ];
  }

  DataColumn2 _buildDataColumn(String label, {int flex = 1}) {
    return DataColumn2(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  DataCell _buildFlexibleDataCell(String? text, {int flex = 1}) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: flex * 150),
        child: Text(
          text ?? '',
          style: const TextStyle(color: Colors.white),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
