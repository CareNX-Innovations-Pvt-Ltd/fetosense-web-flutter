import 'package:appwrite/models.dart' as models;
import 'package:excel/excel.dart';
import 'package:fetosense_mis/core/models/org_details_model.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockBuildContext extends Mock implements BuildContext {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockBuildContext';
  }
}

class MockScaffoldMessengerState extends Mock
    implements ScaffoldMessengerState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockScaffoldMessengerState';
  }
}


class FakeDocument extends Fake implements models.Document {
  @override
  final Map<String, dynamic> data;

  FakeDocument(this.data);
}

class FakeOrganizationDetailsModel extends Fake
    implements OrganizationDetailsModel {
  @override
  final List<models.Document> organizations;

  @override
  final int doctorCount;
  @override
  final int motherCount;
  @override
  final int deviceCount;
  @override
  final int testCount;

  FakeOrganizationDetailsModel({
    required this.organizations,
    this.deviceCount = 1,
    this.doctorCount = 1,
    this.motherCount = 1,
    this.testCount = 1,
  });
}

class ThrowingDocument extends Fake implements models.Document {
  @override
  Map<String, dynamic> get data => throw Exception('Data access failed');
}


void main() {
  late MockBuildContext context;
  late MockScaffoldMessengerState scaffoldMessenger;

  setUpAll(() {
    registerFallbackValue(FakeDocument({}));
  });

  setUp(() {
    context = MockBuildContext();
    scaffoldMessenger = MockScaffoldMessengerState();

    when(() => ScaffoldMessenger.of(context)).thenReturn(scaffoldMessenger);
    // when(() => scaffoldMessenger.showSnackBar(any())).thenReturn(scaffoldMessenger);
  });

  group('ExcelExportService', () {
    testWidgets('exportDevicesToExcel - success', (tester) async {
      final docs = [
        FakeDocument({
          'deviceName': 'D1',
          'deviceCode': 'C123',
          'organizationName': 'Org',
          'noOfMother': 2,
          'noOfTests': 5,
          'createdOn': '2023-08-01',
          'appVersion': '1.0',
        }),
      ];

      await ExcelExportService.exportDevicesToExcel(context, docs);
      verifyNever(() => scaffoldMessenger.showSnackBar(any()));
    });

    testWidgets('exportDoctorsToExcel - success', (tester) async {
      final docs = [
        FakeDocument({
          'name': 'Dr. John',
          'email': 'john@example.com',
          'organizationName': 'Org',
          'noOfMother': 4,
          'noOfTests': 12,
          'createdOn': '2023-08-01',
          'lastLoginTime': '2023-08-01T10:00',
          'appVersion': '1.2',
        }),
      ];

      await ExcelExportService.exportDoctorsToExcel(context, docs);
      verifyNever(() => scaffoldMessenger.showSnackBar(any()));
    });

    testWidgets('exportMothersToExcel - success', (tester) async {
      final docs = [
        FakeDocument({
          'name': 'Jane',
          'organizationName': 'Org',
          'deviceName': 'D1',
          'doctorName': 'Dr. A',
          'noOfTests': 3,
        }),
      ];

      await ExcelExportService.exportMothersToExcel(context, docs);
      verifyNever(() => scaffoldMessenger.showSnackBar(any()));
    });

    testWidgets('exportOrganizationsToExcel - success', (tester) async {
      final orgData = {
        'name': 'Org 1',
        'mobile': '1234567890',
        'status': 'Active',
        'created_on': '2023-08-01',
        'addressLine': 'Street 1',
        'city': 'CityX',
        'state': 'StateY',
        'country': 'CountryZ',
        'email': 'org@example.com',
      };

      final orgDocs = [
        models.Document(
          data: orgData,
          $id: 'id1',
          $collectionId: '',
          $databaseId: '',
          $createdAt: '',
          $updatedAt: '',
          $permissions: [],
        )
      ];

      final fakeOrg = FakeOrganizationDetailsModel(
        organizations: orgDocs,
        doctorCount: 2,
        motherCount: 3,
        deviceCount: 1,
        testCount: 5,
      );

      await ExcelExportService.exportOrganizationsToExcel(context, [fakeOrg]);
      verifyNever(() => scaffoldMessenger.showSnackBar(any()));
    });

    testWidgets('exportDevicesToExcel - error shows SnackBar', (tester) async {
      ExcelExportService.excelFactory = () => throw Exception('mocked failure');

      await ExcelExportService.exportDevicesToExcel(context, []);

      verify(() => scaffoldMessenger.showSnackBar(any())).called(1);

      // Reset after test
      ExcelExportService.excelFactory = Excel.createExcel;
    });


    testWidgets('exportDoctorsToExcel - error shows SnackBar', (tester) async {
      final badDocs = <models.Document>[];

      await ExcelExportService.exportDoctorsToExcel(context, badDocs);

      verify(() => scaffoldMessenger.showSnackBar(any())).called(1);

      ExcelExportService.excelFactory = Excel.createExcel;
    });

    testWidgets('exportMothersToExcel - error shows SnackBar', (tester) async {
      final badDocs = <models.Document>[];

      await ExcelExportService.exportMothersToExcel(context, badDocs);

      verify(() => scaffoldMessenger.showSnackBar(any())).called(1);

      ExcelExportService.excelFactory = Excel.createExcel;
    });

    testWidgets('exportOrganizationsToExcel - error shows SnackBar',
            (tester) async {
          final fakeOrg = FakeOrganizationDetailsModel(organizations: []);

          await ExcelExportService.exportOrganizationsToExcel(context, [fakeOrg]);

          verify(() => scaffoldMessenger.showSnackBar(any())).called(1);

          ExcelExportService.excelFactory = Excel.createExcel;
        });
  });
}
