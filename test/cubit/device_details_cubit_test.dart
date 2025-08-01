import 'package:appwrite/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'device_details_cubit_test.mocks.dart';

@GenerateMocks([Databases, BuildContext])
void main() {
  group('DeviceDetailsCubit', () {
    late DeviceDetailsCubit cubit;
    late List<Document> mockDevices;

    setUp(() {
      cubit = DeviceDetailsCubit();
      cubit.emit(DeviceDetailsState.initial()); // ensure initial state
      mockDevices = [
        Document(
          $id: '1',
          $collectionId: '',
          $databaseId: '',
          data: {
            'organizationName': 'Org A',
            'deviceCode': 'DEV001',
            'deviceName': 'Doppler 1',
            'createdOn': '2024-01-01T00:00:00Z',
            'appVersion': '1.0.0',
            'noOfMother': 10,
            'noOfTests': 5,
          }, $createdAt: '', $updatedAt: '', $permissions: [],
        ),
      ];
    });

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'emits loading and then loaded state when fetchDeviceData succeeds',
      build: () {
        return cubit;
      },
      act: (cubit) async {
        cubit.emit(
          cubit.state.copyWith(
            allDevices: mockDevices,
            filteredDevices: mockDevices,
            isLoading: false,
          ),
        );
        await cubit.fetchDeviceData();
      },
      expect: () => [
        isA<DeviceDetailsState>().having((s) => s.isLoading, 'loading', true),
        isA<DeviceDetailsState>().having((s) => s.filteredDevices.length, 'devices', 1),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'updateFromDate updates state correctly',
      build: () => cubit,
      act: (cubit) => cubit.updateFromDate(DateTime(2024, 1, 1)),
      expect: () => [
        isA<DeviceDetailsState>().having(
              (s) => s.fromDate,
          'fromDate',
          DateTime(2024, 1, 1),
        )
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'updateTillDate updates state correctly',
      build: () => cubit,
      act: (cubit) => cubit.updateTillDate(DateTime(2024, 2, 1)),
      expect: () => [
        isA<DeviceDetailsState>().having(
              (s) => s.tillDate,
          'tillDate',
          DateTime(2024, 2, 1),
        )
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'applySearch filters devices based on organization name',
      build: () {
        return cubit;
      },
      seed: () => DeviceDetailsState.initial().copyWith(
        allDevices: mockDevices,
        filteredDevices: mockDevices,
      ),
      act: (cubit) => cubit.applySearch('org a'),
      expect: () => [
        isA<DeviceDetailsState>().having(
              (s) => s.filteredDevices.length,
          'filtered count',
          1,
        ),
      ],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'downloadExcel calls export service',
      build: () => cubit,
      act: (cubit) async {
        await cubit.downloadExcel(MockBuildContext());
      },
      expect: () => [],
    );

    blocTest<DeviceDetailsCubit, DeviceDetailsState>(
      'downloadExcel emits errorMessage on failure',
      build: () {
        return DeviceDetailsCubit()
          ..emit(
            DeviceDetailsState.initial().copyWith(filteredDevices: []),
          );
      },
      act: (cubit) async {
        await cubit.downloadExcel(MockBuildContext());
      },
      expect: () => [
        isA<DeviceDetailsState>().having((s) => s.errorMessage, 'error', isNotNull),
      ],
    );
  });
}
