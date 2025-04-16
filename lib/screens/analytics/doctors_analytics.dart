import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:intl/intl.dart';

class DoctorAnalyticsPage extends StatefulWidget {
  final Client client;
  const DoctorAnalyticsPage({super.key, required this.client});

  @override
  State<DoctorAnalyticsPage> createState() => _DoctorAnalyticsPageState();
}

class _DoctorAnalyticsPageState extends State<DoctorAnalyticsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  bool isChartDataAvailable = false;

  List<FlSpot> weeklySpots = [];
  List<String> weeklyLabels = [];

  List<FlSpot> monthlySpots = [];
  List<String> monthlyLabels = [];

  late final Databases database;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    database = Databases(widget.client);
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    try {
      final response = await database.listDocuments(
        databaseId: '67ece4a7002a0a732dfd',
        collectionId: '67f36a7e002c46ea05f0',
        queries: [Query.equal('type', 'doctor')],
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
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

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

  List<FlSpot> buildSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        (e.value['noOfDoctors'] as int).toDouble(),
      );
    }).toList();
  }

  int getWeek(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday) / 7).ceil();
  }

  Widget buildChart(List<FlSpot> spots, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
              dotData: FlDotData(show: false),
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
        TabBar(
          controller: _tabController,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: 'Weekly Downloads'),
            Tab(icon: Icon(Icons.trending_up), text: 'Monthly Downloads'),
          ],
        ),
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
