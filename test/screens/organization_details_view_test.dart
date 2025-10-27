import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_view.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_filters.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mock Cubit
class MockOrganizationCubit extends Mock implements OrganizationCubit {}
class FakeOrganizationState extends Fake implements OrganizationState {}

void main() {
  late MockOrganizationCubit cubit;

  setUp(() {
    cubit = MockOrganizationCubit();
    registerFallbackValue(FakeOrganizationState());
    when(() => cubit.state).thenReturn(OrganizationState());
  });

  testWidgets('OrganizationDetailsView renders correctly and download button works', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OrganizationCubit>.value(
          value: cubit,
          child: const OrganizationDetailsView(),
        ),
      ),
    );

    // Check for header icon and text
    expect(find.byIcon(Icons.apartment), findsOneWidget);
    expect(find.text('Organization Details'), findsOneWidget);

    // Check for download button and tap
    final downloadButton = find.byIcon(Icons.download);
    expect(downloadButton, findsOneWidget);

    await tester.tap(downloadButton);
    await tester.pump();

    verify(() => cubit.downloadExcel()).called(1);

    // Check that OrganizationFilter widget exists
    expect(find.byType(OrganizationFilter), findsOneWidget);

    // Check that OrganizationDataTableWidget exists
    expect(find.byType(OrganizationDataTableWidget), findsOneWidget);
  });
}
