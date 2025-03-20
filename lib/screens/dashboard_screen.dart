import 'package:flutter/material.dart';
import 'organization_registration.dart';
import 'sidebar.dart';
import 'appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';
import 'package:appwrite/appwrite.dart';

class DashboardScreen extends StatefulWidget {
  final Client client;
  final int childIndex;

  const DashboardScreen({
    super.key,
    required this.client,
    required this.childIndex,
  });

  @override
  State createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late AuthService _authService;
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.client);
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      setState(() {
        userEmail = user.email;
      });
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  void _logout() async {
    await _authService.logoutUser();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: buildAppBar(
        userEmail,
        _logout,
      ), // AppBar imported from appbar.dart
      body: Row(
        children: [
          buildSidebar(context, _logout), // Sidebar imported from sidebar.dart
          getChild(widget.childIndex),
        ],
      ),
    );
  }

  Widget _buildTopStats() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCard(Icons.business, "Organizations", "1"),
          _statCard(Icons.devices, "Devices", "4"),
          _statCard(Icons.pregnant_woman, "Mothers", "4121"),
          _statCard(Icons.monitor_heart, "Tests", "5538"),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String count) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 36),
          SizedBox(height: 10),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 5),
          Text(
            count,
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 200),
                FlSpot(1, 350),
                FlSpot(2, 270),
                FlSpot(3, 310),
                FlSpot(4, 290),
                FlSpot(5, 340),
                FlSpot(6, 380),
                FlSpot(7, 330),
                FlSpot(8, 360),
                FlSpot(9, 390),
              ],
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.tealAccent, Colors.blueAccent],
              ),
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget getChild(int childIndex) {
    switch (childIndex) {
      case 0:
        return Expanded(
          child: Column(
            children: [_buildTopStats(), Expanded(child: _buildGraphSection())],
          ),
        );
      default:
        return OrganizationRegistration();
    }
  }
}
