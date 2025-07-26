import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/utils/fetch_doctors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;


import 'fetch_doctors_test.mocks.dart';

@GenerateMocks([Databases])
void main() {
  group('fetchDoctors', () {
    late MockDatabases mockDb;

    setUp(() {
      mockDb = MockDatabases();
    });

    test('should return a list of doctors when no filters are applied', () async {
      final mockDocuments = [
        models.Document(
          $id: '1',
          $collectionId: AppConstants.userCollectionId,
          $databaseId: AppConstants.appwriteDatabaseId,
          $createdAt: '2023-10-27T10:00:00.000Z',
          $updatedAt: '2023-10-27T10:00:00.000Z',
          $permissions: [],
          data: {'type': 'doctor'},
        ),
      ];
      final mockDocumentList = models.DocumentList(
        total: 1,
        documents: mockDocuments,
      );

      when(mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockDocumentList);

      final doctors = await fetchDoctors(mockDb);

      expect(doctors, isA<List<models.Document>>());
      expect(doctors.length, 1);
      expect(doctors[0].data['type'], 'doctor');
    });

    test('should return a list of doctors when fromDate filter is applied', () async {
      final fromDate = DateTime(2023, 10, 26);
      final mockDocuments = [
        models.Document(
          $id: '1',
          $collectionId: AppConstants.userCollectionId,
          $databaseId: AppConstants.appwriteDatabaseId,
          $createdAt: '2023-10-27T10:00:00.000Z',
          $updatedAt: '2023-10-27T10:00:00.000Z',
          $permissions: [],
          data: {'type': 'doctor'},
        ),
      ];
      final mockDocumentList = models.DocumentList(
        total: 1,
        documents: mockDocuments,
      );

      when(mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockDocumentList);

      final doctors = await fetchDoctors(mockDb, fromDate: fromDate);

      expect(doctors, isA<List<models.Document>>());
      expect(doctors.length, 1);
    });

    test('should return a list of doctors when tillDate filter is applied', () async {
      final tillDate = DateTime(2023, 10, 28);
      final mockDocuments = [
        models.Document(
          $id: '1',
          $collectionId: AppConstants.userCollectionId,
          $databaseId: AppConstants.appwriteDatabaseId,
          $createdAt: '2023-10-27T10:00:00.000Z',
          $updatedAt: '2023-10-27T10:00:00.000Z',
          $permissions: [],
          data: {'type': 'doctor'},
        ),
      ];
      final mockDocumentList = models.DocumentList(
        total: 1,
        documents: mockDocuments,
      );

      when(mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockDocumentList);

      final doctors = await fetchDoctors(mockDb, tillDate: tillDate);

      expect(doctors, isA<List<models.Document>>());
      expect(doctors.length, 1);
    });

    test('should return a list of doctors when both fromDate and tillDate filters are applied', () async {
      final fromDate = DateTime(2023, 10, 26);
      final tillDate = DateTime(2023, 10, 28);
      final mockDocuments = [
        models.Document(
          $id: '1',
          $collectionId: AppConstants.userCollectionId,
          $databaseId: AppConstants.appwriteDatabaseId,
          $createdAt: '2023-10-27T10:00:00.000Z',
          $updatedAt: '2023-10-27T10:00:00.000Z',
          $permissions: [],
          data: {'type': 'doctor'},
        ),
      ];
      final mockDocumentList = models.DocumentList(
        total: 1,
        documents: mockDocuments,
      );

      when(mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => mockDocumentList);

      final doctors = await fetchDoctors(mockDb, fromDate: fromDate, tillDate: tillDate);

      expect(doctors, isA<List<models.Document>>());
      expect(doctors.length, 1);
    });

    test('should return an empty list when no doctors are found', () async {
      when(mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => models.DocumentList(total: 0, documents: []));

      final doctors = await fetchDoctors(mockDb);

      expect(doctors, isA<List<models.Document>>());
      expect(doctors.length, 0);
    });

    test('should return an empty list when an error occurs', () async {
      when(mockDb.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: anyNamed('queries'),
      )).thenThrow(Exception('Something went wrong'));

      final doctors = await fetchDoctors(mockDb);

      expect(doctors, isA<List<models.Document>>());
      expect(doctors.length, 0);
    });
  });
}