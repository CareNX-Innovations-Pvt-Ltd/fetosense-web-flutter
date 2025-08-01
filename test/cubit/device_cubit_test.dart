import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/appwrite.dart';

import '../screens/organization_analytics_test.dart';
import '../widgets/sidebar_test.dart';


class MockDatabases extends Mock implements Databases {}

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

class MockDocument extends Mock implements models.Document {}

class MockDocumentList extends Mock implements models.DocumentList {}

void main() {
  late MockDatabases mockDb;
  late MockPreferenceHelper mockPrefs;
  const documentId = 'mock-doc-id';

  setUp(() {
    mockDb = MockDatabases();
    mockPrefs = MockPreferenceHelper();
    locator.registerSingleton<PreferenceHelper>(mockPrefs);
  });

  tearDown(() {
    locator.reset();
  });

  group('DeviceEditCubit', () {
    test('initial state is DeviceEditInitial', () {
      final cubit = DeviceEditCubit(db: mockDb, documentId: documentId);
      expect(cubit.state, DeviceEditInitial());
    });

    blocTest<DeviceEditCubit, DeviceEditState>(
      'emits [DeviceEditLoading, DeviceEditLoaded] when fetchTabletSerialNumber succeeds',
      build: () {
        final doc = MockDocument();
        when(() => doc.data).thenReturn({'tabletSerialNumber': 'SN-1234'});
        when(() => doc.$id).thenReturn('tablet-id');

        final docList = MockDocumentList();
        when(() => docList.documents).thenReturn([doc]);

        when(() => mockDb.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: any(named: 'queries'),
        )).thenAnswer((_) async => docList);

        return DeviceEditCubit(db: mockDb, documentId: documentId);
      },
      act: (cubit) => cubit.fetchTabletSerialNumber(),
      expect: () => [DeviceEditLoading(), DeviceEditLoaded()],
      verify: (cubit) {
        expect(cubit.tabletSerialNumberController.text, 'SN-1234');
      },
    );

    blocTest<DeviceEditCubit, DeviceEditState>(
      'emits [DeviceEditLoading, DeviceEditError] on fetchTabletSerialNumber failure',
      build: () {
        when(() => mockDb.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: any(named: 'queries'),
        )).thenThrow(Exception('DB error'));
        return DeviceEditCubit(db: mockDb, documentId: documentId);
      },
      act: (cubit) => cubit.fetchTabletSerialNumber(),
      expect: () => [
        DeviceEditLoading(),
        DeviceEditError("Failed to fetch tablet serial number"),
      ],
    );

    blocTest<DeviceEditCubit, DeviceEditState>(
      'emits [DeviceEditSaving, DeviceEditSaved] when updateChanges succeeds as admin',
      build: () {
        final user = UserModel(role: UserRoles.admin, userId: '', email: '', organizationId: '');
        when(() => mockPrefs.getUser()).thenReturn(user);

        when(() => mockDb.updateDocument(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          documentId: any(named: 'documentId'),
          data: any(named: 'data'),
        )).thenAnswer((_) async => Future.value()); // Simulate success

        final doc = MockDocument();
        when(() => doc.$id).thenReturn('tablet-id');
        when(() => doc.data).thenReturn({'tabletSerialNumber': 'SN-9999'});

        final docList = MockDocumentList();
        when(() => docList.documents).thenReturn([doc]);

        when(() => mockDb.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: any(named: 'queries'),
        )).thenAnswer((_) async => docList);

        return DeviceEditCubit(db: mockDb, documentId: documentId);
      },
      act: (cubit) {
        cubit.deviceCodeController.text = 'DEV-001';
        cubit.deviceNameController.text = 'Device One';
        cubit.tabletSerialNumberController.text = 'SN-9999';
        return cubit.updateChanges();
      },
      expect: () => [DeviceEditSaving(), DeviceEditSaved()],
    );

    blocTest<DeviceEditCubit, DeviceEditState>(
      'emits [DeviceEditSaving, DeviceEditError] if user is not admin',
      build: () {
        when(() => mockPrefs.getUser()).thenReturn(UserModel(role: UserRoles.user, userId: '', email: '', organizationId: ''));
        return DeviceEditCubit(db: mockDb, documentId: documentId);
      },
      act: (cubit) => cubit.updateChanges(),
      expect: () => [
        DeviceEditSaving(),
        DeviceEditError("doctor role cannot edit device"),
      ],
    );

    blocTest<DeviceEditCubit, DeviceEditState>(
      'initialize sets controllers with correct values',
      build: () => DeviceEditCubit(db: mockDb, documentId: documentId),
      act: (cubit) {
        cubit.initialize({'deviceCode': 'ABC', 'deviceId': 'XYZ'});
      },
      verify: (cubit) {
        expect(cubit.deviceCodeController.text, 'ABC');
        expect(cubit.deviceNameController.text, 'XYZ');
      },
    );
  });
}
