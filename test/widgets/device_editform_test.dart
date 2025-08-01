import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_cubit.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_editform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:appwrite/appwrite.dart';

import 'device_editform_test.mocks.dart';

@GenerateMocks([DeviceEditCubit, Databases])
void main() {
  late MockDeviceEditCubit cubit;

  setUp(() {
    cubit = MockDeviceEditCubit();

    // Set up fake controllers
    when(cubit.deviceCodeController).thenReturn(TextEditingController(text: "KIT123"));
    when(cubit.deviceNameController).thenReturn(TextEditingController(text: "Bluetooth123"));
    when(cubit.tabletSerialNumberController).thenReturn(TextEditingController(text: "SN123"));

    // Stub for updateChanges
    when(cubit.updateChanges()).thenAnswer((_) async {
       return;
    });
  });

  testWidgets('DeviceEditForm renders and responds to actions', (WidgetTester tester) async {
    bool cancelCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeviceEditForm(
            cubit: cubit,
            onClose: () => cancelCalled = true,
          ),
        ),
      ),
    );

    // Verify static text
    expect(find.text("Device Details"), findsOneWidget);
    expect(find.text("KIT123"), findsOneWidget);
    expect(find.text("Bluetooth123"), findsOneWidget);
    expect(find.text("SN123"), findsOneWidget);
    expect(find.text("Update"), findsOneWidget);
    expect(find.text("Cancel"), findsOneWidget);

    // Tap update button
    await tester.tap(find.text("Update"));
    await tester.pumpAndSettle();

    verify(cubit.updateChanges()).called(1);

    // Tap cancel button
    await tester.tap(find.text("Cancel"));
    await tester.pumpAndSettle();

    expect(cancelCalled, isTrue);
  });
}
