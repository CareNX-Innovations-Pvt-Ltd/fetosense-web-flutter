import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/doctoredit/doctor_edit_popup.dart';
import 'package:fetosense_mis/screens/doctor_details/widgets/doctor_details_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:data_table_2/data_table_2.dart';

class MockDocument extends Mock implements models.Document {}

class FakeNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late DoctorDetailsState emptyState;
  late DoctorDetailsState populatedState;
  late MockDocument doc;

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => const SizedBox()));
  });

  setUp(() {
    doc = MockDocument();

    when(() => doc.data).thenReturn({
      'doctorName': 'Dr. Strange',
      'email': 'strange@marvel.com',
      'organizationName': 'Kamar Taj',
      'noOfMother': 5,
      'noOfTests': 10,
      'createdOn': '2025-10-24T10:00:00Z',
      'lastLoginTime': '2025-10-25T10:00:00Z',
      'appVersion': '1.2.3',
    });

    when(() => doc.$id).thenReturn('doc123');

    emptyState = const DoctorDetailsState(
      doctorDetails: [],
      filteredDoctors: [],
      fromDate: null,
      tillDate: null,
      clearError: false,
      errorMessage: null,
        searchQuery: '',
        clearTillDate: true,
        clearFromDate: true,
        status: DoctorStatus.initial
    );

    populatedState = DoctorDetailsState(
      doctorDetails: [doc],
      filteredDoctors: [doc],
      fromDate: DateTime(2025, 10, 24),
      tillDate: DateTime(2025, 10, 25),
      clearError: false,
      errorMessage: null,
      searchQuery: '',
      clearTillDate: true,
      clearFromDate: true,
      status: DoctorStatus.initial
    );
  });

  group('DoctorDetailsTable Widget', () {
    testWidgets('shows "No data available" when filteredDoctors is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDetailsTable(state: emptyState),
          ),
        ),
      );

      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('renders DataTable2 when doctors are available', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDetailsTable(state: populatedState),
          ),
        ),
      );

      // Verify DataTable2 exists
      expect(find.byType(DataTable2), findsOneWidget);

      // Verify column headers
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Organization'), findsOneWidget);
      expect(find.text('Mother'), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('CreatedOn'), findsOneWidget);
      expect(find.text('L.O.T'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);

      // Verify data cells
      expect(find.text('Dr. Strange'), findsOneWidget);
      expect(find.text('strange@marvel.com'), findsOneWidget);
      expect(find.text('Kamar Taj'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('1.2.3'), findsOneWidget);

      // Verify Edit button
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('tapping Edit shows DoctorEditPopup and closes on onClose', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [FakeNavigatorObserver()],
          home: Scaffold(
            body: DoctorDetailsTable(state: populatedState),
          ),
        ),
      );

      // Tap Edit button
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Verify dialog and popup appear
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(DoctorEditPopup), findsOneWidget);

      // Trigger onClose callback
      final popup = tester.widget<DoctorEditPopup>(find.byType(DoctorEditPopup));
      popup.onClose();
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('Helper methods coverage', () {
    testWidgets('covers _buildDataColumn and _buildDataCell indirectly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDetailsTable(state: populatedState),
          ),
        ),
      );

      // The cells are built internally – verify text rendering (indirect coverage)
      expect(find.text('Dr. Strange'), findsOneWidget);
    });
  });
}
