import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/screens/mother_details/mother_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockDatabases extends Mock implements Databases {}
class MockExcelExportService extends Mock implements ExcelExportService {}
class MockDocument extends Mock implements models.Document {}

void main() {
  late MotherDetailsCubit cubit;
  late MockDatabases mockDb;

  setUp(() {
    mockDb = MockDatabases();
    cubit = MotherDetailsCubit();
    cubit.db = mockDb;
  });

  test('initial state is correct', () {
    expect(cubit.state.allMothers, []);
    expect(cubit.state.filteredMothers, []);
    expect(cubit.state.isLoading, false);
  });

  test('setFromDate updates state and controller', () {
    final date = DateTime(2025, 10, 24);
    cubit.setFromDate(date);
    expect(cubit.state.fromDate, date);
    expect(cubit.fromDateController.text, '2025-10-24');
  });

  test('clearFromDate clears controller and emits', () {
    cubit.clearFromDate();
    expect(cubit.fromDateController.text, '');
    expect(cubit.state, true);
  });

  test('setTillDate updates state and controller', () {
    final date = DateTime(2025, 10, 24);
    cubit.setTillDate(date);
    expect(cubit.state.tillDate, date);
    expect(cubit.tillDateController.text, '2025-10-24');
  });

  test('clearTillDate clears controller and emits', () {
    cubit.clearTillDate();
    expect(cubit.tillDateController.text, '');
    expect(cubit.state, true);
  });

  test('setSearchQuery filters mothers', () {
    final doc1 = MockDocument();
    when(() => doc1.data).thenReturn({'organizationName': 'Alpha'});
    final doc2 = MockDocument();
    when(() => doc2.data).thenReturn({'organizationName': 'Beta'});

    cubit.emit(cubit.state.copyWith(allMothers: [doc1, doc2]));
    cubit.setSearchQuery('alpha');
    expect(cubit.state.filteredMothers, [doc1]);

    cubit.setSearchQuery(''); // reset filter
    expect(cubit.state.filteredMothers, [doc1, doc2]);
  });

  test('fetchMothersId success', () async {
    final doc = MockDocument();
    when(() => doc.data).thenReturn({'organizationName': 'Org1'});
    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenAnswer((_) async => models.DocumentList(
      total: 1,
      documents: [doc],
      // sum: 0,
    ));

    await cubit.fetchMothersId();
    expect(cubit.state.allMothers, [doc]);
    expect(cubit.state.filteredMothers, [doc]);
    expect(cubit.state.isLoading, false);
  });

  test('fetchMothersId handles error', () async {
    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenThrow(Exception('DB error'));

    await cubit.fetchMothersId();
    expect(cubit.state.isLoading, false);
    expect(cubit.state.errorMessage, contains('DB error'));
  });

  testWidgets('downloadExcel success and failure', (tester) async {
    final context = tester.element(find.byType(Container));

    final doc = MockDocument();
    when(() => doc.data).thenReturn({'organizationName': 'Org1'});
    cubit.emit(cubit.state.copyWith(filteredMothers: [doc]));
    await cubit.downloadExcel(context);
    ExcelExportService.exportMothersToExcel(context, []);
    await cubit.downloadExcel(context);
  });

  test('searchController listener calls _applySearchFilter', () {
    final doc = MockDocument();
    when(() => doc.data).thenReturn({'organizationName': 'Alpha'});
    cubit.emit(cubit.state.copyWith(allMothers: [doc]));

    cubit.searchController.text = 'alpha';
    cubit.searchController.notifyListeners();

    expect(cubit.state.filteredMothers, [doc]);
  });

  test('close disposes controllers', () async {
    await cubit.close();
    expect(cubit.fromDateController.hasListeners, false);
    expect(cubit.tillDateController.hasListeners, false);
    expect(cubit.searchController.hasListeners, false);
  });
}
