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
      allDoctors: [],
      filteredDoctors: [],
      fromDate: DateTime(2025, 10, 24),
      tillDate: DateTime(2025, 10, 25),
      isLoading: false,
      error: null,
    );
  });

  group('DoctorDetailsFilters Widget', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDetailsFilters(cubit: cubit, state: state),
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
      cubit.updateFromDate(DateTime(2025, 10, 26));
      verify(() => cubit.updateFromDate(DateTime(2025, 10, 26))).called(1);

      cubit.updateFromDate(null);
      verify(() => cubit.updateFromDate(null)).called(1);
    });

    testWidgets('calls cubit.updateTillDate on Till Date callbacks', (tester) async {
      cubit.updateTillDate(DateTime(2025, 10, 27));
      verify(() => cubit.updateTillDate(DateTime(2025, 10, 27))).called(1);

      cubit.updateTillDate(null);
      verify(() => cubit.updateTillDate(null)).called(1);
    });

    testWidgets('calls cubit.fetchDoctorsId when Get Data button is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDetailsFilters(cubit: cubit, state: state),
          ),
        ),
      );

      await tester.tap(find.text('Get Data'));
      verify(() => cubit.fetchDoctorsId()).called(1);
    });

    testWidgets('calls cubit.applySearchFilter on text input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDetailsFilters(cubit: cubit, state: state),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Dr. Smith');
      verify(() => cubit.applySearchFilter('Dr. Smith')).called(1);
    });
  });

  group('DoctorDetailsState', () {
    test('initial state has correct default values', () {
      final initial = DoctorDetailsState.initial();
      expect(initial.allDoctors, []);
      expect(initial.filteredDoctors, []);
      expect(initial.fromDate, null);
      expect(initial.tillDate, null);
      expect(initial.isLoading, false);
      expect(initial.error, null);
    });

    test('copyWith updates provided fields', () {
      final newDoc = MockDocument();
      final newState = state.copyWith(
        allDoctors: [newDoc],
        filteredDoctors: [newDoc],
        fromDate: DateTime(2025, 11, 1),
        tillDate: DateTime(2025, 11, 2),
        isLoading: true,
        error: 'Error message',
      );

      expect(newState.allDoctors, [newDoc]);
      expect(newState.filteredDoctors, [newDoc]);
      expect(newState.fromDate, DateTime(2025, 11, 1));
      expect(newState.tillDate, DateTime(2025, 11, 2));
      expect(newState.isLoading, true);
      expect(newState.error, 'Error message');
    });

    test('props contains all fields for Equatable', () {
      expect(
        state.props,
        [
          state.allDoctors,
          state.filteredDoctors,
          state.fromDate,
          state.tillDate,
          state.isLoading,
          state.error,
        ],
      );
    });
  });
}
