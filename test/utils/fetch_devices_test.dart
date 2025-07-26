import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/utils/fetch_devices.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_devices_test.mocks.dart';

@GenerateMocks([Databases])
void main() {
  group('fetchDevices', () {
    late MockDatabases mockDatabases;

    setUp(() {
      mockDatabases = MockDatabases();
    });

    test(
      'should return a list of devices when the API call is successful',
      () async {
        final documents = [
          models.Document(
            $id: '1',
            $collectionId: 'collection',
            $databaseId: 'database',
            $createdAt: '2023-10-27T10:00:00.000Z',
            $updatedAt: '2023-10-27T10:00:00.000Z',
            $permissions: [],
            data: {'type': 'device'},
          ),
        ];
        final models.DocumentList mockDocumentList = models.DocumentList(
          total: 1,
          documents: documents,
        );

        when(
          mockDatabases.listDocuments(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            queries: anyNamed('queries'),
          ),
        ).thenAnswer((_) async => mockDocumentList);

        final result = await fetchDevices(mockDatabases);

        expect(result, isA<List<models.Document>>());
        expect(result.length, 1);
        expect(result[0].data['type'], 'device');
      },
    );

    test('should return an empty list when the API call fails', () async {
      when(
        mockDatabases.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: anyNamed('queries'),
        ),
      ).thenThrow(Exception('Failed to fetch devices'));

      final result = await fetchDevices(mockDatabases);

      expect(result, isA<List<models.Document>>());
      expect(result, isEmpty);
    });

    test('should filter by fromDate when fromDate is provided', () async {
      final fromDate = DateTime(2023, 10, 26);
      final documents = [
        models.Document(
          $id: '1',
          $collectionId: 'collection',
          $databaseId: 'database',
          $createdAt: '2023-10-27T10:00:00.000Z',
          $updatedAt: '2023-10-27T10:00:00.000Z',
          $permissions: [],
          data: {'type': 'device'},
        ),
      ];
      final models.DocumentList mockDocumentList = models.DocumentList(
        total: 1,
        documents: documents,
      );

      when(
        mockDatabases.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: argThat(
            contains(
              Query.greaterThanEqual('createdOn', fromDate.toIso8601String()),
            ),
            named: 'queries',
          ),
        ),
      ).thenAnswer((_) async => mockDocumentList);

      final result = await fetchDevices(mockDatabases, fromDate: fromDate);

      expect(result, isA<List<models.Document>>());
      expect(result.length, 1);
    });

    test('should filter by tillDate when tillDate is provided', () async {
      final tillDate = DateTime(2023, 10, 28);
      final documents = [
        models.Document(
          $id: '1',
          $collectionId: 'collection',
          $databaseId: 'database',
          $createdAt: '2023-10-27T10:00:00.000Z',
          $updatedAt: '2023-10-27T10:00:00.000Z',
          $permissions: [],
          data: {'type': 'device'},
        ),
      ];
      final models.DocumentList mockDocumentList = models.DocumentList(
        total: 1,
        documents: documents,
      );

      when(
        mockDatabases.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: argThat(
            contains(
              Query.lessThanEqual(
                'createdOn',
                DateTime(
                  tillDate.year,
                  tillDate.month,
                  tillDate.day,
                  23,
                  59,
                  59,
                ).toIso8601String(),
              ),
            ),
            named: 'queries',
          ),
        ),
      ).thenAnswer((_) async => mockDocumentList);

      final result = await fetchDevices(mockDatabases, tillDate: tillDate);

      expect(result, isA<List<models.Document>>());
      expect(result.length, 1);
    });

    test(
      'should filter by both fromDate and tillDate when both are provided',
      () async {
        final fromDate = DateTime(2023, 10, 26);
        final tillDate = DateTime(2023, 10, 28);
        final documents = [
          models.Document(
            $id: '1',
            $collectionId: 'collection',
            $databaseId: 'database',
            $createdAt: '2023-10-27T10:00:00.000Z',
            $updatedAt: '2023-10-27T10:00:00.000Z',
            $permissions: [],
            data: {'type': 'device'},
          ),
        ];
        final models.DocumentList mockDocumentList = models.DocumentList(
          total: 1,
          documents: documents,
        );

        when(
          mockDatabases.listDocuments(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            queries: argThat(
              containsAll([
                Query.greaterThanEqual('createdOn', fromDate.toIso8601String()),
                Query.lessThanEqual(
                  'createdOn',
                  DateTime(
                    tillDate.year,
                    tillDate.month,
                    tillDate.day,
                    23,
                    59,
                    59,
                  ).toIso8601String(),
                ),
              ]),
              named: 'queries',
            ),
          ),
        ).thenAnswer((_) async => mockDocumentList);

        final result = await fetchDevices(
          mockDatabases,
          fromDate: fromDate,
          tillDate: tillDate,
        );

        expect(result, isA<List<models.Document>>());
        expect(result.length, 1);
      },
    );

    test(
      'should include Query.isNotNull(\'createdOn\') when date filters are applied',
      () async {
        final fromDate = DateTime(2023, 10, 26);
        final documents = [
          models.Document(
            $id: '1',
            $collectionId: 'collection',
            $databaseId: 'database',
            $createdAt: '2023-10-27T10:00:00.000Z',
            $updatedAt: '2023-10-27T10:00:00.000Z',
            $permissions: [],
            data: {'type': 'device'},
          ),
        ];
        final models.DocumentList mockDocumentList = models.DocumentList(
          total: 1,
          documents: documents,
        );

        when(
          mockDatabases.listDocuments(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            queries: argThat(
              contains(Query.isNotNull('createdOn')),
              named: 'queries',
            ),
          ),
        ).thenAnswer((_) async => mockDocumentList);

        final result = await fetchDevices(mockDatabases, fromDate: fromDate);

        expect(result, isA<List<models.Document>>());
        expect(result.length, 1);
      },
    );
  });
}
