import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class OrganizationAnalyticsPage extends StatefulWidget {
  final Client client;
  const OrganizationAnalyticsPage({super.key, required this.client});

  @override
  State<OrganizationAnalyticsPage> createState() =>
      _OrganizationAnalyticsPageState();
}

class _OrganizationAnalyticsPageState extends State<OrganizationAnalyticsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final Databases database;
  late final functions;

  bool isLoading = false;
  bool isChartDataAvailable = false;
  bool isGraphLoading = false;

  List<Map<String, dynamic>> organizations = [];
  Map<String, dynamic>? selectedOrg;

  DateTime? fromDate;
  DateTime? toDate;

  List<FlSpot> weeklySpots = [];
  List<String> weeklyLabels = [];

  List<FlSpot> monthlySpots = [];
  List<String> monthlyLabels = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    database = Databases(widget.client);
    functions = Functions(widget.client);
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      setState(() => isLoading = true);

      final result = await database.listDocuments(
        databaseId: 'your_database_id',
        collectionId: 'organizations',
      );

      organizations =
          result.documents
              .map((doc) => {'id': doc.$id, 'name': doc.data['name']})
              .toList();

      if (organizations.isNotEmpty) {
        selectedOrg = organizations[0];
        fetchGraphData();
      }

      setState(() => isLoading = false);
    } catch (e) {
      print("Error fetching organizations: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchGraphData() async {
    if (selectedOrg == null) return;

    setState(() {
      isGraphLoading = true;
      isChartDataAvailable = false;
    });

    final body = {
      "organizationId": selectedOrg!['id'],
      "fromDate": fromDate?.toIso8601String(),
      "toDate": toDate?.toIso8601String(),
      "apiKey": "ay7px0rjojzbtz0ym0",
    };

    try {
      final res = await widget.client.call(
        method: 'POST',
        path: '/analytics/organization_dashboard',
        data: body,
      );

      final trendData = res.data['trend'] ?? [];
      final Map<String, int> weeklyMap = {};
      final Map<String, int> monthlyMap = {};

      for (var item in trendData) {
        final date = DateTime.parse(item['date']);
        final weekKey = getWeekRange(date);
        final monthKey = DateFormat('yyyy-MM').format(date);

        weeklyMap[weekKey] = (weeklyMap[weekKey] ?? 0) + item['testsTaken'];
        monthlyMap[monthKey] = (monthlyMap[monthKey] ?? 0) + item['testsTaken'];
      }

      setState(() {
        weeklyLabels = weeklyMap.keys.toList();
        weeklySpots = buildSpots(weeklyMap);

        monthlyLabels = monthlyMap.keys.toList();
        monthlySpots = buildSpots(monthlyMap);

        isGraphLoading = false;
        isChartDataAvailable =
            weeklySpots.isNotEmpty || monthlySpots.isNotEmpty;
      });
    } catch (e) {
      print("Error fetching organization trend: $e");
      setState(() => isGraphLoading = false);
    }
  }

  List<FlSpot> buildSpots(Map<String, int> map) {
    return map.entries
        .toList()
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
        .toList();
  }

  String getWeekRange(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday % 7));
    final end = start.add(const Duration(days: 6));
    final format = DateFormat('dd-MM-yyyy');
    return '${format.format(start)} - ${format.format(end)}';
  }

  Widget buildChart(List<FlSpot> spots, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  return Text(
                    index < labels.length ? labels[index] : '',
                    style: const TextStyle(fontSize: 10),
                  );
                },
                interval: 1,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.teal,
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
    return Stack(
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Column(
            children: [
              // Filters
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedOrg,
                        items:
                            organizations
                                .map(
                                  (org) => DropdownMenuItem(
                                    value: org,
                                    child: Text(org['name']),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          setState(
                            () => selectedOrg = val as Map<String, dynamic>,
                          );
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Organization',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputDatePickerFormField(
                        firstDate: DateTime(2017),
                        lastDate: DateTime.now(),
                        fieldLabelText: "From Date",
                        onDateSubmitted:
                            (date) => setState(() => fromDate = date),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputDatePickerFormField(
                        firstDate: DateTime(2017),
                        lastDate: DateTime.now(),
                        fieldLabelText: "To Date",
                        onDateSubmitted:
                            (date) => setState(() => toDate = date),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: fetchGraphData,
                      child: const Text("Get Data"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(icon: Icon(Icons.trending_up), text: "Weekly Tests"),
                  Tab(icon: Icon(Icons.trending_up), text: "Monthly Tests"),
                ],
              ),
              Expanded(
                child:
                    isGraphLoading
                        ? const Center(child: CircularProgressIndicator())
                        : isChartDataAvailable
                        ? TabBarView(
                          controller: _tabController,
                          children: [
                            buildChart(weeklySpots, weeklyLabels),
                            buildChart(monthlySpots, monthlyLabels),
                          ],
                        )
                        : const Center(
                          child: Text("No data available for selected filters"),
                        ),
              ),
            ],
          ),
      ],
    );
  }
}
