import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/utils/fetch_devices.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mocktail/mocktail.dart';


class MockDatabases extends Mock implements Databases {}
class MockExcelExportService extends Mock implements ExcelExportService {}
class MockBuildContext extends Mock {}

void main() {
  late DeviceDetailsCubit cubit;
  late MockDatabases mockDb;
  late MockExcelExportService mockExcel;

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockDb = MockDatabases();
    mockExcel = MockExcelExportService();

    // Mock locator
    locator.registerSingleton<AppwriteService>(AppwriteService());
    locator.registerSingleton<ExcelExportService>(mockExcel);

    cubit = DeviceDetailsCubit();
  });

  tearDown(() {
    locator.reset();
  });

  group('DeviceDetailsCubit Tests', () {
    test('initial state should be DeviceDetailsState.initial()', () {
      expect(cubit.state, DeviceDetailsState.initial());
    });

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'init() should call fetchDeviceData()',
      build: () {
        return cubit;
      },
      act: (cubit) {
        // Mock fetchDevices global function
        fetchDevices(db, {fromDate, tillDate}) async => [
          {'data': {'organizationName': 'Test Org'}},
        ];
        cubit.init();
      },
      expect: () => [
        isA<DeviceDetailsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<DeviceDetailsState>().having((s) => s.isLoading, 'isLoading', false),
        isA<DeviceDetailsState>()
            .having((s) => s.filteredDevices, 'filteredDevices', isNotEmpty),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'fetchDeviceData() success path emits loading and data states',
      build: () => cubit,
      act: (cubit) async {
        fetchDevices(db, {fromDate, tillDate}) async => [
          {'data': {'organizationName': 'Alpha Org'}},
          {'data': {'organizationName': 'Beta Org'}},
        ];
        await cubit.fetchDeviceData();
      },
      expect: () => [
        isA<DeviceDetailsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<DeviceDetailsState>()
            .having((s) => s.filteredDevices.length, 'filteredDevices', 2)
            .having((s) => s.isLoading, 'isLoading', false),
        isA<DeviceDetailsState>()
            .having((s) => s.searchQuery, 'searchQuery', ''),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'fetchDeviceData() handles exception and emits errorMessage',
      build: () => cubit,
      act: (cubit) async {
        fetchDevices(db, {fromDate, tillDate}) async =>
        throw Exception('Fetch failed');
        await cubit.fetchDeviceData();
      },
      expect: () => [
        isA<DeviceDetailsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<DeviceDetailsState>().having(
              (s) => s.errorMessage,
          'errorMessage',
          contains('Fetch failed'),
        ),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'updateFromDate() updates fromDate correctly',
      build: () => cubit,
      act: (cubit) {
        final date = DateTime(2025, 10, 1);
        cubit.updateFromDate(date);
      },
      expect: () => [
        isA<DeviceDetailsState>().having(
              (s) => s.fromDate,
          'fromDate',
          DateTime(2025, 10, 1),
        ),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'updateTillDate() updates tillDate correctly',
      build: () => cubit,
      act: (cubit) {
        final date = DateTime(2025, 10, 29);
        cubit.updateTillDate(date);
      },
      expect: () => [
        isA<DeviceDetailsState>().having(
              (s) => s.tillDate,
          'tillDate',
          DateTime(2025, 10, 29),
        ),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'applySearch() filters correctly with keyword and empty query',
      build: () => cubit,
      seed: () => DeviceDetailsState.initial().copyWith(allDevices: [
      ]),
      act: (cubit) {
        cubit.applySearch('Gamma');
        cubit.applySearch(''); // empty query resets
        cubit.applySearch('XYZ'); // unmatched query
      },
      expect: () => [
        isA<DeviceDetailsState>()
            .having((s) => s.filteredDevices.length, 'filtered', 1)
            .having((s) => s.searchQuery, 'query', 'Gamma'),
        isA<DeviceDetailsState>()
            .having((s) => s.filteredDevices.length, 'filtered', 2)
            .having((s) => s.searchQuery, 'query', ''),
        isA<DeviceDetailsState>()
            .having((s) => s.filteredDevices.length, 'filtered', 0)
            .having((s) => s.searchQuery, 'query', 'XYZ'),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'downloadExcel() should call exportDevicesToExcel successfully',
      build: () => cubit,
      act: (cubit) async {
        when(() => ExcelExportService.exportDevicesToExcel(any(), any()))
            .thenAnswer((_) async {
              return;
            });
        await cubit.downloadExcel(MockBuildContext());
      },
      expect: () => [],
      verify: (_) {
        verify(() => ExcelExportService.exportDevicesToExcel(any(), any())).called(1);
      },
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'downloadExcel() should handle exception and emit errorMessage',
      build: () => cubit,
      act: (cubit) async {
        when(() => ExcelExportService.exportDevicesToExcel(any(), any()))
            .thenThrow(Exception('Export failed'));
        await cubit.downloadExcel(MockBuildContext());
      },
      expect: () => [
        isA<DeviceDetailsState>().having(
              (s) => s.errorMessage,
          'errorMessage',
          contains('Export failed'),
        ),
      ],
    );
  });
}
