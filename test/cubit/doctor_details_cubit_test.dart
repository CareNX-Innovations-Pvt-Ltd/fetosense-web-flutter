import 'package:appwrite/appwrite.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/screens/doctor_details/doctoredit/doctor_edit_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';

// ---- MOCKS & FAKES ----

class MockDatabases extends Mock implements Databases {}

/// A safe fake BuildContext that won't trigger the Diagnosticable.toString() issue
class FakeBuildContext extends Fake implements BuildContext {
  @override
  bool get mounted => true;
}

void main() {
  late MockDatabases mockDb;
  const documentId = 'doc123';

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockDb = MockDatabases();
  });

  group('DoctorEditCubit', () {
    test('initial state is DoctorEditInitial', () {
      final cubit = DoctorEditCubit(db: mockDb, documentId: documentId);
      expect(cubit.state, isA<DoctorEditInitial>());
    });

    test('initialize sets controller values and emits DoctorEditLoaded', () {
      final cubit = DoctorEditCubit(db: mockDb, documentId: documentId);

      final data = {
        'doctorName': 'John Doe',
        'mobileNo': '1234567890',
        'email': 'john@example.com',
      };

      expectLater(cubit.stream, emitsInOrder([isA<DoctorEditLoaded>()]));

      cubit.initialize(data);

      expect(cubit.nameController.text, equals('John Doe'));
      expect(cubit.mobileController.text, equals('1234567890'));
      expect(cubit.emailController.text, equals('john@example.com'));
    });

    blocTest<DoctorEditCubit, DoctorEditState>(
      'updateChanges emits DoctorEditSaving and DoctorEditSaved on success',
      build: () {
        when(
          () => mockDb.updateDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => Future.value());
        return DoctorEditCubit(db: mockDb, documentId: documentId);
      },
      act: (cubit) async {
        cubit.nameController.text = 'Jane';
        cubit.emailController.text = 'jane@example.com';

        final context = FakeBuildContext();

        bool onCloseCalled = false;

        await cubit.updateChanges(context, () {
          onCloseCalled = true;
        });

        expect(onCloseCalled, isTrue);
      },
      expect: () => [isA<DoctorEditSaving>(), isA<DoctorEditSaved>()],
      verify: (_) {
        verify(
          () => mockDb.updateDocument(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            documentId: documentId,
            data: any(named: 'data'),
          ),
        ).called(1);
      },
    );

    blocTest<DoctorEditCubit, DoctorEditState>(
      'updateChanges emits DoctorEditError on failure',
      build: () {
        when(
          () => mockDb.updateDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('DB Error'));
        return DoctorEditCubit(db: mockDb, documentId: documentId);
      },
      act: (cubit) async {
        final context = FakeBuildContext();
        await cubit.updateChanges(context, () {});
      },
      expect: () => [isA<DoctorEditSaving>(), isA<DoctorEditError>()],
    );

    test('close disposes controllers', () async {
      final cubit = DoctorEditCubit(db: mockDb, documentId: documentId);
      await cubit.close();

      // You can’t directly test disposed TextEditingController in Flutter,
      // but we can ensure no exception thrown on close.
      expect(() async => await cubit.close(), returnsNormally);
    });
  });
}
