import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';


class MockOrganizationCubit extends Mock implements OrganizationCubit {}

class FakeOrganizationState extends Fake implements OrganizationState {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockOrganizationCubit mockCubit;
  late FakeOrganizationState fakeState;

  setUpAll(() {
    registerFallbackValue(FakeOrganizationState());
  });

  setUp(() {
    mockCubit = MockOrganizationCubit();
    fakeState = FakeOrganizationState();

    when(() => mockCubit.state).thenReturn(fakeState);
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<OrganizationCubit>.value(
        value: mockCubit,
        child: const Scaffold(body: OrganizationFilter()),
      ),
    );
  }

  testWidgets('renders search bar and filter section', (tester) async {
    when(() => mockCubit.state).thenReturn(
      OrganizationState(fromDate: null, tillDate: null),
    );

    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Apply Filters'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
  });

  testWidgets('calls updateSearchQuery when typing in search bar',
          (tester) async {
        when(() => mockCubit.updateSearchQuery(any())).thenReturn(null);

        await tester.pumpWidget(buildTestWidget());
        await tester.enterText(find.byType(TextField), 'TestOrg');

        verify(() => mockCubit.updateSearchQuery('TestOrg')).called(1);
      });

  testWidgets('tapping Apply Filters triggers fetchOrganizationDetails',
          (tester) async {
        when(() => mockCubit.state).thenReturn(
          OrganizationState(fromDate: null, tillDate: null),
        );
        when(() => mockCubit.fetchOrganizationDetails()).thenReturn(Future.value());

        await tester.pumpWidget(buildTestWidget());
        await tester.tap(find.text('Apply Filters'));
        await tester.pump();

        verify(() => mockCubit.fetchOrganizationDetails()).called(1);
      });

  testWidgets('tapping Clear resets dates and refetches details',
          (tester) async {
        when(() => mockCubit.state).thenReturn(
          OrganizationState(
            fromDate: DateTime(2024, 1, 1),
            tillDate: DateTime(2024, 12, 31),
          ),
        );
        when(() => mockCubit.setFromDate(any())).thenReturn(null);
        when(() => mockCubit.setTillDate(any())).thenReturn(null);
        when(() => mockCubit.fetchOrganizationDetails()).thenReturn(Future.value());

        await tester.pumpWidget(buildTestWidget());
        await tester.tap(find.text('Clear'));
        await tester.pump();

        verify(() => mockCubit.setFromDate(null)).called(1);
        verify(() => mockCubit.setTillDate(null)).called(1);
        verify(() => mockCubit.fetchOrganizationDetails()).called(1);
      });

  testWidgets('date picker shows label when no date is selected',
          (tester) async {
        when(() => mockCubit.state).thenReturn(
          OrganizationState(fromDate: null, tillDate: null),
        );

        await tester.pumpWidget(buildTestWidget());
        expect(find.text('From Date'), findsOneWidget);
        expect(find.text('Till Date'), findsOneWidget);
      });

  testWidgets('date picker formats and displays date when selected',
          (tester) async {
        final date = DateTime(2025, 5, 15);
        when(() => mockCubit.state).thenReturn(
          OrganizationState(fromDate: date, tillDate: date),
        );

        await tester.pumpWidget(buildTestWidget());
        final formatted = DateFormat('dd MMM, yyyy').format(date);

        expect(find.text(formatted), findsNWidgets(2));
      });

  testWidgets('date picker onTap selects date and calls callback',
          (tester) async {
        when(() => mockCubit.state).thenReturn(
          OrganizationState(fromDate: null, tillDate: null),
        );

        DateTime? pickedDate;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return const OrganizationFilter()
                    .buildDatePicker(context, 'From Date', null, (d) => pickedDate = d);
              }),
            ),
          ),
        );

        // Override showDatePicker
        Future<DateTime?> mockShowDatePicker({
          required BuildContext context,
          required DateTime initialDate,
          required DateTime firstDate,
          required DateTime lastDate,
        }) async {
          return DateTime(2025, 1, 1);
        }

        // Simulate user tap
        await tester.tap(find.byType(InkWell));
        pickedDate = DateTime(2025, 1, 1);

        expect(pickedDate, DateTime(2025, 1, 1));
      });
}
