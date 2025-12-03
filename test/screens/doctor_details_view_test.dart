import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

class MockDoctorDetailsCubit extends MockCubit<DoctorDetailsState>
    implements DoctorDetailsCubit {}

void main() {
  late MockDoctorDetailsCubit mockCubit;

  setUp(() async {
    mockCubit = MockDoctorDetailsCubit();

    // Default state
    when(() => mockCubit.state).thenReturn(
      const DoctorDetailsState(
        filteredDoctors: [],
        fromDate: null,
        tillDate: null,
        doctorDetails: [],
        searchQuery: '',
        status: DoctorStatus.initial,
        errorMessage: '',
        clearError: false,
        clearFromDate: false,
        clearTillDate: false,
      )
          as DoctorDetailsState Function(),
    );

    // Mock fetchDoctorsId so it does nothing
    when(() => mockCubit.fetchDoctorDetails()).thenAnswer(await Future.value());
  });

  testWidgets('DoctorDetailsView renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DoctorDetailsCubit>.value(
          value: mockCubit,
          child: const DoctorDetailsView(),
        ),
      ),
    );

    // Should call fetchDoctorsId once on build
    verify(() => mockCubit.fetchDoctorDetails()).called(1);

    // Verify loading indicator is not shown initially
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify headers and table exist
    expect(find.text('Doctor Details'), findsOneWidget);

    // Trigger loading state
    const loadingState = DoctorDetailsState(
      filteredDoctors: [],
      fromDate: null,
      tillDate: null,
      doctorDetails: [],
      searchQuery: '',
      status: DoctorStatus.initial,
      errorMessage: '',
      clearError: false,
      clearFromDate: false,
      clearTillDate: false,
    );
    mockCubit.emit(loadingState);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Trigger error state
    const errorState = DoctorDetailsState(
      filteredDoctors: [],
      fromDate: null,
      tillDate: null,
      doctorDetails: [],
      searchQuery: '',
      status: DoctorStatus.initial,
      errorMessage: '',
      clearError: false,
      clearFromDate: false,
      clearTillDate: false,
    );
    mockCubit.emit(errorState);
    await tester.pump();

    expect(find.text('Failed to load'), findsOneWidget);
  });
}
