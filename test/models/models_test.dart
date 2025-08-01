import 'package:fetosense_mis/core/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardStat', () {
    test('should create a valid DashboardStat instance', () {
      const icon = Icons.devices;
      const title = "Devices";
      const count = "4";

      final stat = DashboardStat(icon: icon, title: title, count: count);

      expect(stat.icon, icon);
      expect(stat.title, title);
      expect(stat.count, count);
    });

    test('copyWith returns a new object with overridden values', () {
      final original = DashboardStat(
        icon: Icons.devices,
        title: "Devices",
        count: "4",
      );

      final updated = original.copyWith(title: "Updated Devices", count: "10");

      expect(updated.icon, original.icon); // not overridden
      expect(updated.title, "Updated Devices");
      expect(updated.count, "10");
      expect(updated, isNot(same(original))); // different instance
    });

    test('copyWith returns identical object when no params passed', () {
      final original = DashboardStat(
        icon: Icons.business,
        title: "Organizations",
        count: "1",
      );

      final copy = original.copyWith();

      expect(copy.icon, original.icon);
      expect(copy.title, original.title);
      expect(copy.count, original.count);
      expect(copy, isNot(same(original))); // different instance
    });
  });

  group('dashboardStats mock list', () {
    test('should contain 4 default DashboardStat entries', () {
      expect(dashboardStats.length, 4);

      expect(dashboardStats[0].title, "Organizations");
      expect(dashboardStats[1].title, "Devices");
      expect(dashboardStats[2].title, "Mothers");
      expect(dashboardStats[3].title, "Tests");
    });

    test('each DashboardStat should have non-empty fields', () {
      for (var stat in dashboardStats) {
        expect(stat.icon, isA<IconData>());
        expect(stat.title, isNotEmpty);
        expect(stat.count, isNotEmpty);
      }
    });
  });
}
