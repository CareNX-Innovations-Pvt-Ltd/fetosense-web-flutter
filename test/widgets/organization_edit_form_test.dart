import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_edit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockOrganizationCubit extends Mock implements OrganizationCubit {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockOrganizationState extends Mock implements OrganizationState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

mixin MockFormState implements Mock, FormState {}

class MockCallback extends Mock {
  void call();
}

void main() {
  late MockOrganizationCubit mockCubit;
  late MockOrganizationState mockState;
  late GlobalKey<FormState> formKey;
  late MockCallback mockOnClose;

  setUp(() {
    mockCubit = MockOrganizationCubit();
    mockState = MockOrganizationState();
    formKey = GlobalKey<FormState>();
    mockOnClose = MockCallback();

    when(() => mockCubit.formKey).thenReturn(formKey);
    when(() => mockCubit.nameController)
        .thenReturn(TextEditingController(text: 'name'));
    when(() => mockCubit.contactPersonController)
        .thenReturn(TextEditingController(text: 'contact'));
    when(() => mockCubit.mobileController)
        .thenReturn(TextEditingController(text: '9999999999'));
    when(() => mockCubit.emailController)
        .thenReturn(TextEditingController(text: 'test@test.com'));
    when(() => mockCubit.addressController)
        .thenReturn(TextEditingController(text: 'address'));

    when(() => mockState.selectedType).thenReturn('demo');
    when(() => mockState.selectedDesignation).thenReturn('Admin');
    when(() => mockState.selectedState).thenReturn('Gujarat');
    when(() => mockState.selectedCity).thenReturn('Ahmedabad');

    registerFallbackValue('');
  });

  Widget _wrapWithMaterial(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('OrganizationEditForm', () {
    testWidgets('renders all static texts and widgets', (tester) async {
      await tester.pumpWidget(_wrapWithMaterial(
        OrganizationEditForm(
          cubit: mockCubit,
          state: mockState,
          documentId: 'doc1',
          onClose: mockOnClose,
          stateList: ['Gujarat', 'Maharashtra'],
        ),
      ));

      expect(find.text('Organization Details'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('taps cancel button triggers onClose', (tester) async {
      await tester.pumpWidget(_wrapWithMaterial(
        OrganizationEditForm(
          cubit: mockCubit,
          state: mockState,
          documentId: 'doc1',
          onClose: mockOnClose,
          stateList: ['Gujarat'],
        ),
      ));

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verify(() => mockOnClose()).called(1);
    });

    testWidgets('taps update button with valid form calls updateChanges',
            (tester) async {
          when(() => mockCubit.updateChanges(any())).thenAnswer((_) async {});
          when(() => mockCubit.formKey.currentState!.validate()).thenReturn(true);

          await tester.pumpWidget(_wrapWithMaterial(
            Builder(builder: (context) {
              return OrganizationEditForm(
                cubit: mockCubit,
                state: mockState,
                documentId: 'doc123',
                onClose: mockOnClose,
                stateList: ['Gujarat'],
              );
            }),
          ));

          await tester.tap(find.text('Update'));
          await tester.pumpAndSettle();

          verify(() => mockCubit.updateChanges('doc123')).called(1);
          expect(find.byType(SnackBar), findsOneWidget);
        });

    testWidgets('taps update button with invalid form does nothing',
            (tester) async {
          when(() => mockCubit.formKey.currentState!.validate()).thenReturn(false);

          await tester.pumpWidget(_wrapWithMaterial(
            OrganizationEditForm(
              cubit: mockCubit,
              state: mockState,
              documentId: 'doc1',
              onClose: mockOnClose,
              stateList: ['Gujarat'],
            ),
          ));

          await tester.tap(find.text('Update'));
          await tester.pumpAndSettle();

          verifyNever(() => mockCubit.updateChanges(any()));
          expect(find.byType(SnackBar), findsNothing);
        });

    testWidgets('buildStateAndCityRow builds correctly when state exists',
            (tester) async {
          final indiaStatesWithCities = {
            'Gujarat': ['Ahmedabad', 'Surat'],
          };

          await tester.pumpWidget(_wrapWithMaterial(
            buildStateAndCityRow(
              mockCubit,
              mockState,
              ['Gujarat'],
              indiaStatesWithCities,
            ),
          ));

          expect(find.text('Select city'), findsOneWidget);
        });

    testWidgets('buildStateAndCityRow builds correctly when no state selected',
            (tester) async {
          when(() => mockState.selectedState).thenReturn(null);

          await tester.pumpWidget(_wrapWithMaterial(
            buildStateAndCityRow(
              mockCubit,
              mockState,
              ['Gujarat'],
              {},
            ),
          ));

          expect(find.text('Select city'), findsOneWidget);
        });

    testWidgets(
        'buildAddressField, buildMobileAndEmailRow, buildNameAndTypeRow, and buildContactAndDesignationRow render correctly',
            (tester) async {
          await tester.pumpWidget(_wrapWithMaterial(buildAddressField(mockCubit)));
          expect(find.text('Enter address'), findsOneWidget);

          await tester
              .pumpWidget(_wrapWithMaterial(buildMobileAndEmailRow(mockCubit)));
          expect(find.text('Enter mobile'), findsOneWidget);

          await tester.pumpWidget(
              _wrapWithMaterial(buildNameAndTypeRow(mockCubit, mockState)));
          expect(find.text('Organization Name'), findsOneWidget);

          await tester.pumpWidget(_wrapWithMaterial(
              buildContactAndDesignationRow(mockCubit, mockState)));
          expect(find.text('Contact Person'), findsOneWidget);
        });

    testWidgets('buildActionButtons Update and Cancel exist', (tester) async {
      await tester.pumpWidget(_wrapWithMaterial(buildActionButtons(
          mockCubit, tester.element(find.byType(MaterialApp)), 'id', mockOnClose)));
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
