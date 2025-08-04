import 'package:fetosense_mis/core/models/org_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite/models.dart' as models;

class MockDocument extends models.Document {
  MockDocument({required String id})
      : super(
    $id: id,
    $collectionId: 'test_collection',
    $databaseId: 'test_db',
    $createdAt: '',
    $updatedAt: '',
    $permissions: [],
    data: {},
  );
}

void main() {
  group('OrganizationDetailsModel', () {
    late List<models.Document> mockDocs;

    setUp(() {
      mockDocs = [MockDocument(id: 'org1'), MockDocument(id: 'org2')];
    });

    test('should create a valid OrganizationDetailsModel instance', () {
      final model = OrganizationDetailsModel(
        organizations: mockDocs,
        deviceCount: 5,
        motherCount: 100,
        testCount: 400,
        doctorCount: 20,
      );

      expect(model.organizations, mockDocs);
      expect(model.deviceCount, 5);
      expect(model.motherCount, 100);
      expect(model.testCount, 400);
      expect(model.doctorCount, 20);
    });

    test('copyWith should override specified fields only', () {
      final model = OrganizationDetailsModel(
        organizations: mockDocs,
        deviceCount: 5,
        motherCount: 100,
        testCount: 400,
        doctorCount: 20,
      );

      final updated = model.copyWith(
        deviceCount: 10,
        testCount: 450,
      );

      expect(updated.organizations, model.organizations); // unchanged
      expect(updated.deviceCount, 10);
      expect(updated.motherCount, model.motherCount); // unchanged
      expect(updated.testCount, 450);
      expect(updated.doctorCount, model.doctorCount); // unchanged
    });

    test('copyWith with no arguments returns identical model', () {
      final model = OrganizationDetailsModel(
        organizations: mockDocs,
        deviceCount: 5,
        motherCount: 100,
        testCount: 400,
        doctorCount: 20,
      );

      final copy = model.copyWith();

      expect(copy.organizations, model.organizations);
      expect(copy.deviceCount, model.deviceCount);
      expect(copy.motherCount, model.motherCount);
      expect(copy.testCount, model.testCount);
      expect(copy.doctorCount, model.doctorCount);
      expect(copy, isNot(same(model))); // new instance
    });
  });
}
