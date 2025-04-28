// File: dashboard_stats_model.dart

import 'package:flutter/material.dart';

class DashboardStat {
  final IconData icon;
  final String title;
  final String count;

  DashboardStat({
    required this.icon,
    required this.title,
    required this.count,
  });
}

// Mocked list for now (you can replace later with real API data)
final List<DashboardStat> dashboardStats = [
  DashboardStat(icon: Icons.business, title: "Organizations", count: "1"),
  DashboardStat(icon: Icons.devices, title: "Devices", count: "4"),
  DashboardStat(icon: Icons.pregnant_woman, title: "Mothers", count: "4121"),
  DashboardStat(icon: Icons.monitor_heart, title: "Tests", count: "5538"),
];
