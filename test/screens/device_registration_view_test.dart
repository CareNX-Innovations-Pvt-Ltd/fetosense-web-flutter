import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/screens/device_registration/device_registration_cubit.dart';
import 'package:fetosense_mis/screens/device_registration/device_registration_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MockDeviceRegistrationCubit extends Mock
    implements DeviceRegistrationCubit {}

void main() {
  late MockDeviceRegistrationCubit mockCubit;

  setUp(() {
    mockCubit = MockDeviceRegistrationCubit();

    when(() => mockCubit.state).thenReturn(const DeviceRegistrationState());
    whenListen(mockCubit, Stream.value(const DeviceRegistrationState()));
  });

  Widget wrapWithBloc(Widget child) {
    return MaterialApp(
      home: BlocProvider<DeviceRegistrationCubit>.value(
        value: mockCubit,
        child: child,
      ),
    );
  }

  testWidgets('renders initial DeviceRegistrationView', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    expect(find.text('Device Registration'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('validates required fields on save', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.textContaining('is required'), findsWidgets);
  });

  testWidgets('text field input updates cubit', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    final deviceNameField =
    find.widgetWithText(TextFormField, 'Enter Device Name');

    await tester.enterText(deviceNameField, 'Device001');
    verify(() => mockCubit.updateDeviceName('Device001')).called(1);
  });

  testWidgets('organization dropdown updates cubit', (tester) async {
    when(() => mockCubit.state).thenReturn(const DeviceRegistrationState(
      organizationList: [
        {'id': 'org1', 'name': 'Org One'}
      ],
    ));

    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    await tester.tap(find.text('Select Organization').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Org One').last);
    await tester.pump();

    verify(() =>
        mockCubit.updateSelectedOrganization('Org One', 'org1')).called(1);
  });

  testWidgets('product type dropdown updates cubit', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    await tester.tap(find.text('Select Product Type'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('main').last);
    await tester.pump();
    verify(() => mockCubit.updateSelectedProductType('main')).called(1);
  });

  testWidgets('shows success snackbar and resets form', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(const DeviceRegistrationState(isSuccess: true));

    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    await tester.pump();
    expect(find.text('Device registered successfully!'), findsOneWidget);
    verify(() => mockCubit.resetSuccess()).called(1);
  });

  testWidgets('shows error snackbar and clears error', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(const DeviceRegistrationState(errorMessage: 'Error occurred'));

    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    await tester.pump();
    expect(find.text('Error occurred'), findsOneWidget);
    verify(() => mockCubit.clearError()).called(1);
  });

  testWidgets('Save button disabled when submitting', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(const DeviceRegistrationState(isSubmitting: true));

    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));
    final saveButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(saveButton.onPressed, null);
  });

  testWidgets('optional fields do not trigger validation errors', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const DeviceRegistrationView()));

    final tabletField =
    find.widgetWithText(TextFormField, 'Enter Tablet Serial Number');
    final tocoField = find.widgetWithText(TextFormField, 'Enter your Toco Id');

    await tester.enterText(tabletField, '');
    await tester.enterText(tocoField, '');
    await tester.tap(find.text('Save'));
    await tester.pump();

    // No error should appear for optional fields
    expect(find.textContaining('Tablet Serial Number is required'), findsNothing);
    expect(find.textContaining('Toco Id is required'), findsNothing);
  });
}
