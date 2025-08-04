import 'dart:typed_data';

import 'package:fetosense_mis/screens/device_details/device_edit/device_edit_cubit.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_info_card.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_stat_card.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';


class MockDeviceEditCubit extends Mock implements DeviceEditCubit {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockDeviceEditCubit mockCubit;

  setUp(() {
    mockCubit = MockDeviceEditCubit();

    // Prevent Image.asset from crashing
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      return ByteData(0);
    });
  });

  testWidgets('renders DeviceInfoCard with data and cubit values', (tester) async {
    final mockController = TextEditingController(text: 'TAB123');
    when(() => mockCubit.tabletSerialNumberController).thenReturn(mockController);

    await tester.pumpWidget(
      MaterialApp(
        home: Provider<DeviceEditCubit>.value(
          value: mockCubit,
          child: const Row(
            children: [
              DeviceInfoCard(data: {
                'deviceName': 'Doppler Pro',
                'deviceCode': 'K12345',
                'email': 'user@example.com',
                'mother': 5,
                'test': 10,
              }),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Doppler Pro'), findsOneWidget);
    expect(find.text('K12345'), findsNWidgets(2)); // deviceCode shown twice
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('5'), findsOneWidget); // Mother count
    expect(find.text('10'), findsOneWidget); // Test count
    expect(find.text('TAB123'), findsOneWidget); // tablet serial number
    expect(find.byType(DeviceStatCard), findsNWidgets(2));
    expect(find.byType(DeviceTileCard), findsNWidgets(2));
  });

  testWidgets('renders fallback values when data is missing', (tester) async {
    final mockController = TextEditingController(text: '');
    when(() => mockCubit.tabletSerialNumberController).thenReturn(mockController);

    await tester.pumpWidget(
      MaterialApp(
        home: Provider<DeviceEditCubit>.value(
          value: mockCubit,
          child: const Row(
            children: [
              DeviceInfoCard(data: {}), // empty map
            ],
          ),
        ),
      ),
    );

    expect(find.text('NA'), findsNWidgets(4)); // deviceName, deviceCode x2, tablet serial
    expect(find.text('0'), findsNWidgets(2)); // default for mother/test count
  });
}
