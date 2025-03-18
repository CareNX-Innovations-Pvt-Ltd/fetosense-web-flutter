// import 'package:flutter/material.dart';
// import 'package:appwrite/appwrite.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../services/auth_service.dart';
//
// class HomeScreen extends StatefulWidget {
//   final Client client;
//
//   HomeScreen({required this.client});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late AuthService _authService;
//   String userEmail = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _authService = AuthService(widget.client);
//     _getUserData();
//   }
//
//   Future<void> _getUserData() async {
//     try {
//       final user = await _authService.getCurrentUser();
//       setState(() {
//         userEmail = user.email;
//       });
//     } catch (e) {
//       print("Error fetching user: $e");
//     }
//   }
//
//   void _logout() async {
//     await _authService.logoutUser();
//     Navigator.pushReplacementNamed(context, '/');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: Row(
//         children: [
//           _buildSidebar(),
//           Expanded(
//             child: Column(
//               children: [
//                 _buildTopStats(),
//                 Expanded(child: _buildGraphSection()),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebar() {
//     return Container(
//       width: 250,
//       color: Colors.grey[850],
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               "fetosense",
//               style: TextStyle(
//                 color: Colors.tealAccent,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//
//           _sidebarItem(
//             Icons.dashboard,
//             "Dashboard",
//             onTap: () {
//               Navigator.pushNamed(context, '/home');
//             },
//           ),
//
//           _buildExpandableMenu(Icons.app_registration, "Registration", [
//             _sidebarSubItem("Organization", '/organization-registration'),
//             _sidebarSubItem("Device", '/device-registration'),
//             _sidebarSubItem("Generate QR", '/generate-qr'),
//           ]),
//           _buildExpandableMenu(Icons.pie_chart, "MIS", [
//             _sidebarSubItem("Organizations", '/mis-organizations'),
//             _sidebarSubItem("Device", '/mis-devices'),
//             _sidebarSubItem("Doctor", '/mis-doctors'),
//             _sidebarSubItem("Mother", '/mis-mothers'),
//             _sidebarSubItem("Test", '/mis-tests'),
//           ]),
//
//           _sidebarItem(Icons.analytics, "Analytics"),
//           _sidebarItem(Icons.article, "Reports"),
//           _sidebarItem(Icons.settings, "Operations"),
//           _sidebarItem(Icons.people, "Users"),
//
//           Spacer(),
//           _sidebarItem(Icons.logout, "Logout", onTap: _logout),
//         ],
//       ),
//     );
//   }
//
//   Widget _sidebarItem(IconData icon, String title, {VoidCallback? onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(title, style: TextStyle(color: Colors.white)),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildTopStats() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       color: Colors.black54,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _statCard(Icons.business, "Organizations", "1"),
//           _statCard(Icons.devices, "Devices", "4"),
//           _statCard(Icons.pregnant_woman, "Mothers", "4121"),
//           _statCard(Icons.monitor_heart, "Tests", "5538"),
//         ],
//       ),
//     );
//   }
//
//   Widget _statCard(IconData icon, String title, String count) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade900,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.tealAccent, size: 36),
//           SizedBox(height: 10),
//           Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
//           SizedBox(height: 5),
//           Text(
//             count,
//             style: TextStyle(
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
//       padding: EdgeInsets.all(16),
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(show: false),
//           titlesData: FlTitlesData(show: false),
//           borderData: FlBorderData(show: false),
//           lineBarsData: [
//             LineChartBarData(
//               spots: [
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
//               gradient: LinearGradient(
//                 colors: [Colors.tealAccent, Colors.blueAccent],
//               ), // ✅ Correct way
//               barWidth: 3,
//               dotData: FlDotData(show: false),
//               belowBarData: BarAreaData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExpandableMenu(
//     IconData icon,
//     String title,
//     List<Widget> children,
//   ) {
//     return Theme(
//       data: ThemeData().copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         leading: Icon(icon, color: Colors.white),
//         title: Text(title, style: TextStyle(color: Colors.white)),
//         children: children,
//       ),
//     );
//   }
//
//   Widget _sidebarSubItem(String title, String route) {
//     return ListTile(
//       title: Text(title, style: TextStyle(color: Colors.white)),
//       onTap: () {
//         Navigator.pushNamed(context, route);
//       },
//     );
//   }
// }
