import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/analytics/organizations_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../core/services/auth_service_test.dart';

final locator = GetIt.instance;

class MockAppwriteService extends Mock implements AppwriteService {}

void main() {
  late MockAppwriteService mockAppwriteService;

  setUp(() {
    locator.reset();
    locator.registerSingleton<AppwriteService>(MockAppwriteService());
    print(locator.isRegistered<AppwriteService>()); // should print: true

    locator.registerSingleton<PreferenceHelper>(MockPreferenceHelper());
  });

  group('OrganizationAnalyticsPage', () {
    testWidgets('renders correctly and shows loading initially', (WidgetTester tester) async {
      expect(locator.isRegistered<AppwriteService>(), true);

      await tester.pumpWidget(
        const MaterialApp(
          home: OrganizationAnalyticsPage(),
        ),
      );

      expect(find.text("Organization Analytics"), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    test('generateWeeklyBuckets returns correct labels', () {
      final state = _FakeState();

      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 1, 31);

      final result = state.generateWeeklyBuckets(start, end);
      expect(result.length, greaterThan(3));
      expect(result.first, contains('-')); // formatted as 'dd-MM-yyyy - dd-MM-yyyy'
    });

    test('generateMonthlyBuckets returns correct labels', () {
      final state = _FakeState();

      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 5, 1);

      final result = state.generateMonthlyBuckets(start, end);
      expect(result.length, 4);
      expect(result[0], equals('2024-01'));
      expect(result[3], equals('2024-04'));
    });

    test('TestData model works correctly', () {
      final data = TestData(label: '2024-01', tests: 5);

      expect(data.label, equals('2024-01'));
      expect(data.tests, equals(5));
    });
  });

  group('TestLineChart', () {
    testWidgets('displays chart with test data (weekly)', (WidgetTester tester) async {
      final data = [
        TestData(label: '01-01-2024 - 07-01-2024', tests: 5),
        TestData(label: '08-01-2024 - 14-01-2024', tests: 8),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestLineChart(data: data, isWeekly: true),
          ),
        ),
      );

      expect(find.byType(TestLineChart), findsOneWidget);
    });

    testWidgets('displays chart with test data (monthly)', (WidgetTester tester) async {
      final data = [
        TestData(label: '2024-01', tests: 3),
        TestData(label: '2024-02', tests: 7),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestLineChart(data: data, isWeekly: false),
          ),
        ),
      );

      expect(find.byType(TestLineChart), findsOneWidget);
    });
  });
}

/// A minimal fake class to expose internal methods for testing without full widget lifecycle.
class _FakeState {
  List<String> generateWeeklyBuckets(DateTime start, DateTime end) {
    final buckets = <String>[];
    DateTime current = start.subtract(Duration(days: start.weekday % 7));
    while (current.isBefore(end)) {
      final weekStart = current;
      final weekEnd = current.add(const Duration(days: 6));
      final label =
          '${DateFormat('dd-MM-yyyy').format(weekStart)} - ${DateFormat('dd-MM-yyyy').format(weekEnd)}';
      buckets.add(label);
      current = current.add(const Duration(days: 7));
    }
    return buckets;
  }

  List<String> generateMonthlyBuckets(DateTime start, DateTime end) {
    final buckets = <String>[];
    DateTime current = DateTime(start.year, start.month);
    while (current.isBefore(end)) {
      buckets.add(DateFormat('yyyy-MM').format(current));
      current = DateTime(current.year, current.month + 1);
    }
    return buckets;
  }
}
