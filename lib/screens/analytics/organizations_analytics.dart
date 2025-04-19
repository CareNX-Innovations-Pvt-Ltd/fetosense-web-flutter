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
    fetchGraphData();
  }

  Future<void> fetchOrganizationsList() async {
    final orgs = await fetchOrganizations(db);
    setState(() => organizations = orgs);
  }

  List<String> generateWeeklyBuckets(DateTime start, DateTime end) {
    final buckets = <String>[];
    DateTime current = start.subtract(Duration(days: start.weekday % 7));
    while (current.isBefore(end)) {
      final weekStart = current;
      final weekEnd = current.add(Duration(days: 6));
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

  Future<void> fetchGraphData() async {
    final now = DateTime.now();
    final effectiveFromDate =
        fromDate ?? now.subtract(const Duration(days: 730)); // 2 years ago
    final effectiveToDate = toDate ?? now;

    setState(() => isLoading = true);

    final docs = await fetchTests(
      db,
      fromDate: effectiveFromDate,
      tillDate: effectiveToDate,
    );

    final map = <String, int>{};

    for (final doc in docs) {
      final dateStr = doc.data['createdOn'];
      if (dateStr == null) continue;

      final orgId = doc.data['organizationId'];
      if (selectedOrgId != null && orgId != selectedOrgId) continue;

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

    final expectedBuckets =
        isWeekly
            ? generateWeeklyBuckets(effectiveFromDate, effectiveToDate)
            : generateMonthlyBuckets(effectiveFromDate, effectiveToDate);

    final list =
        expectedBuckets
            .map((label) => TestData(label: label, tests: map[label] ?? 0))
            .toList();

    setState(() {
      fromDate ??= effectiveFromDate;
      testData = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A1B),
      appBar: AppBar(
        backgroundColor: Color(0xff1F2223),
        title: const Text("Organization Analytics"),
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
                      fillColor: Color(0xFF181A1B),
                      labelText: 'Select organization',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedOrgId,
                    items:
                        organizations
                            .map(
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
                      fillColor: Color(0xFF181A1B),
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
                      fillColor: Color(0xFF181A1B),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // No background color
                    foregroundColor: const Color(
                      0xFF167292,
                    ), // Text color (blue)
                    side: BorderSide(
                      color: const Color(0xFF167292),
                      width: 1,
                    ), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Optional: add rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ), // Optional: Add padding for better look
                  ),
                  child: const Text("Get Data"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row
              children: [
                ToggleButtons(
                  isSelected: [isWeekly, !isWeekly], // Control selected state
                  selectedColor: Colors.white,
                  color: Colors.white70,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  children: [
                    Row(
                      children: const [
                        const SizedBox(width: 16),

                        Icon(Icons.trending_up, color: Colors.white70),
                        SizedBox(width: 5),
                        Text("Weekly", style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Row(
                      children: const [
                        const SizedBox(width: 16),

                        Icon(Icons.trending_up, color: Colors.white70),
                        SizedBox(width: 5),
                        Text(
                          "Monthly",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                  onPressed: (index) {
                    setState(() {
                      isWeekly =
                          index == 0; // Toggle between weekly and monthly
                    });
                  },
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
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget:
                  (value, _) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final label =
                      isWeekly
                          ? 'W${index + 1}'
                          : DateFormat.MMM().format(
                            DateTime(
                              0,
                              int.parse(data[index].label.split('-')[1]),
                            ),
                          );
                  return SideTitleWidget(
                    child: Text(
                      label,
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
                .reduce((a, b) => a > b ? a : b)).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index].tests.toDouble()),
            ),
            isCurved: true,
            color: const Color(0xFF167292),
            barWidth: 3,
            preventCurveOverShooting: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(
                0xFF167292,
              ).withOpacity(0.1), // Correctly apply opacity to the color
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (lineBarSpots) {
              return lineBarSpots.map((lineBarSpot) {
                final index = lineBarSpot.spotIndex.toInt();
                if (index >= 0 && index < data.length) {
                  String weekRange = isWeekly ? '${data[index].label}' : '';
                  return LineTooltipItem(
                    '${weekRange}: ${data[index].tests} tests',
                    const TextStyle(color: Colors.white),
                  );
                }
                return LineTooltipItem('', const TextStyle());
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
