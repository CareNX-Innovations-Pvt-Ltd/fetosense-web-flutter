import 'package:fetosense_mis/utils/fetch_tests.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

import 'fetch_tests_test.mocks.dart';
@GenerateMocks([Databases])
void main() {
  group('fetchTests', () {
    late MockDatabases mockDatabases;

    setUp(() {
      mockDatabases = MockDatabases();
    });

    test('should return a list of tests when the query succeeds', () async {
      // Arrange
      final mockDocuments = [
        models.Document($id: '1', data: {'type': 'test'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
        models.Document($id: '2', data: {'type': 'test'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
      ];
      final mockResult = models.DocumentList(documents: mockDocuments, total: 2);

      when(mockDatabases.listDocuments(
        databaseId: anyNamed('databaseId'),
        collectionId: anyNamed('collectionId'),
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockResult);

      // Act
      final result = await fetchTests(mockDatabases);

      // Assert
      expect(result, mockDocuments);
      verify(mockDatabases.listDocuments(
        databaseId: '67ece4a7002a0a732dfd',
        collectionId: '67f3790a0024f8f61684',
        queries: [],
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
      final result = await fetchTests(mockDatabases);

      // Assert
      expect(result, isEmpty);
    });

    test('should apply date filters correctly', () async {
      // Arrange
      final fromDate = DateTime(2023, 1, 1);
      final tillDate = DateTime(2023, 1, 31);
      final mockDocuments = [
        models.Document($id: '1', data: {'type': 'test'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: []),
      ];
      final mockResult = models.DocumentList(documents: mockDocuments, total: 1);

      when(mockDatabases.listDocuments(
        databaseId: anyNamed('databaseId'),
        collectionId: anyNamed('collectionId'),
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockResult);

      // Act
      final result = await fetchTests(
        mockDatabases,
        fromDate: fromDate,
        tillDate: tillDate,
      );

      // Assert
      expect(result, mockDocuments);
      verify(mockDatabases.listDocuments(
        databaseId: '67ece4a7002a0a732dfd',
        collectionId: '67f3790a0024f8f61684',
        queries: [
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