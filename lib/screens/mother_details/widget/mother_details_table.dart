import 'package:appwrite/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class MotherDetailsTable extends StatelessWidget {
  final List<Document> filteredMothers;

  const MotherDetailsTable({super.key, required this.filteredMothers});

  @override
  Widget build(BuildContext context) {
    if (filteredMothers.isEmpty) {
      return const Center(
        child: Text("No data available", style: TextStyle(color: Colors.white)),
      );
    }

    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 12,
      minWidth: 750,
      border: TableBorder.all(color: Colors.grey.shade700, width: 1),
      headingRowColor: MaterialStateProperty.all(const Color(0xFF181A1B)),
      dataRowColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return Colors.grey.shade800;
        }
        return const Color(0xFF121314); // default row color
      }),
      columns: const [
        DataColumn2(
          label: Text(
            "Name",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn2(
          label: Text(
            "Organization",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn2(
          label: Text(
            "Device",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn2(
          label: Text(
            "Doctor",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn2(
          label: Text(
            "Test",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      rows:
          filteredMothers.map((org) {
            final data = org.data;
            return DataRow(
              cells: [
                _buildDataCell(data['name']),
                _buildDataCell(data['organizationName']),
                _buildDataCell(data['deviceName']),
                _buildDataCell(data['doctorName']),
                _buildDataCell(data['noOfTests']),
              ],
            );
          }).toList(),
    );
  }

  DataCell _buildDataCell(dynamic value, {int flex = 1}) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: flex * 130),
        child: Text(
          value?.toString() ?? '',
          style: const TextStyle(color: Colors.white),
          maxLines: 2,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
