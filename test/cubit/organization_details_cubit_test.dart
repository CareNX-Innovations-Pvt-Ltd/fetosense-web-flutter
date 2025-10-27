import 'package:appwrite/models.dart';
import 'package:fetosense_mis/core/models/org_details_model.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';

// --- Mocks ---
class MockDatabases extends Mock implements Databases {}
class MockDocument extends Mock implements Document {}
class MockExcelExportService extends Mock implements ExcelExportService {}
class MockBuildContext extends Mock implements BuildContext {}
mixin MockScaffoldMessengerState implements Mock, ScaffoldMessengerState {}

void main() {
  late OrganizationCubit cubit;
  late MockBuildContext context;

  setUp(() {
    context = MockBuildContext();
    cubit = OrganizationCubit(context: context);

    cubit.nameController = TextEditingController();
    cubit.contactPersonController = TextEditingController();
    cubit.mobileController = TextEditingController();
    cubit.emailController = TextEditingController();
    cubit.addressController = TextEditingController();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('Initial state is correct', () {
    expect(cubit.state.status, OrganizationStatus.initial);
    expect(cubit.state.organizationDetails, []);
  });

  test('setSelectedState updates state and clears city', () {
    cubit.emit(cubit.state.copyWith(selectedCity: 'OldCity'));
    cubit.setSelectedState('NewState');

    expect(cubit.state.selectedState, 'NewState');
    expect(cubit.state.selectedCity, null);
  });

  test('setSelectedCity updates state', () {
    cubit.setSelectedCity('CityX');
    expect(cubit.state.selectedCity, 'CityX');
  });

  test('setSelectedType updates state', () {
    cubit.setSelectedType('TypeX');
    expect(cubit.state.selectedType, 'TypeX');
  });

  test('setSelectedDesignation updates state', () {
    cubit.setSelectedDesignation('Admin');
    expect(cubit.state.selectedDesignation, 'Admin');
  });

  test('initializeOrganizationFields sets controllers and state', () {
    final data = {
      'organizationName': 'Org1',
      'contactPerson': 'Person1',
      'mobileNo': '1234567890',
      'email': 'org@test.com',
      'addressLine': 'Address1',
      'status': 'sold',
      'designation': 'Admin',
      'city': 'City1',
      'state': 'State1',
    };

    cubit.initializeOrganizationFields(data);

    expect(cubit.nameController.text, 'Org1');
    expect(cubit.contactPersonController.text, 'Person1');
    expect(cubit.mobileController.text, '1234567890');
    expect(cubit.emailController.text, 'org@test.com');
    expect(cubit.addressController.text, 'Address1');
    expect(cubit.state.selectedType, 'sold');
    expect(cubit.state.selectedDesignation, 'Admin');
    expect(cubit.state.selectedCity, 'City1');
    expect(cubit.state.selectedState, 'State1');
  });

  test('setFromDate and setTillDate update state', () {
    final from = DateTime.now();
    final till = DateTime.now().add(const Duration(days: 1));

    cubit.setFromDate(from);
    expect(cubit.state.fromDate, from);

    cubit.setTillDate(till);
    expect(cubit.state.tillDate, till);

    // clearing
    cubit.setFromDate(null);
    expect(cubit.state.fromDate, null);

    cubit.setTillDate(null);
    expect(cubit.state.tillDate, null);
  });

  test('updateSearchQuery sets searchQuery and filters', () {
    final doc = MockDocument();
    when(() => doc.data).thenReturn({'name': 'TestOrg'});
    cubit.emit(cubit.state.copyWith(
      organizationDetails: [
        OrganizationDetailsModel(
          organizations: [doc],
          deviceCount: 0,
          motherCount: 0,
          testCount: 0,
          doctorCount: 0,
        )
      ],
    ));

    cubit.updateSearchQuery('test');
    expect(cubit.state.filteredOrganizationDetails.length, 1);

    cubit.updateSearchQuery('nonexistent');
    expect(cubit.state.filteredOrganizationDetails.length, 0);
  });

  test('downloadExcel calls ExcelExportService', () async {
    final doc = MockDocument();
    when(() => doc.data).thenReturn({'name': 'Org1'});
    cubit.emit(cubit.state.copyWith(
      filteredOrganizationDetails: [
        OrganizationDetailsModel(
          organizations: [doc],
          deviceCount: 1,
          motherCount: 2,
          testCount: 3,
          doctorCount: 4,
        )
      ],
    ));

    await cubit.downloadExcel();
  });
}
