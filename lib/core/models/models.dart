// File: dashboard_stats_model.dart

import 'package:flutter/material.dart';

/// Model representing a dashboard statistic item.
///
/// Each [DashboardStat] contains an [icon], a [title], and a [count] value to display on the dashboard.
class DashboardStat {
  /// The icon representing the statistic.
  final IconData icon;

  /// The title or label of the statistic.
  final String title;

  /// The count or value of the statistic.
  final String count;

  /// Creates a [DashboardStat] with the given [icon], [title], and [count].
  DashboardStat({required this.icon, required this.title, required this.count});

  /// Returns a copy of this [DashboardStat] with optional new values for its fields.
  ///
  /// If a parameter is not provided, the current value is used.
  DashboardStat copyWith({IconData? icon, String? title, String? count}) {
    return DashboardStat(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      count: count ?? this.count,
    );
  }
}

/// Mocked list of dashboard statistics for demonstration purposes.
///
/// Replace with real API data as needed.
final List<DashboardStat> dashboardStats = [
  DashboardStat(icon: Icons.business, title: "Organizations", count: "1"),
  DashboardStat(icon: Icons.devices, title: "Devices", count: "4"),
  DashboardStat(icon: Icons.pregnant_woman, title: "Mothers", count: "4121"),
  DashboardStat(icon: Icons.monitor_heart, title: "Tests", count: "5538"),
];
