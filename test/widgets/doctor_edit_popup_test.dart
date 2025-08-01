import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/screens/doctor_details/doctoredit/doctor_edit_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/doctoredit/doctor_edit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

import 'doctor_edit_popup_test.mocks.dart';

@GenerateMocks([Databases, AppwriteService, DoctorEditCubit])
void main() {
  final locator = GetIt.instance;

  late MockDatabases mockDb;
  late MockAppwriteService mockAppwriteService;

  const mockDocumentId = 'doc123';
  final mockData = {
    'doctorName': 'Dr. Widget',
    'mobileNo': 1234567890,
    'email': 'drwidget@example.com',
    'name': 'Dr. Widget',
    'mother': 10,
    'test': 20,
  };

  setUp(() {
    mockDb = MockDatabases();
    mockAppwriteService = MockAppwriteService();

    locator.registerSingleton<AppwriteService>(mockAppwriteService);
    when(mockAppwriteService.client).thenReturn(Client());
  });

  tearDown(() {
    locator.reset();
  });

  Widget createWidget(VoidCallback onClose) {
    return MaterialApp(
      home: Scaffold(
        body: DoctorEditPopup(
          data: mockData,
          documentId: mockDocumentId,
          onClose: onClose,
        ),
      ),
    );
  }

  testWidgets('renders all static content correctly', (tester) async {
    await tester.pumpWidget(createWidget(() {}));

    expect(find.text("Doctor Details"), findsOneWidget);
    expect(find.text("Update"), findsOneWidget);
    expect(find.text("Cancel"), findsOneWidget);
    expect(find.text("Reset Password"), findsOneWidget);
    expect(find.text("Mothers"), findsOneWidget);
    expect(find.text("Tests"), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2)); // Reset + Cancel
  });

  testWidgets('fills controllers with initial data', (tester) async {
    await tester.pumpWidget(createWidget(() {}));

    await tester.pump(); // wait for initialize() to complete

    expect(
      find.byWidgetPredicate((widget) =>
      widget is TextField && widget.controller?.text == 'drwidget@example.com'),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((widget) =>
      widget is TextField && widget.controller?.text == 'Dr. Widget'),
      findsNWidgets(2), // name and name from data
    );
  });

  testWidgets('shows loading indicator when state is DoctorEditSaving', (tester) async {
    final cubit = DoctorEditCubit(db: mockDb, documentId: mockDocumentId);
    cubit.emit(DoctorEditSaving());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<DoctorEditCubit>.value(
            value: cubit,
            child: DoctorEditPopup(
              data: mockData,
              documentId: mockDocumentId,
              onClose: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('calls onClose when cancel is pressed', (tester) async {
    var closed = false;

    await tester.pumpWidget(createWidget(() {
      closed = true;
    }));

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(closed, isTrue);
  });

  testWidgets('calls updateChanges on Update button tap', (tester) async {
    final cubit = MockDoctorEditCubit();
    when(cubit.state).thenReturn(DoctorEditLoaded());
    when(cubit.nameController).thenReturn(TextEditingController());
    when(cubit.emailController).thenReturn(TextEditingController());
    when(cubit.mobileController).thenReturn(TextEditingController());
    when(cubit.updateChanges(any, any)).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<DoctorEditCubit>.value(
            value: cubit,
            child: DoctorEditPopup(
              data: mockData,
              documentId: mockDocumentId,
              onClose: () {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    verify(cubit.updateChanges(any, any)).called(1);
  });
}
