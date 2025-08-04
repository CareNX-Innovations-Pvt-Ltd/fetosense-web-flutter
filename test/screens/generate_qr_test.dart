import 'dart:convert';
import 'package:fetosense_mis/screens/generate_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GenerateQRPage Widget Tests', () {
    testWidgets('renders initial UI correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GenerateQRPage())),
      );

      expect(find.text('Generate QR Code'), findsOneWidget);
      expect(find.text('Kit ID'), findsOneWidget);
      expect(find.text('Generate'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows validation error when kit ID is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GenerateQRPage())),
      );

      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      expect(find.text('Kit ID is required'), findsOneWidget);
    });

    testWidgets('trims leading space on kit ID input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GenerateQRPage())),
      );

      final field = find.byType(TextFormField);
      await tester.enterText(field, ' 12345');
      await tester.pump();

      expect((tester.widget(field) as TextFormField).controller!.text, '12345');
    });

    testWidgets('shows QR section on valid input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GenerateQRPage())),
      );

      final field = find.byType(TextFormField);
      await tester.enterText(field, 'KIT123');
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      expect(find.text('Share this QR Code'), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsOneWidget);

      // final encoded = base64Encode(utf8.encode('KIT123'));
      // expect(find.byWidgetPredicate((widget) =>
      // widget is QrImageView && widget.data == 'CMFETO:$encoded'), findsOneWidget);
    });

    testWidgets('toggles Show Kit ID checkbox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GenerateQRPage())),
      );

      final field = find.byType(TextFormField);
      await tester.enterText(field, 'KIT987');
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      expect(find.text('Kit ID: KIT987'), findsOneWidget);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      expect(find.text('Kit ID: KIT987'), findsNothing);
    });

    testWidgets('download icon button exists and can be tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GenerateQRPage())),
      );

      final field = find.byType(TextFormField);
      await tester.enterText(field, 'QR001');
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      final downloadBtn = find.byIcon(Icons.download);
      expect(downloadBtn, findsOneWidget);

      await tester.tap(downloadBtn);
      await tester.pumpAndSettle();
    });
  });
}
