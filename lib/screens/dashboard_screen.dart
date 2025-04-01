import 'package:flutter/material.dart';
import 'device_details_page.dart';
import 'doctors_detail_page.dart';
import 'generate_qr_page.dart';
import 'mothers_details_page.dart';
import 'organization_edit_page.dart';
import 'organization_registration.dart';
import 'device_registration.dart';
import 'sidebar.dart';
import 'appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';
import 'package:appwrite/appwrite.dart';
import 'bottom_navigation_bar.dart';
import 'organization_details_page.dart';

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
  bool isSidebarOpen = true;

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
      setState(() {
        userEmail = 'Error';
      });
    }
  }

  void _toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  void _logout() async {
    await _authService.logoutUser();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: buildAppBar(_toggleSidebar, userEmail),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (isSidebarOpen) buildSidebar(context, _logout),
                Expanded(child: getChild(widget.childIndex)),
              ],
            ),
          ),
          const BottomNavBar(),
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
    if (childIndex == 0) {
      return Column(
        children: [_buildTopStats(), Expanded(child: _buildGraphSection())],
      );
    } else if (childIndex == 1) {
      return OrganizationRegistration(client: widget.client);
    } else if (childIndex == 2) {
      return DeviceRegistration(client: widget.client);
    } else if (childIndex == 3) {
      return const GenerateQRPage();
    } else if (childIndex == 4) {
      return OrganizationDetailsPage(client: widget.client); // ✅ Correct
    } else if (childIndex == 5) {
      return DeviceDetailsPage(client: widget.client); // ✅ Correct
    } else if (childIndex == 6) {
      return DoctorDetailsPage(client: widget.client); // ✅ Correct
    } else if (childIndex == 7) {
      return MotherDetailsPage(client: widget.client); // ✅ Correct
    } else {
      return const Center(
        child: Text("Page not found", style: TextStyle(color: Colors.white)),
      );
    }
  }
}
