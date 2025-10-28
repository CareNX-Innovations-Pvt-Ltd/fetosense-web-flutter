import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_edit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrganizationCubit extends Mock implements OrganizationCubit {}

void main() {
  late MockOrganizationCubit mockCubit;

  setUp(() {
    mockCubit = MockOrganizationCubit();

    // Default state
    when(() => mockCubit.state).thenReturn(
      OrganizationState(
        selectedState: 'Maharashtra',
        selectedCity: 'Mumbai',
        selectedType: 'demo',
        selectedDesignation: 'Admin',
      ),
    );

    // Mock methods
    when(() => mockCubit.initializeOrganizationFields(any())).thenReturn(null);
    when(() => mockCubit.updateChanges(any())).thenAnswer((_) async => null);
    when(() => mockCubit.setSelectedState(any())).thenReturn(null);
    when(() => mockCubit.setSelectedCity(any())).thenReturn(null);
  });

  testWidgets('OrganizationEditPopup interaction test', (WidgetTester tester) async {
    bool closed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OrganizationCubit>.value(
          value: mockCubit,
          child: OrganizationEditPopup(
            data: {
              'organizationName': 'Test Org',
              'contactPerson': 'John Doe',
              'mobileNo': '1234567890',
              'email': 'test@org.com',
              'addressLine': '123 Street',
              'status': 'demo',
              'designation': 'Admin',
              'state': 'Maharashtra',
              'city': 'Mumbai',
            },
            documentId: 'abc123',
            onClose: () => closed = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial fields
    expect(find.text('Test Org'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);

    // Interact with text fields
    await tester.enterText(find.byType(TextField).first, 'Updated Org');
    await tester.pump();

    // Change state dropdown
    await tester.tap(find.text('Maharashtra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maharashtra').last);
    await tester.pumpAndSettle();

    // Trigger save/update button
    final saveButton = find.text('Save'); // adjust to actual button text
    if (saveButton.evaluate().isNotEmpty) {
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
    }

    // Trigger close callback
    final closeButton = find.byIcon(Icons.close);
    if (closeButton.evaluate().isNotEmpty) {
      await tester.tap(closeButton);
      await tester.pumpAndSettle();
      expect(closed, true);
    }

    // Trigger cubit method directly
    verify(() => mockCubit.updateChanges('abc123')).called(1);
  });
}
