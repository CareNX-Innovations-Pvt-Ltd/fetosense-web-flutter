// // File: dashboard_screen.dart
//
// import 'package:fetosense_mis/core/models/models.dart';
// import 'package:fetosense_mis/core/services/auth_service.dart';
// import 'package:fetosense_mis/screens/device_details/device_details_view.dart';
// import 'package:fetosense_mis/screens/doctor_details/doctor_details_view.dart';
// import 'package:fetosense_mis/screens/mother_details/mother_details_view.dart';
// import 'package:fetosense_mis/screens/organization_details/organization_details_view.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import 'package:fetosense_mis/core/network/appwrite_config.dart';
// import 'package:fetosense_mis/core/network/dependency_injection.dart';
// import 'package:fetosense_mis/core/utils/app_routes.dart';
//
// import '../widget/appbar.dart';
// import '../widget/bottom_navigation_bar.dart';
// import 'device_registration/device_registration_view.dart';
// import 'organization_registration/organization_registration_view.dart';
// import '../widget/sidebar.dart';
//
// import 'analytics/doctors_analytics.dart';
// import 'analytics/organizations_analytics.dart';
// import 'generate_qr_page.dart';
//
// class DashboardScreen extends StatefulWidget {
//   final int childIndex;
//
//   const DashboardScreen({super.key, required this.childIndex});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen>
//     with SingleTickerProviderStateMixin {
//   final AuthService _authService = AuthService();
//   final client = locator<AppwriteService>().client;
//   late final AnimationController _sidebarAnimationController;
//
//   String userEmail = "";
//   bool isSidebarOpen = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//
//     _sidebarAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
//
//   @override
//   void dispose() {
//     _sidebarAnimationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _getUserData() async {
//     final user = await _authService.getCurrentUser();
//     setState(() {
//       userEmail = user.email;
//     });
//     // locator<PreferenceHelper>().saveUser(user);
//   }
//
//   void _toggleSidebar() {
//     setState(() {
//       isSidebarOpen = !isSidebarOpen;
//       isSidebarOpen
//           ? _sidebarAnimationController.forward()
//           : _sidebarAnimationController.reverse();
//     });
//   }
//
//   Future<void> _logout() async {
//     await _authService.logoutUser();
//     if (mounted) {
//       context.go(AppRoutes.login);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: buildAppBar(_toggleSidebar, userEmail),
//       body: Column(
//         children: [
//           Expanded(
//             child: Row(
//               children: [
//                 SizeTransition(
//                   sizeFactor: _sidebarAnimationController,
//                   axis: Axis.horizontal,
//                   child: buildSidebar(context, _logout),
//                 ),
//                 Expanded(child: _getChild(widget.childIndex)),
//               ],
//             ),
//           ),
//           const BottomNavBar(),
//         ],
//       ),
//     );
//   }
//
//   Widget _getChild(int childIndex) {
//     switch (childIndex) {
//       case 0:
//         return Column(
//           children: [_buildTopStats(), Expanded(child: _buildGraphSection())],
//         );
//       case 1:
//         return const OrganizationRegistrationView();
//       case 2:
//         return const DeviceRegistration();
//       case 3:
//         return const GenerateQRPage();
//       case 4:
//         return const OrganizationDetailsPageView();
//       case 5:
//         return const DeviceDetailsView();
//       case 6:
//         return const DoctorDetailsView();
//       case 7:
//         return const MotherDetailsView();
//       case 8:
//         return const DoctorAnalyticsPage();
//       case 9:
//         return const OrganizationAnalyticsPage();
//       default:
//         return const Center(
//           child: Text("Page not found", style: TextStyle(color: Colors.white)),
//         );
//     }
//   }
//
//   Widget _buildTopStats() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Colors.black54,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: dashboardStats.map((stat) => _statCard(stat)).toList(),
//       ),
//     );
//   }
//
//   Widget _statCard(DashboardStat stat) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade900,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Icon(stat.icon, color: Colors.tealAccent, size: 36),
//           const SizedBox(height: 10),
//           Text(
//             stat.title,
//             style: const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             stat.count,
//             style: const TextStyle(
//               color: Colors.tealAccent,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGraphSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: LineChart(
//         LineChartData(
//           gridData: const FlGridData(show: false),
//           titlesData: const FlTitlesData(show: false),
//           borderData: FlBorderData(show: false),
//           lineBarsData: [
//             LineChartBarData(
//               spots: const [
//                 FlSpot(0, 200),
//                 FlSpot(1, 350),
//                 FlSpot(2, 270),
//                 FlSpot(3, 310),
//                 FlSpot(4, 290),
//                 FlSpot(5, 340),
//                 FlSpot(6, 380),
//                 FlSpot(7, 330),
//                 FlSpot(8, 360),
//                 FlSpot(9, 390),
//               ],
//               isCurved: true,
//               gradient: const LinearGradient(
//                 colors: [Colors.tealAccent, Colors.blueAccent],
//               ),
//               barWidth: 3,
//               dotData: const FlDotData(show: false),
//               belowBarData: BarAreaData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
