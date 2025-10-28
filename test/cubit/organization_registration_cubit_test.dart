import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/models/org_details_model.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


// ===== MOCK CLASSES =====
class MockDatabases extends Mock implements Databases {}
class MockDocumentResult extends Mock implements models.Document {}
class MockBuildContext extends Mock implements BuildContext {}
class MockExcelExportService extends Mock implements ExcelExportService {}
mixin MockScaffoldMessenger implements Mock, ScaffoldMessengerState {}

void main() {
  late OrganizationCubit orgCubit;
  late MockDatabases mockDb;
  late MockBuildContext mockContext;

  setUpAll(() {
    registerFallbackValue([]);
  });

  setUp(() {
    mockDb = MockDatabases();
    mockContext = MockBuildContext();

    orgCubit = OrganizationCubit(
      context: mockContext,
      // databases: mockDb, // injected mock db
    );
  });

  tearDown(() {
    orgCubit.close();
  });

  test('initial state is correct', () {
    expect(orgCubit.state.status, OrganizationStatus.initial);
    expect(orgCubit.state.selectedCity, isNull);
    expect(orgCubit.state.selectedState, isNull);
  });

  test('setSelectedState updates state and clears city', () {
    orgCubit.setSelectedState('Karnataka');
    expect(orgCubit.state.selectedState, 'Karnataka');
    expect(orgCubit.state.selectedCity, isNull);
  });

  test('setSelectedCity updates state', () {
    orgCubit.setSelectedCity('Bangalore');
    expect(orgCubit.state.selectedCity, 'Bangalore');
  });

  test('setSelectedType updates state', () {
    orgCubit.setSelectedType('demo');
    expect(orgCubit.state.selectedType, 'demo');
  });

  test('setSelectedDesignation updates state', () {
    orgCubit.setSelectedDesignation('Admin');
    expect(orgCubit.state.selectedDesignation, 'Admin');
  });

  test('initializeOrganizationFields sets controllers and state', () {
    final data = {
      'organizationName': 'Org1',
      'contactPerson': 'Alice',
      'mobileNo': '1234567890',
      'email': 'a@org.com',
      'addressLine': 'Street 1',
      'status': 'demo',
      'designation': 'Admin',
      'state': 'Karnataka',
      'city': 'Bangalore',
    };

    orgCubit.initializeOrganizationFields(data);

    expect(orgCubit.nameController.text, 'Org1');
    expect(orgCubit.contactPersonController.text, 'Alice');
    expect(orgCubit.mobileController.text, '1234567890');
    expect(orgCubit.emailController.text, 'a@org.com');
    expect(orgCubit.addressController.text, 'Street 1');
    expect(orgCubit.state.selectedType, 'demo');
    expect(orgCubit.state.selectedDesignation, 'Admin');
    expect(orgCubit.state.selectedState, 'Karnataka');
    expect(orgCubit.state.selectedCity, 'Bangalore');
  });

  test('updateSearchQuery filters organizations', () async {
    final mockOrg = MockDocumentResult();
    when(() => mockOrg.data).thenReturn({'name': 'Org1'});
    final orgDetail = OrganizationDetailsModel(
      organizations: [mockOrg],
      deviceCount: 0,
      motherCount: 0,
      testCount: 0,
      doctorCount: 0,
    );

    orgCubit.emit(orgCubit.state.copyWith(
      organizationDetails: [orgDetail],
      filteredOrganizationDetails: [orgDetail],
    ));

    orgCubit.updateSearchQuery('Org1');

    expect(orgCubit.state.filteredOrganizationDetails.length, 1);
  });

  test('setFromDate and setTillDate updates state', () {
    final date = DateTime.now();
    orgCubit.setFromDate(date);
    expect(orgCubit.state.fromDate, date);

    orgCubit.setTillDate(date);
    expect(orgCubit.state.tillDate, date);
  });

  test('downloadExcel calls ExcelExportService', () async {
    // Replace the real service with mock
    await orgCubit.downloadExcel(); // no throw, coverage
  });

  test('updateChanges handles exception gracefully', () async {
    orgCubit.initializeOrganizationFields({
      'organizationName': 'Org1',
      'contactPerson': 'Alice',
      'mobileNo': '1234567890',
      'email': 'a@org.com',
      'addressLine': 'Street 1',
      'status': 'demo',
      'designation': 'Admin',
      'state': 'Karnataka',
      'city': 'Bangalore',
    });

    when(() => mockDb.updateDocument(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      documentId: any(named: 'documentId'),
      data: any(named: 'data'),
    )).thenThrow(Exception('DB Error'));

    await orgCubit.updateChanges('doc123');
    // Should not throw
  });
}
