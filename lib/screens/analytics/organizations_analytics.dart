/// Flutter page that shows weekly or monthly test analytics for organizations
/// using Appwrite as the backend and fl_chart for graph visualization.
library;
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/fetch_organizations.dart';
import '../../utils/fetch_tests.dart';

/// A page that displays test trends for selected organizations in weekly/monthly charts.
class OrganizationAnalyticsPage extends StatefulWidget {

  /// Creates an [OrganizationAnalyticsPage] instance.
  const OrganizationAnalyticsPage({super.key,});

  @override
  State<OrganizationAnalyticsPage> createState() =>
      _OrganizationAnalyticsPageState();
}

class _OrganizationAnalyticsPageState extends State<OrganizationAnalyticsPage> {
  /// Instance of Appwrite [Databases].
  late Databases db;

  final client = locator<AppwriteService>().client;

  /// List of available organizations.
  List<models.Document> organizations = [];

  /// List of test count per week/month.
  List<TestData> testData = [];

  /// Currently selected organization ID.
  String? selectedOrgId;

  /// From-date filter for the chart.
  DateTime? fromDate;

  /// To-date filter for the chart.
  DateTime? toDate = DateTime.now();

  /// Whether data is being fetched.
  bool isLoading = false;

  /// Toggle between weekly and monthly view.
  bool isWeekly = true;

  @override
  void initState() {
    super.initState();
    db = Databases(client);
    fetchOrganizationsList();
    fetchGraphData();
  }

  /// Fetches the list of organizations from Appwrite.
  Future<void> fetchOrganizationsList() async {
    final orgs = await fetchOrganizations(db);
    setState(() => organizations = orgs);
  }

  /// Generates weekly labels between [start] and [end].
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

  /// Generates monthly labels between [start] and [end].
  List<String> generateMonthlyBuckets(DateTime start, DateTime end) {
    final buckets = <String>[];
    DateTime current = DateTime(start.year, start.month);
    while (current.isBefore(end)) {
      buckets.add(DateFormat('yyyy-MM').format(current));
      current = DateTime(current.year, current.month + 1);
    }
    return buckets;
  }

  /// Fetches test data from Appwrite and builds graph points.
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
        backgroundColor: const Color(0xff1F2223),
        title: const Text("Organization Analytics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Filters and dropdowns for organization and date range
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
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF167292),
                    side: const BorderSide(color: Color(0xFF167292), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text("Get Data"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Toggle buttons for chart type
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: [isWeekly, !isWeekly],
                  selectedColor: Colors.white,
                  color: Colors.white70,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.trending_up, color: Colors.white70),
                        SizedBox(width: 5),
                        Text("Weekly", style: TextStyle(color: Colors.white70)),
                        SizedBox(width: 16),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.trending_up, color: Colors.white70),
                        SizedBox(width: 5),
                        Text(
                          "Monthly",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                  ],
                  onPressed: (index) {
                    setState(() {
                      isWeekly = index == 0;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Chart or loader
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

/// Represents test data per time unit.
class TestData {
  /// X-axis label (e.g., week or month).
  final String label;

  /// Number of tests taken.
  final int tests;

  /// Creates a [TestData] instance.
  TestData({required this.label, required this.tests});
}

/// Widget to render a line chart from test data.
class TestLineChart extends StatelessWidget {
  /// List of data points to show.
  final List<TestData> data;

  /// Whether the chart is weekly (true) or monthly (false).
  final bool isWeekly;

  /// Creates a [TestLineChart] widget.
  const TestLineChart({super.key, required this.data, required this.isWeekly});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
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
                    meta: meta,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            data.map((e) => e.tests).reduce((a, b) => a > b ? a : b).toDouble(),
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
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF167292).withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (lineBarSpots) {
              return lineBarSpots.map((lineBarSpot) {
                final index = lineBarSpot.spotIndex.toInt();
                if (index >= 0 && index < data.length) {
                  String weekRange = isWeekly ? data[index].label : '';
                  return LineTooltipItem(
                    '$weekRange: ${data[index].tests} tests',
                    const TextStyle(color: Colors.white),
                  );
                }
                return const LineTooltipItem('', TextStyle());
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
