import 'package:fetosense_mis/screens/device_registration/device_registration_cubit.dart';
import 'package:fetosense_mis/screens/device_registration/device_registration_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MockDeviceRegistrationCubit extends Mock implements DeviceRegistrationCubit {}

void main() {
  late DeviceRegistrationCubit mockCubit;

  setUp(() {
    mockCubit = MockDeviceRegistrationCubit();

    // Default fallback values
    when(() => mockCubit.state).thenReturn(
      const DeviceRegistrationState(
        organizationList: [{'id': 'org1', 'name': 'Org One'}],
        productTypeList: ['Type A', 'Type B'],
      ),
    );
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DeviceRegistrationCubit>.value(
          value: mockCubit,
          child: const Scaffold(body: DeviceRegistrationView()),
        ),
      ),
    );
  }

  testWidgets('renders all input fields and dropdowns', (tester) async {
    await pumpWidget(tester);

    expect(find.text('Device Registration'), findsOneWidget);
    expect(find.text('Organization'), findsOneWidget);
    expect(find.text('Product Type'), findsOneWidget);
    expect(find.text('Device Name (Bluetooth)'), findsOneWidget);
    expect(find.text('Kit Id'), findsOneWidget);
    expect(find.text('Tablet Serial Number'), findsOneWidget);
    expect(find.text('Toco Id'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('form validation shows errors when required fields are empty', (tester) async {
    await pumpWidget(tester);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Organization is required'), findsOneWidget);
    expect(find.text('Product Type is required'), findsOneWidget);
    expect(find.text('Device Name (Bluetooth) is required'), findsOneWidget);
    expect(find.text('Kit Id is required'), findsOneWidget);
  });

  testWidgets('updates cubit when dropdown and text input changes', (tester) async {
    await pumpWidget(tester);

    when(() => mockCubit.updateSelectedOrganization(any(), any())).thenReturn(null);
    when(() => mockCubit.updateSelectedProductType(any())).thenReturn(null);
    when(() => mockCubit.updateDeviceName(any())).thenReturn(null);
    when(() => mockCubit.updateKitId(any())).thenReturn(null);
    when(() => mockCubit.updateTabletSerialNumber(any())).thenReturn(null);
    when(() => mockCubit.updateTocoId(any())).thenReturn(null);

    // Tap and select org
    await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Org One').last);
    await tester.pump();

    // Fill all required inputs
    await tester.enterText(find.byType(TextFormField).at(0), 'Doppler');
    await tester.enterText(find.byType(TextFormField).at(1), 'KIT123');

    verify(() => mockCubit.updateDeviceName('Doppler')).called(1);
    verify(() => mockCubit.updateKitId('KIT123')).called(1);
  });

  testWidgets('calls registerDevice on valid form', (tester) async {
    when(() => mockCubit.registerDevice()).thenAnswer((_) async {});
    when(() => mockCubit.state).thenReturn(
      const DeviceRegistrationState(
        organizationList: [{'id': 'org1', 'name': 'Org One'}],
        productTypeList: ['Type A'],
        selectedOrganizationId: 'org1',
        selectedOrganizationName: 'Org One',
        selectedProductType: 'Type A',
        deviceName: 'Doppler',
        kitId: 'KIT123',
      ),
    );

    await pumpWidget(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Doppler');
    await tester.enterText(find.byType(TextFormField).at(1), 'KIT123');

    await tester.tap(find.text('Save'));
    await tester.pump();

    verify(() => mockCubit.registerDevice()).called(1);
  });

  testWidgets('shows SnackBar on success and clears form', (tester) async {
    when(() => mockCubit.state).thenReturn(
      const DeviceRegistrationState(isSuccess: true),
    );

    await pumpWidget(tester);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Device registered successfully!'), findsOneWidget);
  });

  testWidgets('shows error SnackBar and clears error', (tester) async {
    when(() => mockCubit.state).thenReturn(
      const DeviceRegistrationState(errorMessage: 'Failed to register'),
    );
    when(() => mockCubit.clearError()).thenReturn(null);

    await pumpWidget(tester);
    expect(find.text('Failed to register'), findsOneWidget);

    verify(() => mockCubit.clearError()).called(1);
  });
}
