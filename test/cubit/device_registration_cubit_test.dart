import 'package:appwrite/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/screens/device_registration/device_registration_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/appwrite.dart';

import '../screens/dashboard_view_test.dart';

class MockDatabases extends Mock implements Databases {}

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

class FakeDocument extends Fake implements Document {}

class FakeDocumentList extends Fake implements DocumentList {}

void main() {
  late MockDatabases mockDb;
  late MockPreferenceHelper mockPrefs;
  late DeviceRegistrationCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeDocumentList());
    registerFallbackValue(FakeDocument());
  });

  setUp(() {
    mockDb = MockDatabases();
    mockPrefs = MockPreferenceHelper();
    getIt.registerSingleton<PreferenceHelper>(mockPrefs);
    cubit = DeviceRegistrationCubit(db: mockDb);
  });

  tearDown(() {
    getIt.reset();
  });

  group('DeviceRegistrationCubit Tests', () {
    test('Initial state is correct', () {
      expect(cubit.state, const DeviceRegistrationState());
    });

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'fetchOrganizations emits state with organizationList',
      build: () {
        final doc = FakeDocument();
        when(() => doc.$id).thenReturn('org1');
        when(() => doc.data).thenReturn({'organizationName': 'Org 1'});

        when(
          () => mockDb.listDocuments(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            queries: any(named: 'queries'),
          ),
        ).thenAnswer((_) async => DocumentList(documents: [doc], total: 1));

        return cubit;
      },
      act: (cubit) => cubit.fetchOrganizations(),
      expect:
          () => [
            cubit.state.copyWith(
              organizationList: [
                {'id': 'org1', 'name': 'Org 1'},
              ],
            ),
          ],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'updateSelectedOrganization updates name and id',
      build: () => cubit,
      act: (cubit) => cubit.updateSelectedOrganization('Org A', 'idA'),
      expect:
          () => [
            cubit.state.copyWith(
              selectedOrganizationName: 'Org A',
              selectedOrganizationId: 'idA',
            ),
          ],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'updateSelectedProductType updates selectedProductType',
      build: () => cubit,
      act: (cubit) => cubit.updateSelectedProductType('Toco'),
      expect: () => [cubit.state.copyWith(selectedProductType: 'Toco')],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'updateDeviceName updates deviceName',
      build: () => cubit,
      act: (cubit) => cubit.updateDeviceName('Device123'),
      expect: () => [cubit.state.copyWith(deviceName: 'Device123')],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'updateKitId updates kitId',
      build: () => cubit,
      act: (cubit) => cubit.updateKitId('Kit007'),
      expect: () => [cubit.state.copyWith(kitId: 'Kit007')],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'updateTabletSerialNumber updates tabletSerialNumber',
      build: () => cubit,
      act: (cubit) => cubit.updateTabletSerialNumber('Serial999'),
      expect: () => [cubit.state.copyWith(tabletSerialNumber: 'Serial999')],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'updateTocoId updates tocoId',
      build: () => cubit,
      act: (cubit) => cubit.updateTocoId('Toco123'),
      expect: () => [cubit.state.copyWith(tocoId: 'Toco123')],
    );

    test('validateForm returns true when required fields are filled', () {
      cubit
        ..updateSelectedOrganization('Org A', 'idA')
        ..updateSelectedProductType('Toco')
        ..updateDeviceName('Device')
        ..updateKitId('Kit');
      expect(cubit.validateForm(), true);
    });

    test('validateForm returns false when required fields are empty', () {
      expect(cubit.validateForm(), false);
    });

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'clearError resets errorMessage to null',
      build: () => cubit,
      seed: () => cubit.state.copyWith(errorMessage: 'Oops'),
      act: (cubit) => cubit.clearError(),
      expect: () => [cubit.state.copyWith(clearErrorMessage: () => null)],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'resetSuccess sets isSuccess to false',
      build: () => cubit,
      seed: () => cubit.state.copyWith(isSuccess: true),
      act: (cubit) => cubit.resetSuccess(),
      expect: () => [cubit.state.copyWith(isSuccess: false)],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'registerDevice fails validation and shows error',
      build: () => cubit,
      act: (cubit) => cubit.registerDevice(),
      expect:
          () => [
            cubit.state.copyWith(
              errorMessage: 'Please fill in all required fields.',
            ),
          ],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'registerDevice emits success when user is admin',
      build: () {
        when(() => mockPrefs.getUser()).thenReturn(
          UserModel(
            role: UserRoles.admin,
            userId: '',
            email: '',
            organizationId: '',
          ),
        );
        getIt.registerSingleton<PreferenceHelper>(mockPrefs);

        when(
          () => mockDb.createDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => FakeDocument());

        cubit
          ..updateSelectedOrganization('Org', 'orgId')
          ..updateSelectedProductType('Toco')
          ..updateDeviceName('DevName')
          ..updateKitId('Kit007');

        return cubit;
      },
      act: (cubit) => cubit.registerDevice(),
      expect:
          () => [
            cubit.state.copyWith(
              isSubmitting: true,
              clearErrorMessage: () => null,
            ),
            cubit.state.copyWith(isSubmitting: false, isSuccess: true),
          ],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'registerDevice fails if user is not admin',
      build: () {
        when(() => mockPrefs.getUser()).thenReturn(
          UserModel(
            role: UserRoles.user,
            userId: '',
            email: '',
            organizationId: '',
          ),
        );
        getIt.registerSingleton<PreferenceHelper>(mockPrefs);

        cubit
          ..updateSelectedOrganization('Org', 'orgId')
          ..updateSelectedProductType('Toco')
          ..updateDeviceName('DevName')
          ..updateKitId('Kit007');

        return cubit;
      },
      act: (cubit) => cubit.registerDevice(),
      expect:
          () => [
            cubit.state.copyWith(
              isSubmitting: true,
              clearErrorMessage: () => null,
            ),
            cubit.state.copyWith(
              isSubmitting: false,
              errorMessage: 'doctor role cannot register device',
            ),
          ],
    );

    blocTest<DeviceRegistrationCubit, DeviceRegistrationState>(
      'registerDevice emits error on Appwrite exception',
      build: () {
        when(() => mockPrefs.getUser()).thenReturn(
          UserModel(
            role: UserRoles.admin,
            userId: '',
            email: '',
            organizationId: '',
          ),
        );
        getIt.registerSingleton<PreferenceHelper>(mockPrefs);

        when(
          () => mockDb.createDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('Failed'));

        cubit
          ..updateSelectedOrganization('Org', 'orgId')
          ..updateSelectedProductType('Toco')
          ..updateDeviceName('DevName')
          ..updateKitId('Kit007');

        return cubit;
      },
      act: (cubit) => cubit.registerDevice(),
      expect:
          () => [
            cubit.state.copyWith(
              isSubmitting: true,
              clearErrorMessage: () => null,
            ),
            cubit.state.copyWith(
              isSubmitting: false,
              errorMessage: 'Error: Exception: Failed',
            ),
          ],
    );
  });
}
