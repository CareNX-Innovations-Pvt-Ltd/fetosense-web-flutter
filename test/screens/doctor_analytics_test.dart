import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/analytics/doctors_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:get_it/get_it.dart';

class MockPreferenceHelper extends Mock implements PreferenceHelper {}
class MockDatabases extends Mock implements Databases {}
class MockUser extends Mock implements models.User {}

void main() {
  late MockPreferenceHelper mockPrefs;
  late MockDatabases mockDatabase;
  final testDocs = [
    models.Document(
    $id: '1',
    data: {'createdOn': '2025-08-01'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: [],
    ),
    models.Document(
    $id: '2',
    data: {'createdOn': '2025-08-03'}, $collectionId: '', $databaseId: '', $createdAt: '', $updatedAt: '', $permissions: [],
    ),
  ];

  setUpAll(() {
    final getIt = GetIt.instance;
    mockPrefs = MockPreferenceHelper();
    mockDatabase = MockDatabases();
    getIt.registerSingleton<PreferenceHelper>(mockPrefs);
    getIt.registerSingleton<AppwriteService>(AppwriteService());
  });

  testWidgets('DoctorAnalyticsPage shows loading spinner', (tester) async {
    when(() => mockPrefs.getUser()).thenReturn(null);
    await tester.pumpWidget(const MaterialApp(home: DoctorAnalyticsPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DoctorAnalyticsPage displays No data available', (tester) async {
    when(() => mockPrefs.getUser()).thenReturn(
      UserModel(userId: 'userId', email: 'email', role: 'role', organizationId: 'organizationId')
    );
    when(() => mockDatabase.listDocuments(
      databaseId: any(named: 'databaseId'),
      collectionId: any(named: 'collectionId'),
      queries: any(named: 'queries'),
    )).thenAnswer((_) async => models.DocumentList(total: 0, documents: []));

    await tester.pumpWidget(const MaterialApp(home: DoctorAnalyticsPage()));
    await tester.pumpAndSettle();
    expect(find.text("No data available"), findsOneWidget);
  });

  testWidgets('DoctorAnalyticsPage tab switching and chart renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DoctorAnalyticsPage()));
    await tester.pumpAndSettle();

    expect(find.byType(TabBar), findsOneWidget);
    await tester.tap(find.text('Monthly Downloads'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsWidgets);
  });

  test('getWeek returns correct week number', () {
    final pageState = DoctorAnalyticsPageState();
    final week = pageState.getWeek(DateTime(2025, 8, 1));
    expect(week, isA<int>());
    expect(week, greaterThan(0));
  });

  test('buildSpots generates FlSpot list', () {
    final pageState = DoctorAnalyticsPageState();
    final result = pageState.buildSpots([
      {'createdOn': '2025-W1', 'noOfDoctors': 1},
      {'createdOn': '2025-W2', 'noOfDoctors': 5},
    ]);
    expect(result, isA<List<FlSpot>>());
    expect(result.length, 2);
  });

  test('prepareTrend groups documents correctly', () {
    final pageState = DoctorAnalyticsPageState();
    final result = pageState.prepareTrend(testDocs, 'weekly');
    expect(result.length, 1);
    expect(result.first['noOfDoctors'], 2);
  });
}
