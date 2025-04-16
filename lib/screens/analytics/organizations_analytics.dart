import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/fetch_organizations.dart';
import '../../utils/fetch_tests.dart';

class OrganizationAnalyticsPage extends StatefulWidget {
  final Client client;
  const OrganizationAnalyticsPage({super.key, required this.client});

  @override
  State<OrganizationAnalyticsPage> createState() =>
      _OrganizationAnalyticsPageState();
}

class _OrganizationAnalyticsPageState extends State<OrganizationAnalyticsPage> {
  late Databases db;
  List<models.Document> organizations = [];
  List<TestData> testData = [];
  String? selectedOrgId;
  DateTime? fromDate;
  DateTime? toDate = DateTime.now();
  bool isLoading = false;
  bool isWeekly = true;

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);
    fetchOrganizationsList();
  }

  Future<void> fetchOrganizationsList() async {
    final orgs = await fetchOrganizations(db);
    setState(() => organizations = orgs);
  }

  Future<void> fetchGraphData() async {
    if (selectedOrgId == null || fromDate == null || toDate == null) {
      print(
        ' Missing inputs: selectedOrgId=$selectedOrgId, fromDate=$fromDate, toDate=$toDate',
      );
      return;
    }
    print(
      ' Fetching graph data for Org=$selectedOrgId from=$fromDate to=$toDate',
    );

    setState(() => isLoading = true);
    final docs = await fetchTests(db, fromDate: fromDate, tillDate: toDate);
    print(' Total tests fetched: ${docs.length}');

    final filtered =
        docs.where((d) => d.data['organizationId'] == selectedOrgId).toList();
    print(' Filtered tests for Org=$selectedOrgId: ${filtered.length}');

    final map = <String, int>{};

    for (final doc in filtered) {
      final dateStr = doc.data['createdOn'];
      if (dateStr == null) continue;
      final date = DateTime.parse(dateStr);

      String label;
      if (isWeekly) {
        final start = date.subtract(Duration(days: date.weekday % 7));
        final end = start.add(const Duration(days: 6));
        label =
            '${DateFormat('dd-MM-yyyy').format(start)} - ${DateFormat('dd-MM-yyyy').format(end)}';
      } else {
        label = DateFormat('yyyy-MM').format(date);
      }

      map[label] = (map[label] ?? 0) + 1;
    }

    final list =
        map.entries.map((e) => TestData(label: e.key, tests: e.value)).toList();
    list.sort((a, b) => a.label.compareTo(b.label));

    print(' Grouped ${isWeekly ? "weekly" : "monthly"} data:');
    for (final item in list) {
      print('   ${item.label} => ${item.tests}');
    }

    setState(() {
      testData = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Organization Analytics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchGraphData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey[900],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black26,
                      labelText: 'Select organization',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedOrgId,
                    items:
                        organizations
                            .map<DropdownMenuItem<String>>(
                              (org) => DropdownMenuItem<String>(
                                value: org.$id,
                                child: Text(
                                  org.data['name'] ?? 'Unnamed',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),

                    onChanged: (val) => setState(() => selectedOrgId = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: fromDate ?? DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => fromDate = date);
                    },
                    decoration: const InputDecoration(
                      labelText: 'From Date',
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    controller: TextEditingController(
                      text:
                          fromDate != null
                              ? DateFormat('dd-MM-yyyy').format(fromDate!)
                              : '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: toDate ?? DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => toDate = date);
                    },
                    decoration: const InputDecoration(
                      labelText: 'To Date',
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    controller: TextEditingController(
                      text:
                          toDate != null
                              ? DateFormat('dd-MM-yyyy').format(toDate!)
                              : '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: fetchGraphData,
                  child: const Text("Get Data"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isWeekly ? 'Weekly Test Trend' : 'Monthly Test Trend',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => isWeekly = !isWeekly),
                  child: Text(isWeekly ? 'Show Monthly' : 'Show Weekly'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : testData.isEmpty
                      ? const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TestLineChart(
                          data: testData,
                          isWeekly: isWeekly,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestData {
  final String label;
  final int tests;
  TestData({required this.label, required this.tests});
}

class TestLineChart extends StatelessWidget {
  final List<TestData> data;
  final bool isWeekly;
  const TestLineChart({super.key, required this.data, required this.isWeekly});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine:
              (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final parts = data[index].label.split('-');
                  return SideTitleWidget(
                    space: 8,
                    child: Text(
                      isWeekly
                          ? 'W${index + 1}'
                          : (parts.length >= 2
                              ? DateFormat.MMM().format(
                                DateTime(0, int.parse(parts[1])),
                              )
                              : ''),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    meta: meta,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade700),
            left: BorderSide(color: Colors.grey.shade700),
          ),
        ),
        minX: 0,
        maxX: data.length - 1.0,
        minY: 0,
        maxY:
            (data
                .map((e) => e.tests)
                .reduce((a, b) => a > b ? a : b)
                .toDouble()) *
            1.2,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index].tests.toDouble()),
            ),
            isCurved: true,
            color: Colors.teal,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
