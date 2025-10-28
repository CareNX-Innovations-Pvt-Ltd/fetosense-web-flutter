import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabases extends Mock implements Databases {}

class MockDocument extends Mock implements models.Document {}

void main() {
  late DoctorDetailsCubit cubit;
  late MockDatabases mockDb;

  setUp(() {
    mockDb = MockDatabases();

    // Replace the real db with mock
    cubit = DoctorDetailsCubit();
  });

  group('DoctorDetailsCubit', () {
    test('initial state', () {
      expect(cubit.state.isLoading, false);
      expect(cubit.state.allDoctors, []);
      expect(cubit.state.filteredDoctors, []);
      expect(cubit.state.error, null);
    });

    test('updapdates state', () {
      final date = DateTime(2025, 10, 24);
      cubit.updateFromDate(date);
      expect(cubit.state.fromDate, date);
    });

    test('updateTillDate updates state', () {
      final date = DateTime(2025, 10, 25);
      cubit.updateTillDate(date);
      expect(cubit.state.tillDate, date);
    });

    test('applySearchFilter filters correctly', () {
      final doc1 = models.Document(
        $id: '1',
        $collectionId: 'col1',
        $databaseId: 'db1',
        $createdAt: '',
        $updatedAt: '',
        data: {
          'doctorName': 'Alice',
          'email': 'alice@test.com',
          'organizationName': 'OrgA',
        },
        $permissions: [],
      );
      final doc2 = models.Document(
        $id: '2',
        $collectionId: 'col1',
        $databaseId: 'db1',
        $createdAt: '',
        $updatedAt: '',
        data: {
          'doctorName': 'Bob',
          'email': 'bob@test.com',
          'organizationName': 'OrgB',
        },
        $permissions: [],
      );

      cubit.emit(
        cubit.state.copyWith(
          allDoctors: [doc1, doc2],
          filteredDoctors: [doc1, doc2],
        ),
      );

      cubit.applySearchFilter('alice');
      expect(cubit.state.filteredDoctors.length, 1);
      expect(cubit.state.filteredDoctors.first.$id, '1');

      cubit.applySearchFilter('orgb');
      expect(cubit.state.filteredDoctors.length, 1);
      expect(cubit.state.filteredDoctors.first.$id, '2');

      cubit.applySearchFilter('nonexistent');
      expect(cubit.state.filteredDoctors.length, 0);
    });

    test('fetchDoctorsId success', () async {
      final doc = MockDocument();
      when(() => doc.data).thenReturn({'doctorName': 'DrX'});
      when(() => doc.$id).thenReturn('doc1');
      when(() => doc.$collectionId).thenReturn('col1');
      when(() => doc.$databaseId).thenReturn('db1');
      when(() => doc.$createdAt).thenReturn('');
      when(() => doc.$updatedAt).thenReturn('');
      when(
        () => mockDb.listDocuments(
          databaseId: any(named: 'databaseId'),
          collectionId: any(named: 'collectionId'),
          queries: any(named: 'queries'),
        ),
      ).thenAnswer(
        (_) async => models.DocumentList(documents: [doc], total: 1),
      );

      // Mock mothers and tests calls
      when(
        () => mockDb.listDocuments(
          databaseId: any(named: 'databaseId'),
          collectionId: any(named: 'collectionId'),
          queries: any(named: 'queries'),
        ),
      ).thenAnswer((_) async => models.DocumentList(documents: [], total: 0));

      await cubit.fetchDoctorsId();

      expect(cubit.state.isLoading, false);
      expect(cubit.state.allDoctors.length, 1);
      expect(cubit.state.allDoctors.first.data['noOfMother'], 0);
      expect(cubit.state.allDoctors.first.data['noOfTests'], 0);
    });

    test('fetchDoctorsId failure', () async {
      when(
        () => mockDb.listDocuments(
          databaseId: any(named: 'databaseId'),
          collectionId: any(named: 'collectionId'),
          queries: any(named: 'queries'),
        ),
      ).thenThrow(Exception('Failed'));

      await cubit.fetchDoctorsId();

      expect(cubit.state.isLoading, false);
      expect(cubit.state.error, isNotNull);
      expect(cubit.state.error, contains('Failed'));
    });
  });
}
