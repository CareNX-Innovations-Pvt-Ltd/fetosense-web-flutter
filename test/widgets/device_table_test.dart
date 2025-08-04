import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_view.dart';
import 'package:fetosense_mis/screens/device_details/widgets/device_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/models.dart' as models;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late DeviceDetailsState state;
  late models.Document device;

  setUp(() {
    device = models.Document(
      data: {
        'deviceCode': 'KIT123',
        'deviceName': 'DopplerX',
        'organizationName': 'Apollo Hospital',
        'noOfMother': 5,
        'noOfTests': 10,
        'createdOn': DateTime.now().toIso8601String(),
        'appVersion': '1.2.3',
      },
      $permissions: [], $id: '', $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '',
    );

    state = DeviceDetailsState(
      allDevices: [],
      fromDate: DateTime(2023, 1, 1),
      tillDate: DateTime(2023, 12, 31),
      isLoading: false,
      errorMessage: '',
      searchQuery: '', filteredDevices: [],
    ).copyWith(filteredDevices: [device]);
  });

  testWidgets('renders all headers correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DeviceTable(state: state)),
      ),
    );

    expect(find.text('Doppler Number'), findsOneWidget);
    expect(find.text('Device Code'), findsOneWidget);
    expect(find.text('Organization'), findsOneWidget);
    expect(find.text('Mother'), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('CreatedOn'), findsOneWidget);
    expect(find.text('Version'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('renders device data into table row', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DeviceTable(state: state)),
      ),
    );

    expect(find.text('KIT123'), findsOneWidget);
    expect(find.text('DopplerX'), findsOneWidget);
    expect(find.text('Apollo Hospital'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('1.2.3'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets('tap on Edit opens DeviceEditPopup dialog', (tester) async {
    final navigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DeviceTable(state: state)),
        navigatorObservers: [navigatorObserver],
      ),
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(DeviceEditPopup), findsOneWidget);
  });
}
