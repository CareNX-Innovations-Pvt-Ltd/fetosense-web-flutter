import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/widgets/doctor_details_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorDetailsCubit extends Mock implements DoctorDetailsCubit {}

class MockDocument extends Mock implements models.Document {}

void main() {
  late MockDoctorDetailsCubit cubit;
  late DoctorDetailsState state;

  setUp(() {
    cubit = MockDoctorDetailsCubit();
    state = DoctorDetailsState(
      // allDoctors: [],
      filteredDoctors: [],
      fromDate: DateTime(2025, 10, 24),
      tillDate: DateTime(2025, 10, 25),
      status: DoctorStatus.initial,
      clearError: false,
      clearFromDate: true,
      clearTillDate: true,
      doctorDetails: [],
      errorMessage: '',
      searchQuery: '',
      // isLoading: false,
      // error: null,
    );
  });

  group('DoctorDetailsFilters Widget', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DoctorDetailsFilters(),
          ),
        ),
      );

      expect(find.text('From Date'), findsOneWidget);
      expect(find.text('Till Date'), findsOneWidget);
      expect(find.text('Get Data'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('calls cubit.updateFromDate on From Date callbacks', (tester) async {
      cubit.setFromDate(DateTime(2025, 10, 26));
      verify(() => cubit.setFromDate(DateTime(2025, 10, 26))).called(1);

      cubit.setFromDate(null);
      verify(() => cubit.setFromDate(null)).called(1);
    });

    testWidgets('calls cubit.updateTillDate on Till Date callbacks', (tester) async {
      cubit.setTillDate(DateTime(2025, 10, 27));
      verify(() => cubit.setTillDate(DateTime(2025, 10, 27))).called(1);

      cubit.setTillDate(null);
      verify(() => cubit.setTillDate(null)).called(1);
    });

    testWidgets('calls cubit.fetchDoctorsId when Get Data button is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DoctorDetailsFilters(),
          ),
        ),
      );

      await tester.tap(find.text('Get Data'));
      verify(() => cubit.fetchDoctorDetails()).called(1);
    });

    testWidgets('calls cubit.applySearchFilter on text input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DoctorDetailsFilters(),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Dr. Smith');
      verify(() => cubit.applySearchFilter()).called(1);
    });
  });

  group('DoctorDetailsState', () {
    test('initial state has correct default values', () {
      final initial = DoctorDetailsState.initial();
      expect(initial.doctorDetails, []);
      expect(initial.filteredDoctors, []);
      expect(initial.fromDate, null);
      expect(initial.tillDate, null);
      expect(initial.clearError, false);
      expect(initial.errorMessage, null);
    });

    test('copyWith updates provided fields', () {
      final newDoc = MockDocument();
      final newState = state.copyWith(
        doctorDetails: [newDoc],
        filteredDoctors: [newDoc],
        fromDate: DateTime(2025, 11, 1),
        tillDate: DateTime(2025, 11, 2),
        clearError: true,
        errorMessage: 'Error message',
      );

      expect(newState.doctorDetails, [newDoc]);
      expect(newState.filteredDoctors, [newDoc]);
      expect(newState.fromDate, DateTime(2025, 11, 1));
      expect(newState.tillDate, DateTime(2025, 11, 2));
      expect(newState.clearError, true);
      expect(newState.errorMessage, 'Error message');
    });

    test('props contains all fields for Equatable', () {
      expect(
        state.props,
        [
          state.doctorDetails,
          state.filteredDoctors,
          state.fromDate,
          state.tillDate,
          state.clearError,
          state.errorMessage,
        ],
      );
    });
  });
}
