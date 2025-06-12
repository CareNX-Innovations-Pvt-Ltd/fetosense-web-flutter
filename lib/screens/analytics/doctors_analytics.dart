/// A Flutter widget that displays weekly and monthly analytics charts for doctors,
/// using Appwrite as the backend and FL Chart for visualization.
library;

import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:intl/intl.dart';

import '../../core/utils/user_role.dart' show UserRoles;

/// The main page that renders doctor registration trends in weekly and monthly charts.
class DoctorAnalyticsPage extends StatefulWidget {
  /// Constructor for [DoctorAnalyticsPage].
  const DoctorAnalyticsPage({super.key});

  @override
  State<DoctorAnalyticsPage> createState() => _DoctorAnalyticsPageState();
}

/// The state for [DoctorAnalyticsPage], handling tab switching, data loading, and chart rendering.
class _DoctorAnalyticsPageState extends State<DoctorAnalyticsPage>
    with TickerProviderStateMixin {
  /// Controller for switching between weekly and monthly tabs.
  late TabController _tabController;

  /// Whether data is currently being loaded.
  bool isLoading = true;

  /// Whether chart data is available.
  bool isChartDataAvailable = false;

  /// Weekly data points for the line chart.
  List<FlSpot> weeklySpots = [];

  /// Labels for the X-axis of the weekly chart.
  List<String> weeklyLabels = [];

  /// Monthly data points for the line chart.
  List<FlSpot> monthlySpots = [];

  /// Labels for the X-axis of the monthly chart.
  List<String> monthlyLabels = [];

  /// Instance of Appwrite [Databases] for data access.
  late final Databases database;

  final client = locator<AppwriteService>().client;

  final prefs = locator<PreferenceHelper>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    database = Databases(client);
    fetchAnalyticsData();
  }

  /// Fetches doctor registration data from Appwrite and prepares data for both weekly and monthly charts.
  Future<void> fetchAnalyticsData() async {
    final userData = prefs.getUser();
    if (userData == null) return;
    final isRestricted = userData.role != UserRoles.superAdmin;

    List<String> buildQueries(String type) {
      final queries = <String>[];
      if (type.isNotEmpty) queries.add(Query.equal('type', type));
      if (isRestricted) {
        queries.add(Query.equal('organizationId', userData.organizationId));
      }
      return queries;
    }

    try {
      final response = await database.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: buildQueries('doctor'),
      );

      final docs = response.documents;
      if (docs.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      final weeklyTrend = prepareTrend(docs, 'weekly');
      final monthlyTrend = prepareTrend(docs, 'monthly');

      setState(() {
        weeklySpots = buildSpots(weeklyTrend);
        weeklyLabels =
            weeklyTrend.map((e) => e['createdOn'] as String).toList();

        monthlySpots = buildSpots(monthlyTrend);
        monthlyLabels =
            monthlyTrend.map((e) => e['createdOn'] as String).toList();

        isChartDataAvailable = true;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  /// Processes a list of documents and returns a time-bucketed list of doctor registrations.
  ///
  /// [docs] - List of Appwrite documents.
  /// [type] - Either `'weekly'` or `'monthly'`.
  List<Map<String, dynamic>> prepareTrend(
    List<models.Document> docs,
    String type,
  ) {
    final trendMap = <String, int>{};

    for (final doc in docs) {
      final createdOn = doc.data['createdOn'];
      if (createdOn == null) continue;

      final date = DateTime.parse(createdOn);
      final key =
          (type == 'weekly')
              ? '${date.year}-W${getWeek(date)}'
              : DateFormat('yyyy-MM').format(date);

      trendMap[key] = (trendMap[key] ?? 0) + 1;
    }

    final result =
        trendMap.entries
            .map((e) => {'createdOn': e.key, 'noOfDoctors': e.value})
            .toList();

    result.sort(
      (a, b) => (a['createdOn'] as String).compareTo(b['createdOn'] as String),
    );
    return result;
  }

  /// Converts trend data into a list of [FlSpot] for chart rendering.
  ///
  /// [data] - List of maps with `createdOn` and `noOfDoctors`.
  List<FlSpot> buildSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        (e.value['noOfDoctors'] as int).toDouble(),
      );
    }).toList();
  }

  /// Calculates the week number for a given [date].
  ///
  /// Week starts from the first day of the year.
  int getWeek(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Builds the line chart widget for the provided data.
  ///
  /// [spots] - Y-axis points.
  /// [labels] - X-axis labels.
  Widget buildChart(List<FlSpot> spots, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      index < labels.length ? labels[index] : '',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Tab bar to switch between Weekly and Monthly views.
        TabBar(
          controller: _tabController,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: 'Weekly Downloads'),
            Tab(icon: Icon(Icons.trending_up), text: 'Monthly Downloads'),
          ],
        ),

        /// Body of the page that shows either a chart or a loading indicator.
        Expanded(
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isChartDataAvailable
                  ? TabBarView(
                    controller: _tabController,
                    children: [
                      buildChart(weeklySpots, weeklyLabels),
                      buildChart(monthlySpots, monthlyLabels),
                    ],
                  )
                  : const Center(child: Text("No data available")),
        ),
      ],
    );
  }
}
