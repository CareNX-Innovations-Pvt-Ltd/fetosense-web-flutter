import 'package:appwrite/appwrite.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/screens/doctor_details/doctoredit/doctor_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../core/services/auth_service_test.dart';


@GenerateMocks([Databases])
void main() {
  late MockDatabases mockDb;
  late DoctorEditCubit cubit;

  const mockDocId = 'doctor123';

  setUp(() {
    mockDb = MockDatabases();
    cubit = DoctorEditCubit(db: mockDb, documentId: mockDocId);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('DoctorEditCubit', () {
    test('initial state is DoctorEditInitial', () {
      expect(cubit.state, DoctorEditInitial());
    });

    test('initialize sets controllers and emits DoctorEditLoaded', () {
      final data = {
        'doctorName': 'Dr. Alice',
        'mobileNo': 1234567890,
        'email': 'alice@example.com',
      };

      expectLater(cubit.stream, emitsInOrder([DoctorEditLoaded()]));

      cubit.initialize(data);

      expect(cubit.nameController.text, 'Dr. Alice');
      expect(cubit.mobileController.text, '1234567890');
      expect(cubit.emailController.text, 'alice@example.com');
    });

    testWidgets('updateChanges emits DoctorEditSaved on success and calls onClose', (tester) async {
      cubit.nameController.text = 'Dr. Bob';
      cubit.emailController.text = 'bob@example.com';

      when(mockDb.updateDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        documentId: 'documentId',
        data: anyNamed('data'),
      )).thenAnswer((_) => Future.value());

      final mockOnCloseCalled = ValueNotifier(false);

      final widget = MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                cubit.updateChanges(context, () {
                  mockOnCloseCalled.value = true;
                });
              },
              child: const Text('Update'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.text('Update'));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(cubit.state, DoctorEditSaved());
      expect(mockOnCloseCalled.value, true);
    });

    testWidgets('updateChanges emits DoctorEditError on failure', (tester) async {
      cubit.nameController.text = 'Dr. Error';
      cubit.emailController.text = 'error@example.com';

      when(mockDb.updateDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        documentId: 'documentId',
        data: anyNamed('data'),
      )).thenThrow(Exception('network error'));

      final widget = MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                cubit.updateChanges(context, () {});
              },
              child: const Text('Update'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.text('Update'));
      await tester.pump(); // emits saving
      await tester.pump(); // completes async
      await tester.pump(); // SnackBar

      expect(cubit.state.toString(), contains('DoctorEditError'));
    });

    test('close disposes controllers', () async {
      final name = cubit.nameController;
      final mobile = cubit.mobileController;
      final email = cubit.emailController;

      await cubit.close();

      expect(() => name.text, throwsA(isA<AssertionError>())); // disposed
      expect(() => mobile.text, throwsA(isA<AssertionError>()));
      expect(() => email.text, throwsA(isA<AssertionError>()));
    });
  });
}
