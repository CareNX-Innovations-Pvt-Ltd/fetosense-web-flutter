import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/screens/device_details/widgets/device_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart'; // or flutter_bloc if you use Bloc

class MockDeviceDetailsCubit extends Mock implements DeviceDetailsCubit {}

void main() {
  late MockDeviceDetailsCubit mockCubit;

  setUp(() {
    mockCubit = MockDeviceDetailsCubit();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: Provider<DeviceDetailsCubit>.value(
          value: mockCubit,
          child: const DeviceDetailsHeader(),
        ),
      ),
    );
  }

  testWidgets('renders Device Details text and icons', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Device Details'), findsOneWidget);
    expect(find.byIcon(Icons.apartment), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets('tapping download icon calls downloadExcel', (tester) async {
    when(() => mockCubit.downloadExcel(any())).thenReturn(Future.value());

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byIcon(Icons.download));
    await tester.pump();

    verify(() => mockCubit.downloadExcel(any())).called(1);
  });
}
