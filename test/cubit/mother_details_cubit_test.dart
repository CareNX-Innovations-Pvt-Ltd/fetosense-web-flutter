import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/screens/mother_details/mother_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:appwrite/appwrite.dart' as appwrite;

import '../screens/organization_analytics_test.dart';

/// ---------------- MOCKS ----------------
class MockDatabases extends Mock implements appwrite.Databases {}
class MockExcelExportService extends Mock implements ExcelExportService {}
class MockAppwriteService extends Mock implements AppwriteService {}
class MockBuildContext extends Mock implements BuildContext {}
class MockDocument extends Mock implements models.Document {}

void main() {
  late MotherDetailsCubit cubit;
  late MockDatabases mockDb;
  late MockExcelExportService mockExcel;
  late MockBuildContext mockContext;

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    locator.reset();
    locator.registerSingleton<AppwriteService>(MockAppwriteService());
    locator.registerSingleton<ExcelExportService>(mockExcel = MockExcelExportService());
    mockDb = MockDatabases();
    mockContext = MockBuildContext();

    cubit = MotherDetailsCubit();
    cubit.db = mockDb;
  });

  tearDown(() async {
    await cubit.close();
    locator.reset();
  });

  /// ---------------- fetchMothers() ----------------
  group('fetchMothers function', () {
    test('fetchMothers() returns documents successfully', () async {
      final mockDoc = MockDocument();
      when(() => mockDoc.data).thenReturn({'organizationName': 'Org A'});

      final mockListResult = models.DocumentList(
        total: 1,
        documents: [mockDoc],
      );

      when(() => mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: any(named: 'queries'),
      )).thenAnswer((_) async => mockListResult);

      final result = await fetchMothers(mockDb);
      expect(result.length, 1);
      expect(result.first.data['organizationName'], 'Org A');
    });

    test('fetchMothers() adds date filters when provided', () async {
      final mockDoc = MockDocument();
      when(() => mockDoc.data).thenReturn({'organizationName': 'Org B'});

      final mockListResult = models.DocumentList(
        total: 1,
        documents: [mockDoc],
      );

      when(() => mockDb.listDocuments(
        databaseId: any(named: 'databaseId'),
        collectionId: any(named: 'collectionId'),
        queries: any(named: 'queries'),
      )).thenAnswer((_) async => mockListResult);

      final result = await fetchMothers(
        mockDb,
        fromDate: DateTime(2025, 1, 1),
        tillDate: DateTime(2025, 12, 31),
      );

      expect(result, isNotEmpty);
      verify(() => mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: any(named: 'queries'),
      )).called(1);
    });
  });

  /// ---------------- MotherDetailsCubit ----------------
  group('MotherDetailsCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const MotherDetailsState());
      expect(cubit.searchController.hasListeners, isTrue);
    });

    test('close() disposes controllers properly', () async {
      await cubit.close();
      expect(() => cubit.fromDateController.text, throwsA(isA<FlutterError>()));
    });

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'setFromDate() updates state and controller text',
      build: () => cubit,
      act: (cubit) {
        cubit.setFromDate(DateTime(2025, 10, 29));
      },
      expect: () => [
        isA<MotherDetailsState>().having(
              (s) => s.fromDate,
          'fromDate',
          DateTime(2025, 10, 29),
        ),
      ],
      verify: (_) {
        expect(cubit.fromDateController.text, '2025-10-29');
      },
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'clearFromDate() clears text and emits clearFromDate true',
      build: () => cubit,
      act: (cubit) {
        cubit.fromDateController.text = '2025-10-29';
        cubit.clearAllFilters();
      },
      expect: () => [
        isA<MotherDetailsState>().having((s) => s, 'clear', true),
      ],
      verify: (_) {
        expect(cubit.fromDateController.text, '');
      },
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'setTillDate() updates state and controller text',
      build: () => cubit,
      act: (cubit) {
        cubit.setTillDate(DateTime(2025, 10, 29));
      },
      expect: () => [
        isA<MotherDetailsState>().having(
              (s) => s.tillDate,
          'tillDate',
          DateTime(2025, 10, 29),
        ),
      ],
      verify: (_) {
        expect(cubit.tillDateController.text, '2025-10-29');
      },
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'clearTillDate() clears text and emits clearTillDate true',
      build: () => cubit,
      act: (cubit) {
        cubit.tillDateController.text = '2025-10-29';
        cubit.clearAllFilters();
      },
      expect: () => [
        isA<MotherDetailsState>().having((s) => s, 'clear', true),
      ],
      verify: (_) {
        expect(cubit.tillDateController.text, '');
      },
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'setSearchQuery() updates searchQuery and triggers filter',
      build: () => cubit,
      seed: () => const MotherDetailsState(allMothers: []),
      act: (cubit) {
        cubit.setSearchQuery('Alpha');
      },
      expect: () => [
        isA<MotherDetailsState>().having((s) => s.searchQuery, 'query', 'Alpha'),
        isA<MotherDetailsState>(),
      ],
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'fetchMothersId() success updates state correctly',
      build: () => cubit,
      act: (cubit) async {
        final mockDoc = MockDocument();
        when(() => mockDoc.data)
            .thenReturn({'organizationName': 'Test Org'});
        final list = models.DocumentList(
          total: 1,
          documents: [mockDoc],
        );
        when(() => mockDb.listDocuments(
          databaseId: any(named: 'databaseId'),
          collectionId: any(named: 'collectionId'),
          queries: any(named: 'queries'),
        )).thenAnswer((_) async => list);
        await cubit.fetchMothersId();
      },
      expect: () => [
        isA<MotherDetailsState>().having((s) => s.isLoading, 'loading', true),
        isA<MotherDetailsState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.filteredMothers.length, 'mothers', 1),
        isA<MotherDetailsState>(),
      ],
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'fetchMothersId() handles exception',
      build: () => cubit,
      act: (cubit) async {
        when(() => mockDb.listDocuments(
          databaseId: any(named: 'databaseId'),
          collectionId: any(named: 'collectionId'),
          queries: any(named: 'queries'),
        )).thenThrow(Exception('Fetch failed'));
        await cubit.fetchMothersId();
      },
      expect: () => [
        isA<MotherDetailsState>().having((s) => s.isLoading, 'loading', true),
        isA<MotherDetailsState>().having(
              (s) => s.errorMessage,
          'error',
          contains('Error fetching mothers'),
        ),
      ],
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      '_applySearchFilter filters results by query',
      build: () => cubit,
      seed: () {
        final mockDoc1 = MockDocument();
        final mockDoc2 = MockDocument();
        when(() => mockDoc1.data)
            .thenReturn({'organizationName': 'Alpha Hospital'});
        when(() => mockDoc2.data)
            .thenReturn({'organizationName': 'Beta Clinic'});
        return MotherDetailsState(
          allMothers: [mockDoc1, mockDoc2],
          searchQuery: 'alpha',
        );
      },
      act: (cubit) {
        cubit.setSearchQuery('alpha');
      },
      expect: () => [
        isA<MotherDetailsState>()
            .having((s) => s.filteredMothers.length, 'filtered', 1),
        isA<MotherDetailsState>(),
      ],
    );

    blocTest<MotherDetailsCubit, MotherDetailsState>(
      'downloadExcel() success calls export service',
      build: () => cubit,
      act: (cubit) async {
        when(() => ExcelExportService.exportMothersToExcel(any(), any()))
            .thenAnswer((_) async {});
        await cubit.downloadExcel(mockContext);
      },
      expect: () => [],
      verify: (_) {
        verify(() => ExcelExportService.exportMothersToExcel(any(), any())).called(1);
      },
    );

    testWidgets('downloadExcel() shows snackbar on failure',
            (WidgetTester tester) async {
          when(() => ExcelExportService.exportMothersToExcel(any(), any()))
              .thenThrow(Exception('Export failed'));

          await cubit.downloadExcel(mockContext);
        });
  });
}
