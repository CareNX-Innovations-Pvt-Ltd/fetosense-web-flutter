import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/edit_popup_widgets/stat_card.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/edit_popup_widgets/tile_card.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_info_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockOrganizationCubit extends Mock implements OrganizationCubit {}

void main() {
  late MockOrganizationCubit mockCubit;

  setUp(() {
    mockCubit = MockOrganizationCubit();

    when(() => mockCubit.addressController).thenReturn(
      TextEditingController(text: ''),
    );
  });

  Widget buildTestWidget(Map<String, dynamic> data) {
    return MaterialApp(
      home: Scaffold(
        body: OrganizationInfoPanel(
          data: data,
          cubit: mockCubit,
        ),
      ),
    );
  }

  testWidgets('renders default organization info when data is empty',
          (tester) async {
        final data = <String, dynamic>{};

        await tester.pumpWidget(buildTestWidget(data));

        expect(find.byIcon(Icons.business), findsOneWidget);
        expect(find.text('Organization Name'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(2)); // StatCards default
        expect(find.text('NA'), findsOneWidget); // TileCard default
      });

  testWidgets('renders organization info with provided data', (tester) async {
    when(() => mockCubit.addressController)
        .thenReturn(TextEditingController(text: '123 Street'));

    final data = {
      'organizationName': 'TestOrg',
      'mobile': '9999999999',
      'mother': 5,
      'test': 10,
    };

    await tester.pumpWidget(buildTestWidget(data));

    expect(find.text('TestOrg'), findsOneWidget);
    expect(find.text('9999999999'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('123 Street'), findsOneWidget);
  });

  testWidgets('StatCard and TileCard widgets exist', (tester) async {
    final data = {
      'mother': 3,
      'test': 7,
    };

    await tester.pumpWidget(buildTestWidget(data));

    expect(find.byType(StatCard), findsNWidgets(2));
    expect(find.byType(TileCard), findsOneWidget);
  });

  testWidgets('Divider and spacing widgets exist', (tester) async {
    final data = <String, dynamic>{};

    await tester.pumpWidget(buildTestWidget(data));

    expect(find.byType(Divider), findsOneWidget);
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('addressController empty shows NA in TileCard', (tester) async {
    when(() => mockCubit.addressController)
        .thenReturn(TextEditingController(text: ''));

    final data = <String, dynamic>{};

    await tester.pumpWidget(buildTestWidget(data));

    expect(find.text('NA'), findsOneWidget);
  });

  testWidgets('addressController text shows in TileCard', (tester) async {
    when(() => mockCubit.addressController)
        .thenReturn(TextEditingController(text: '456 Avenue'));

    final data = <String, dynamic>{};

    await tester.pumpWidget(buildTestWidget(data));

    expect(find.text('456 Avenue'), findsOneWidget);
  });
}