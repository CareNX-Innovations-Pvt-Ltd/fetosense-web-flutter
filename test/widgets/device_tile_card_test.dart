import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Load a fake image asset
    final byteData = ByteData(10);
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
          (message) async => byteData.buffer.asByteData(),
    );
  });

  group('DeviceTileCard Widget Tests', () {
    testWidgets('renders label and value correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                DeviceTileCard(
                  imagePath: 'assets/images/sample.png',
                  label: 'Battery',
                  value: '90%',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Battery'), findsOneWidget);
      expect(find.text('90%'), findsOneWidget);
    });

    testWidgets('renders image with correct asset path', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                DeviceTileCard(
                  imagePath: 'assets/images/sample.png',
                  label: 'Status',
                  value: 'Active',
                ),
              ],
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/sample.png');
    });

    testWidgets('uses correct decoration with gradient, border, and shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                DeviceTileCard(
                  imagePath: 'assets/images/sample.png',
                  label: 'Connection',
                  value: 'Good',
                ),
              ],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DeviceTileCard),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.boxShadow, isNotEmpty);
      expect(decoration.border, isA<Border>());
    });
  });
}
