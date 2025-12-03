import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/screens/device_details/widgets/device_details_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:intl/intl.dart';

class MockDeviceDetailsCubit extends Mock implements DeviceDetailsCubit {}

void main() {
  late MockDeviceDetailsCubit mockCubit;
  late DeviceDetailsState testState;

  setUp(() {
    mockCubit = MockDeviceDetailsCubit();
    testState =  DeviceDetailsState(
      allDevices: [],
      fromDate: DateTime(2023, 1, 1),
      tillDate: DateTime(2023, 12, 31),
      isLoading: false,
      errorMessage: '',
      searchQuery: '', filteredDevices: [], noOfTests: [],
    ).copyWith(
      fromDate: DateTime(2024, 1, 1),
      tillDate: DateTime(2024, 12, 31),
    );
  });

  Widget buildTestWidget() {
    return const MaterialApp(
      home: Scaffold(
        body: DeviceDetailsFilters(

        ),
      ),
    );
  }

  testWidgets('renders all UI components', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('From Date'), findsOneWidget);
    expect(find.text('Till Date'), findsOneWidget);
    expect(find.text('Get Data'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('Get Data button calls fetchDeviceData', (tester) async {
    when(() => mockCubit.fetchDeviceData()).thenReturn(Future.value());

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.text('Get Data'));
    await tester.pump();

    verify(() => mockCubit.fetchDeviceData()).called(1);
  });

  testWidgets('Search input triggers applySearch', (tester) async {
    when(() => mockCubit.applySearch(any())).thenReturn(null);

    await tester.pumpWidget(buildTestWidget());

    await tester.enterText(find.byType(TextField), 'kit123');
    await tester.pump();

    verify(() => mockCubit.applySearch('kit123')).called(1);
  });

  testWidgets('date controllers display correct formatted dates', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    final fromDateTextField = tester.widget<TextField>(
      find.widgetWithText(TextField, DateFormat('dd-MM-yyyy').format(testState.fromDate!)),
    );

    final tillDateTextField = tester.widget<TextField>(
      find.widgetWithText(TextField, DateFormat('dd-MM-yyyy').format(testState.tillDate!)),
    );

    expect(fromDateTextField.controller?.text, isNotEmpty);
    expect(tillDateTextField.controller?.text, isNotEmpty);
  });

  // Optional: simulate clear date (by calling the callbacks directly in customDatePicker)
}
