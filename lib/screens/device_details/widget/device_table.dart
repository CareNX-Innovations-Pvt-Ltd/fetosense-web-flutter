import 'package:appwrite/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/screens/device_edit/device_edit_view.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:flutter/material.dart';

class DeviceTable extends StatelessWidget {
  final DeviceDetailsState state;

  const DeviceTable({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 12,
      minWidth: 800,
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
      columns: [
        _buildDataColumn('Doppler Number', flex: 2),
        _buildDataColumn('Device Code'),
        _buildDataColumn('Organization', flex: 2),
        _buildDataColumn('Mother'),
        _buildDataColumn('Test'),
        _buildDataColumn('CreatedOn', flex: 2),
        _buildDataColumn('Version'),
        _buildDataColumn('Action'),
      ],
      rows:
          state.filteredDevices
              .map((device) => _buildDataRow(context, device))
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

  DataRow _buildDataRow(BuildContext context, Document device) {
    final data = device.data;
    return DataRow(
      cells: [
        _buildDataCell(data['deviceName'], flex: 2),
        _buildDataCell(data['deviceCode']),
        _buildDataCell(data['organizationName'], flex: 2),
        _buildDataCell(data['noOfMother']),
        _buildDataCell(data['noOfTests']),
        _buildDataCell(formatDate(data['createdOn']), flex: 2),
        _buildDataCell(data['appVersion']),
        DataCell(
          TextButton(
            onPressed: () => _showEditDialog(context, device),
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

  void _showEditDialog(BuildContext context, Document device) {
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
  }
}
