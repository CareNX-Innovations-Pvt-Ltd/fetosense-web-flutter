import 'package:appwrite/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/screens/doctor_details/doctoredit/doctor_edit_popup.dart';
import 'package:flutter/material.dart';

class DoctorDetailsTable extends StatelessWidget {
  final DoctorDetailsState state;

  const DoctorDetailsTable({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.filteredDoctors.isEmpty) {
      return const Center(
        child: Text("No data available", style: TextStyle(color: Colors.white)),
      );
    }

    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 12,
      minWidth: 800,
      border: TableBorder.all(color: Colors.grey.shade700, width: 1),
      headingRowColor: WidgetStateProperty.all(const Color(0xFF181A1B)),
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade800;
        }
        return const Color(0xFF121314);
      }),
      columns: [
        _buildDataColumn('Name', flex: 2),
        _buildDataColumn('Email', flex: 2),
        _buildDataColumn('Organization', flex: 2),
        _buildDataColumn('Mother'),
        _buildDataColumn('Test'),
        _buildDataColumn('CreatedOn', flex: 2),
        _buildDataColumn('L.O.T', flex: 2),
        _buildDataColumn('Version'),
        _buildDataColumn('Action'),
      ],
      rows:
          state.filteredDoctors
              .map((doc) => _buildDataRow(context, doc))
              .toList(),
    );
  }

  DataColumn2 _buildDataColumn(String label, {int flex = 1}) {
    return DataColumn2(
      label: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Document doc) {
    final data = doc.data;
    return DataRow(
      cells: [
        _buildDataCell(data['name'], flex: 2),
        _buildDataCell(data['email'], flex: 2),
        _buildDataCell(data['organizationName'], flex: 2),
        _buildDataCell(data['noOfMother']),
        _buildDataCell(data['noOfTests']),
        _buildDataCell(formatDate(data['createdOn']), flex: 2),
        _buildDataCell(formatDate(data['lastLoginTime']), flex: 2),
        _buildDataCell(data['appVersion']),
        DataCell(
          TextButton(
            onPressed: () => _showEditDialog(context, doc),
            child: const Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ),
      ],
    );
  }

  DataCell _buildDataCell(dynamic value, {int flex = 1}) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: flex * 120),
        child: Text(
          value?.toString() ?? '',
          style: const TextStyle(color: Colors.white),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Document doc) {
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
              child: DoctorEditPopup(
                data: doc.data,
                documentId: doc.$id,
                onClose: () => Navigator.pop(context),
              ),
            ),
          ),
    );
  }
}
