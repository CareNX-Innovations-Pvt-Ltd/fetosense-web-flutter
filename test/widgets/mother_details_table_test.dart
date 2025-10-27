import 'package:fetosense_mis/screens/mother_details/widget/mother_details_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:appwrite/models.dart' as models;

void main() {
  group('MotherDetailsTable', () {
    testWidgets('shows "No data available" when filteredMothers is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotherDetailsTable(filteredMothers: []),
          ),
        ),
      );

      expect(find.text('No data available'), findsOneWidget);
      expect(find.byType(DataTable2), findsNothing);
    });

    testWidgets('renders DataTable2 with rows when filteredMothers is not empty', (tester) async {
      final docs = [
        models.Document(data: {
          'name': 'Alice',
          'organizationName': 'Org1',
          'deviceName': 'DeviceA',
          'doctorName': 'Dr. Smith',
          'noOfTests': 3,
        }, $id: '', $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
        models.Document(data: {
          'name': 'Bob',
          'organizationName': 'Org2',
          'deviceName': 'DeviceB',
          'doctorName': 'Dr. Jane',
          'noOfTests': 2,
        }, $id: '', $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotherDetailsTable(filteredMothers: docs),
          ),
        ),
      );

      // Verify the DataTable is rendered
      expect(find.byType(DataTable2), findsOneWidget);

      // Verify header columns
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Organization'), findsOneWidget);
      expect(find.text('Device'), findsOneWidget);
      expect(find.text('Doctor'), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);

      // Verify row content
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Org1'), findsOneWidget);
      expect(find.text('DeviceA'), findsOneWidget);
      expect(find.text('Dr. Smith'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Org2'), findsOneWidget);
      expect(find.text('DeviceB'), findsOneWidget);
      expect(find.text('Dr. Jane'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('handles null and missing fields gracefully', (tester) async {
      final docs = [
        models.Document(data: {
          'name': null,
          // missing other fields
        }, $id: '', $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotherDetailsTable(filteredMothers: docs),
          ),
        ),
      );

      expect(find.byType(DataTable2), findsOneWidget);

      // Empty text cells should still render safely
      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      for (final textWidget in textWidgets) {
        expect(textWidget.data != null, true);
      }
    });

    testWidgets('_buildDataCell builds Text with constraints', (tester) async {
      const widget = MotherDetailsTable(filteredMothers: []);
      final dataCell = widget.buildDataCell('Sample', flex: 2);

      expect(dataCell.child, isA<ConstrainedBox>());
      final constrainedBox = dataCell.child as ConstrainedBox;
      final constraints = constrainedBox.constraints;
      expect(constraints.maxWidth, 260); // flex * 130
    });
  });
}
