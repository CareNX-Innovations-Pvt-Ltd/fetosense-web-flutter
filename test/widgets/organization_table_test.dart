import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_edit_form.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_edit_popup.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_filters.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_info_panel.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockOrganizationCubit extends Mock implements OrganizationCubit {}

class FakeOrganizationState extends Fake implements OrganizationState {}

class OrganizationDetailsModel {
  final List<OrganizationData> organizations;
  OrganizationDetailsModel({required this.organizations});
}

class OrganizationData {
  final Map<String, dynamic> data;
  OrganizationData({required this.data});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockOrganizationCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(FakeOrganizationState());
  });

  setUp(() {
    mockCubit = MockOrganizationCubit();
    when(() => mockCubit.downloadExcel()).thenReturn(Future.value());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestWidget(Widget child, {OrganizationState? state}) {
    when(() => mockCubit.state).thenReturn(state ?? OrganizationState());

    return MaterialApp(
      home: BlocProvider<OrganizationCubit>.value(
        value: mockCubit,
        child: Scaffold(body: child),
      ),
    );
  }

  // -------------------- Header Tests --------------------
  group('OrganizationHeader', () {
    testWidgets('renders correctly and triggers download', (tester) async {
      expect(find.text('Organization Details'), findsOneWidget);
      expect(find.byIcon(Icons.apartment), findsOneWidget);
      expect(find.byIcon(Icons.download), findsOneWidget);

      await tester.tap(find.byIcon(Icons.download));
      verify(() => mockCubit.downloadExcel()).called(1);
    });
  });

  // -------------------- Filter Tests --------------------
  group('OrganizationFilter', () {
    testWidgets('renders search bar and filters', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OrganizationFilter()));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'test query');
      verify(() => mockCubit.updateSearchQuery('test query')).called(1);

      await tester.tap(find.byType(ElevatedButton));
      verify(() => mockCubit.fetchOrganizationDetails()).called(1);

      await tester.tap(find.byType(TextButton));
      verify(() => mockCubit.setFromDate(null)).called(1);
      verify(() => mockCubit.setTillDate(null)).called(1);
      verify(() => mockCubit.fetchOrganizationDetails()).called(1);
    });
  });

  // -------------------- InfoPanel Tests --------------------
  group('OrganizationInfoPanel', () {
    testWidgets('renders default info when data empty', (tester) async {
      final data = <String, dynamic>{};
      when(() => mockCubit.addressController)
          .thenReturn(TextEditingController(text: ''));

      await tester.pumpWidget(buildTestWidget(
        OrganizationInfoPanel(data: data, cubit: mockCubit),
      ));

      expect(find.text('Organization Name'), findsOneWidget);
      expect(find.byIcon(Icons.business), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2));
      expect(find.text('NA'), findsOneWidget);
    });

    testWidgets('renders data from model', (tester) async {
      final data = {
        'organizationName': 'Org1',
        'mobile': '9999999999',
        'mother': 5,
        'test': 10,
      };
      when(() => mockCubit.addressController)
          .thenReturn(TextEditingController(text: '123 Street'));

      await tester.pumpWidget(buildTestWidget(
        OrganizationInfoPanel(data: data, cubit: mockCubit),
      ));

      expect(find.text('Org1'), findsOneWidget);
      expect(find.text('9999999999'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('123 Street'), findsOneWidget);
    });
  });

  // -------------------- DataTable Tests --------------------
  group('OrganizationDataTableWidget', () {
    final sampleData = {
      'organizationName': 'Org1',
      'deviceName': 'DeviceX',
      'doctors': 2,
      'mother': 5,
      'test': 10,
      'mobileNo': '1234567890',
      'status': 'Active',
      'createdOn': DateTime.now().toIso8601String(),
      'addressLine': 'Street 123',
      'city': 'CityX',
      'state': 'StateY',
      'country': 'CountryZ',
      'email': 'test@org.com',
      'organizationId': 'org123',
    };

    final orgDetail = OrganizationDetailsModel(
      organizations: [OrganizationData(data: sampleData)],
    );

    testWidgets('renders loading state', (tester) async {
      final state = OrganizationState(status: OrganizationStatus.loading);
      await tester.pumpWidget(buildTestWidget(const OrganizationDataTableWidget(), state: state));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state', (tester) async {
      final state = OrganizationState(status: OrganizationStatus.error, errorMessage: 'Failed');
      await tester.pumpWidget(buildTestWidget(const OrganizationDataTableWidget(), state: state));
      expect(find.text('Error: Failed'), findsOneWidget);
    });

    testWidgets('renders empty loaded state', (tester) async {
      final state = OrganizationState(status: OrganizationStatus.loaded, filteredOrganizationDetails: []);
      await tester.pumpWidget(buildTestWidget(const OrganizationDataTableWidget(), state: state));
      expect(find.text('No organizations found'), findsOneWidget);
    });

    testWidgets('renders DataTable with rows and Edit button', (tester) async {
      final state = OrganizationState(status: OrganizationStatus.loaded, filteredOrganizationDetails: []);
      await tester.pumpWidget(buildTestWidget(const OrganizationDataTableWidget(), state: state));
      await tester.pumpAndSettle();

      expect(find.text('Org1'), findsOneWidget);
      expect(find.text('DeviceX'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.byType(OrganizationEditPopup), findsOneWidget);
    });
  });

  // -------------------- OrganizationEditPopup & EditForm --------------------
  group('OrganizationEditPopup', () {
    testWidgets('renders OrganizationEditForm inside popup', (tester) async {
      final data = {
        'organizationName': 'Org1',
        'organizationId': 'org123',
      };

      await tester.pumpWidget(buildTestWidget(
        OrganizationEditPopup(
          data: data,
          documentId: 'org123',
          onClose: () {},
        ),
      ));

      // Should trigger initState call to cubit
      verify(() => mockCubit.initializeOrganizationFields(data)).called(1);
      await tester.pumpAndSettle();

      expect(find.byType(OrganizationEditForm), findsOneWidget);
    });
  });

  group('OrganizationEditForm', () {
    testWidgets('Update button triggers cubit updateChanges and shows snackbar', (tester) async {
      final cubit = mockCubit;
      when(() => cubit.formKey).thenReturn(GlobalKey<FormState>());
      when(() => cubit.formKey.currentState?.validate()).thenReturn(true);
      when(() => cubit.updateChanges('doc123')).thenReturn(Future.value());

      await tester.pumpWidget(buildTestWidget(
        OrganizationEditForm(
          cubit: cubit,
          state: OrganizationState(),
          documentId: 'doc123',
          onClose: () {},
          stateList: [],
        ),
      ));

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      verify(() => cubit.updateChanges('doc123')).called(1);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Cancel button triggers onClose', (tester) async {
      bool closed = false;
      await tester.pumpWidget(buildTestWidget(
        OrganizationEditForm(
          cubit: mockCubit,
          state: OrganizationState(),
          documentId: 'doc123',
          onClose: () => closed = true,
          stateList: [],
        ),
      ));

      await tester.tap(find.text('Cancel'));
      expect(closed, true);
    });
  });
}
