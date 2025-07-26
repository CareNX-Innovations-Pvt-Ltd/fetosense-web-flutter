import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/utils/fetch_organizations.dart';

import 'fetch_organization_test.mocks.dart';

@GenerateMocks([Databases])

void main() {
  group('fetchOrganizations', () {
    late MockDatabases mockDatabases;

    setUp(() {
      mockDatabases = MockDatabases();
    });

    test('should return a list of organizations when the query succeeds', () async {
      // Arrange
      final mockDocuments = [
        models.Document($id: '1', data: {'type': 'organization'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
        models.Document($id: '2', data: {'type': 'organization'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
      ];
      final mockResult = models.DocumentList(documents: mockDocuments, total: 2);

      when(mockDatabases.listDocuments(
        databaseId: anyNamed('databaseId'),
        collectionId: anyNamed('collectionId'),
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockResult);

      // Act
      final result = await fetchOrganizations(mockDatabases);

      // Assert
      expect(result, mockDocuments);
      verify(mockDatabases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [Query.equal('type', 'organization')],
      )).called(1);
    });

    test('should return an empty list when an error occurs', () async {
      // Arrange
      when(mockDatabases.listDocuments(
        databaseId: anyNamed('databaseId'),
        collectionId: anyNamed('collectionId'),
        queries: anyNamed('queries'),
      )).thenThrow(Exception('Database error'));

      // Act
      final result = await fetchOrganizations(mockDatabases);

      // Assert
      expect(result, isEmpty);
    });

    test('should apply date filters correctly', () async {
      // Arrange
      final fromDate = DateTime(2023, 1, 1);
      final tillDate = DateTime(2023, 1, 31);
      final mockDocuments = [
        models.Document($id: '1', data: {'type': 'organization'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
      ];
      final mockResult = models.DocumentList(documents: mockDocuments, total: 1);

      when(mockDatabases.listDocuments(
        databaseId: anyNamed('databaseId'),
        collectionId: anyNamed('collectionId'),
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockResult);

      // Act
      final result = await fetchOrganizations(
        mockDatabases,
        fromDate: fromDate,
        tillDate: tillDate,
      );

      // Assert
      expect(result, mockDocuments);
      verify(mockDatabases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [
          Query.equal('type', 'organization'),
          Query.isNotNull('createdOn'),
          Query.greaterThanEqual('createdOn', fromDate.toIso8601String()),
          Query.lessThanEqual(
            'createdOn',
            DateTime(2023, 1, 31, 23, 59, 59).toIso8601String(),
          ),
        ],
      )).called(1);
    });
  });
}