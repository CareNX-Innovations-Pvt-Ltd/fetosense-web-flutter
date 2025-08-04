import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_cubit.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_view.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_editform.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../core/services/auth_service_test.dart';
import '../widgets/sidebar_test.dart';
import 'organization_analytics_test.dart';

class MockDeviceEditCubit extends Mock implements DeviceEditCubit {}

class FakeDeviceEditState extends Fake implements DeviceEditState {}

class MockAppwriteService extends Mock implements AppwriteService {}

void main() {
  late MockDeviceEditCubit mockCubit;
  late Map<String, dynamic> fakeData;
  late String documentId;
  late bool onCloseCalled;

  setUpAll(() {
    registerFallbackValue(FakeDeviceEditState());
  });

  setUp(() {
    mockCubit = MockDeviceEditCubit();
    fakeData = {
      'deviceCode': 'D123',
      'deviceId': 'DOP123',
      'mother': 3,
      'test': 6,
    };
    documentId = 'doc123';
    onCloseCalled = false;
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<DeviceEditCubit>.value(
          value: mockCubit,
          child: child,
        ),
      ),
    );
  }

  testWidgets('DeviceEditView renders form and info card', (tester) async {
    when(() => mockCubit.state).thenReturn(DeviceEditInitial());

    await tester.pumpWidget(createTestWidget(
      DeviceEditView(
        data: fakeData,
        onClose: () => onCloseCalled = true,
      ),
    ));

    expect(find.byType(DeviceInfoCard), findsOneWidget);
    expect(find.byType(DeviceEditForm), findsOneWidget);
  });

  testWidgets('DeviceEditView handles DeviceEditSaved state', (tester) async {
    whenListen(
      mockCubit,
      Stream.fromIterable([DeviceEditSaved()]),
      initialState: DeviceEditInitial(),
    );

    await tester.pumpWidget(createTestWidget(
      DeviceEditView(
        data: fakeData,
        onClose: () => onCloseCalled = true,
      ),
    ));

    await tester.pump(); // trigger BlocListener

    expect(find.text('Device updated successfully'), findsOneWidget);
    expect(onCloseCalled, isTrue);
  });

  testWidgets('DeviceEditView handles DeviceEditError state', (tester) async {
    whenListen(
      mockCubit,
      Stream.fromIterable([DeviceEditError('Update failed')]),
      initialState: DeviceEditInitial(),
    );

    await tester.pumpWidget(createTestWidget(
      DeviceEditView(
        data: fakeData,
        onClose: () => onCloseCalled = true,
      ),
    ));

    await tester.pump(); // trigger BlocListener

    expect(find.text('Update failed'), findsOneWidget);
  });

  testWidgets('DeviceEditPopup initializes cubit and renders view', (tester) async {
    final mockDb = MockDatabases();
    final mockAppwrite = MockAppwriteService();

    locator.registerSingleton<AppwriteService>(mockAppwrite);
    when(() => mockAppwrite.client).thenReturn(Client());
    when(() => mockDb.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenAnswer((_) async => models.DocumentList(total: 0, documents: []));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DeviceEditPopup(
          data: fakeData,
          documentId: documentId,
          onClose: () => onCloseCalled = true,
        ),
      ),
    ));

    expect(find.byType(DeviceEditView), findsOneWidget);

    // Clean up
    locator.reset();
  });
}
