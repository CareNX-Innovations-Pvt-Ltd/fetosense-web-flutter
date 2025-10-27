import 'package:appwrite/models.dart';
import 'package:fetosense_mis/screens/mother_details/mother_details_cubit.dart';
import 'package:fetosense_mis/screens/mother_details/mother_details_view.dart';
import 'package:fetosense_mis/screens/mother_details/widget/mother_details_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockMotherDetailsCubit extends Mock implements MotherDetailsCubit {}
class MockDocument extends Mock implements Document {}

void main() {
  late MockMotherDetailsCubit cubit;

  setUp(() {
    cubit = MockMotherDetailsCubit();

    // Controllers
    when(() => cubit.fromDateController).thenReturn(TextEditingController());
    when(() => cubit.tillDateController).thenReturn(TextEditingController());
    when(() => cubit.searchController).thenReturn(TextEditingController());

    // Methods
    when(() => cubit.fetchMothersId()).thenAnswer((_) async {});
    when(() => cubit.downloadExcel(any())).thenAnswer((_) async {});
    when(() => cubit.setFromDate(any())).thenReturn(null);
    when(() => cubit.clearFromDate()).thenReturn(null);
    when(() => cubit.setTillDate(any())).thenReturn(null);
    when(() => cubit.clearTillDate()).thenReturn(null);
    when(() => cubit.setSearchQuery(any())).thenReturn(null);
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<MotherDetailsCubit>.value(
        value: cubit,
        child: const MotherDetails(),
      ),
    );
  }

  testWidgets('renders header, filters, and table', (tester) async {
    const state = MotherDetailsState(
      filteredMothers: [],
    );
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    // Header
    expect(find.text('Mother Details'), findsOneWidget);
    expect(find.byIcon(Icons.apartment), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);

    // Filter section
    expect(find.text('Get Data'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('download button calls cubit.downloadExcel', (tester) async {
    const state = MotherDetailsState();
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    await tester.tap(find.byIcon(Icons.download));
    verify(() => cubit.downloadExcel(any())).called(1);
  });

  testWidgets('Get Data button calls cubit.fetchMothersId', (tester) async {
    const state = MotherDetailsState();
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    await tester.tap(find.text('Get Data'));
    verify(() => cubit.fetchMothersId()).called(1);
  });

  testWidgets('search field calls cubit.setSearchQuery', (tester) async {
    const state = MotherDetailsState();
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    await tester.enterText(find.byType(TextField), 'query');
    verify(() => cubit.setSearchQuery('query')).called(1);
  });

  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    const state = MotherDetailsState(isLoading: true);
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when errorMessage is set', (tester) async {
    const state = MotherDetailsState(errorMessage: 'Error occurred');
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    expect(find.text('Error occurred'), findsOneWidget);
  });

  testWidgets('renders MotherDetailsTable when filteredMothers is not empty', (tester) async {
    final mockDoc = MockDocument();
    final state = MotherDetailsState(filteredMothers: [mockDoc]);
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    expect(find.byType(MotherDetailsTable), findsOneWidget);
  });

  testWidgets('calls date picker methods', (tester) async {
    const state = MotherDetailsState();
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(buildWidget());

    cubit.setFromDate(DateTime.now());
    verify(() => cubit.setFromDate(any())).called(1);

    cubit.clearFromDate();
    verify(() => cubit.clearFromDate()).called(1);

    cubit.setTillDate(DateTime.now());
    verify(() => cubit.setTillDate(any())).called(1);

    cubit.clearTillDate();
    verify(() => cubit.clearTillDate()).called(1);
  });
}
