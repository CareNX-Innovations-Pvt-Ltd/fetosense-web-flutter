import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../screens/organization_analytics_test.dart';


class MockDatabases extends Mock implements Databases {}

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

class MockDocument extends Mock implements models.Document {}

class MockDocumentList extends Mock implements models.DocumentList {}

void main() {
  late DeviceEditCubit cubit;
  late MockDatabases mockDb;
  late MockPreferenceHelper mockPrefs;

  setUp(() {
    mockDb = MockDatabases();
    mockPrefs = MockPreferenceHelper();
    locator.registerSingleton<PreferenceHelper>(mockPrefs);
    cubit = DeviceEditCubit(db: mockDb, documentId: 'doc123');
  });

  tearDown(() async {
    await cubit.close();
    locator.reset();
  });

  test('initialize sets controller values and fetches tablet serial', () async {
    final mock = MockDocumentList();
    when(() => mock.documents).thenReturn([]);
    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenAnswer((_) async => mock);

    cubit.initialize({'deviceCode': 'DEV123', 'deviceId': 'DID123'});

    expect(cubit.deviceCodeController.text, 'DEV123');
    expect(cubit.deviceNameController.text, 'DID123');
  });

  test('fetchTabletSerialNumber emits loading then loaded', () async {
    final doc = MockDocument();
    when(() => doc.data).thenReturn({'tabletSerialNumber': 'TAB999'});
    final list = MockDocumentList();
    when(() => list.documents).thenReturn([doc]);

    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenAnswer((_) async => list);

    final states = <DeviceEditState>[];
    cubit.stream.listen(states.add);

    await cubit.fetchTabletSerialNumber();

    expect(states[0], isA<DeviceEditLoading>());
    expect(states[1], isA<DeviceEditLoaded>());
    expect(cubit.tabletSerialNumberController.text, 'TAB999');
  });

  test('fetchTabletSerialNumber emits error on failure', () async {
    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenThrow(Exception('DB error'));

    final states = <DeviceEditState>[];
    cubit.stream.listen(states.add);

    await cubit.fetchTabletSerialNumber();

    expect(states[0], isA<DeviceEditLoading>());
    expect(states[1], isA<DeviceEditError>());
  });

  test('updateChanges as admin emits saving and saved', () async {
    final user = UserModel(role: UserRoles.admin, userId: '', email: '', organizationId: '');
    when(() => mockPrefs.getUser()).thenReturn(user);

    // simulate controllers
    cubit.deviceCodeController.text = 'D123';
    cubit.deviceNameController.text = 'Doppler';

    // simulate tablet doc lookup
    final doc = MockDocument();
    when(() => doc.$id).thenReturn('tablet-id');
    final list = MockDocumentList();
    when(() => list.documents).thenReturn([doc]);

    when(() => mockDb.updateDocument(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      documentId: any(named: 'documentId'),
      data: any(named: 'data'),
    )).thenAnswer((_) async => MockDocument());

    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenAnswer((_) async => list);

    final states = <DeviceEditState>[];
    cubit.stream.listen(states.add);

    await cubit.updateChanges();

    expect(states[0], isA<DeviceEditSaving>());
    expect(states[1], isA<DeviceEditSaved>());
  });

  test('updateChanges as non-admin emits error', () async {
    final user = UserModel(role: UserRoles.user, userId: '', email: '', organizationId: ''); // Not admin
    when(() => mockPrefs.getUser()).thenReturn(user);

    final states = <DeviceEditState>[];
    cubit.stream.listen(states.add);

    await cubit.updateChanges();

    expect(states[0], isA<DeviceEditSaving>());
    expect(states[1], isA<DeviceEditError>());
  });

  test('updateChanges handles updateDocument failure', () async {
    final user = UserModel(role: UserRoles.admin, userId: '', email: '', organizationId: '');
    when(() => mockPrefs.getUser()).thenReturn(user);

    cubit.deviceCodeController.text = 'D123';
    cubit.deviceNameController.text = 'Doppler';

    when(() => mockDb.updateDocument(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      documentId: any(named: 'documentId'),
      data: any(named: 'data'),
    )).thenThrow(Exception('update error'));

    final states = <DeviceEditState>[];
    cubit.stream.listen(states.add);

    await cubit.updateChanges();

    expect(states[0], isA<DeviceEditSaving>());
    expect(states[1], isA<DeviceEditError>());
  });

  test('close disposes all controllers', () async {
    final c1 = cubit.deviceCodeController;
    final c2 = cubit.tabletSerialNumberController;
    final c3 = cubit.deviceNameController;

    expect(c1, isNotNull);
    await cubit.close();

    expect(() => c1.text, throwsA(isA<AssertionError>()));
    expect(() => c2.text, throwsA(isA<AssertionError>()));
    expect(() => c3.text, throwsA(isA<AssertionError>()));
  });
}
