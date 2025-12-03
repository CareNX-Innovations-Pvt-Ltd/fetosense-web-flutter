import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fetosense_mis/core/models/test_model.dart';

enum GroupByPeriod { day, week, month }

enum ChartType { line, bar }

class GraphCard extends StatefulWidget {
  final List<Test> tests;

  const GraphCard({super.key, required this.tests});

  @override
  State<GraphCard> createState() => _GraphCardState();
}

class _GraphCardState extends State<GraphCard> {
  GroupByPeriod _groupBy = GroupByPeriod.day;
  ChartType _chartType = ChartType.line;
  int? _recordLimit;

  @override
  Widget build(BuildContext context) {
    final chartData = _processTestData();

    // final stats = _calculateStats(chartData);

    return Card(
      color: Colors.black,
      elevation: 4,
      margin: const EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            // _buildStatsCards(stats),
            // const SizedBox(height: 10),
            _buildChart(chartData),
            // const SizedBox(height: 3),
            // _buildFooter(chartData.length),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.trending_up,
                color: Colors.blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tests Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // Text(
                //   'Analysis of ${widget.tests.length} test records',
                //   style: const TextStyle(fontSize: 14, color: Colors.white),
                // ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildDropdown<int?>(
              value: _recordLimit,
              items: const {
                null: 'All Records',
                100: 'Last 100',
                250: 'Last 250',
                500: 'Last 500',
                1000: 'Last 1000',
              },
              onChanged: (value) => setState(() => _recordLimit = value),
            ),
            const SizedBox(width: 12),
            _buildDropdown<GroupByPeriod>(
              value: _groupBy,
              items: const {
                GroupByPeriod.day: 'Daily',
                GroupByPeriod.week: 'Weekly',
                GroupByPeriod.month: 'Monthly',
              },
              onChanged: (value) => setState(() => _groupBy = value!),
            ),
            const SizedBox(width: 12),

          ],
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required Map<T, String> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        dropdownColor: Colors.grey[900],
        underline: const SizedBox(),
        items:
            items.entries.map((entry) {
              return DropdownMenuItem<T>(
                value: entry.key,
                child: Text(entry.value, style: const TextStyle(color: Colors.white54)),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildChart(List<ChartDataPoint> data) {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 16),
        child:
            _chartType == ChartType.line
                ? _buildLineChart(data)
                : _buildBarChart(data),
      ),
    );
  }

  Widget _buildLineChart(List<ChartDataPoint> data) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: _calculateInterval(data),
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.grey[850]!, strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.grey[850]!, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: _calculateXInterval(data),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Transform.translate(
                      offset: const Offset(12, 0),
                      child: Transform.rotate(
                        angle: -1.57,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            data[index].displayDate,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: _calculateInterval(data),
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[300]!),
          ),
          minX: 0,
          maxX: (data.length).toDouble(),
          minY: 0,
          maxY: _calculateMaxY(data),
          lineBarsData: [
            LineChartBarData(
              spots:
                  data.asMap().entries.map((entry) {
                    return FlSpot(
                      entry.key.toDouble(),
                      entry.value.count.toDouble(),
                    );
                  }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    color: Colors.blue,
                    strokeWidth: 0.5,
                    strokeColor: Colors.blue,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final index = touchedSpot.x.toInt();
                  if (index >= 0 && index < data.length) {
                    return LineTooltipItem(
                      '${data[index].displayDate}\n${touchedSpot.y.toInt()} tests',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return null;
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<ChartDataPoint> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(data),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x.toInt()].displayDate}\n${rod.toY.toInt()} tests',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  if (data.length <= 30 || index % (data.length ~/ 10) == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Transform.rotate(
                        alignment: Alignment.bottomCenter,
                        angle: -1.5,
                        child: Text(
                          data[index].displayDate,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: _calculateInterval(data),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!),
        ),
        barGroups:
            data.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.count.toDouble(),
                    color: Colors.blue,
                    width: 6,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateInterval(data),
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[850]!, strokeWidth: 1);
          },
        ),
      ),
    );
  }

  List<ChartDataPoint> _processTestData() {
    final filteredTests = _getFilteredTests();
    if (filteredTests.isEmpty) return [];

    final int currentYear = DateTime.now().year;

    // FILTER TESTS → ONLY this year (2025)
    final testsThisYear = filteredTests.where((t) {
      final c = t.createdOn;
      return c != null && c.year == currentYear;
    }).toList();

    final Map<DateTime, int> groupedData = {};

    for (var test in testsThisYear) {
      final created = test.createdOn!;
      DateTime key;

      switch (_groupBy) {
        case GroupByPeriod.day:
          key = DateTime(created.year, created.month, created.day);
          break;

        case GroupByPeriod.week:
          final weekStart = created.subtract(Duration(days: created.weekday - 1));
          key = DateTime(weekStart.year, weekStart.month, weekStart.day);
          break;

        case GroupByPeriod.month:
          key = DateTime(created.year, created.month);
          break;
      }

      groupedData[key] = (groupedData[key] ?? 0) + 1;
    }

    // Sort by time
    final sorted = groupedData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sorted.map((entry) {
      return ChartDataPoint(
        date: entry.key,
        count: entry.value,
        displayDate: _formatForGroup(entry.key),
      );
    }).toList();
  }


  String _formatForGroup(DateTime d) {
    switch (_groupBy) {
      case GroupByPeriod.day:
        return "${_getMonthAbbr(d.month)} ${d.day}";
      case GroupByPeriod.week:
        return "W${d.day} ${_getMonthAbbr(d.month)}";
      case GroupByPeriod.month:
        return "${_getMonthAbbr(d.month)} ${d.year}";
    }
  }


  String _formatLabel(DateTime date) {
    switch (_groupBy) {
      case GroupByPeriod.day:
        return "${_getMonthAbbr(date.month)} ${date.day}";
      case GroupByPeriod.week:
        return "Wk ${date.day} ${_getMonthAbbr(date.month)}";
      case GroupByPeriod.month:
        return "${_getMonthAbbr(date.month)} ${date.year}";
    }
  }


  List<Test> _getFilteredTests() {
    if (_recordLimit == null || widget.tests.length <= _recordLimit!) {
      return widget.tests;
    }

    // Get the most recent tests
    final sortedTests = List<Test>.from(widget.tests)
      ..sort((a, b) => b.createdOn!.compareTo(a.createdOn!));

    return sortedTests.take(_recordLimit!).toList();
  }


  String _getMonthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // Map<String, dynamic> _calculateStats(List<ChartDataPoint> data) {
  //   if (data.isEmpty) {
  //     return {'total': 0, 'average': 0.0, 'peak': 0};
  //   }
  //
  //   final filteredTests = _getFilteredTests();
  //   final total = filteredTests.length;
  //   final average = total / data.length;
  //   final peak = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
  //
  //   return {'total': total, 'average': average, 'peak': peak};
  // }

  double _calculateMaxY(List<ChartDataPoint> data) {
    if (data.isEmpty) return 10;
    final max = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceilToDouble();
  }

  double _calculateInterval(List<ChartDataPoint> data) {
    if (data.isEmpty) return 1;
    final max = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    final interval = (max / 5).ceilToDouble();
    return interval;

  }

  double _calculateXInterval(List<ChartDataPoint> data) {
    if (data.length <= 10) return 1;
    return (data.length / 20).ceilToDouble();
  }
}

class ChartDataPoint {
  final DateTime date;
  final int count;
  final String displayDate;

  ChartDataPoint({
    required this.date,
    required this.count,
    required this.displayDate,
  });
}
