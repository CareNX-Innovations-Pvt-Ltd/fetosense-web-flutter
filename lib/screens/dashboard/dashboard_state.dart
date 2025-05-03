part of 'dashboard_cubit.dart';

@immutable
class DashboardState {
  final String userEmail;
  final bool isSidebarOpen;
  final int childIndex;
  final int organizationCount;
  final int deviceCount;
  final int motherCount;
  final int testCount;

  const DashboardState({
    required this.userEmail,
    required this.isSidebarOpen,
    required this.childIndex,
    required this.organizationCount,
    required this.deviceCount,
    required this.motherCount,
    required this.testCount,
  });

  DashboardState copyWith({
    String? userEmail,
    bool? isSidebarOpen,
    int? childIndex,
    int? organizationCount,
    int? deviceCount,
    int? motherCount,
    int? testCount,
  }) {
    return DashboardState(
      userEmail: userEmail ?? this.userEmail,
      isSidebarOpen: isSidebarOpen ?? this.isSidebarOpen,
      childIndex: childIndex ?? this.childIndex,
      organizationCount: organizationCount ?? this.organizationCount,
      deviceCount: deviceCount ?? this.deviceCount,
      motherCount: motherCount ?? this.motherCount,
      testCount: testCount ?? this.testCount,
    );
  }
}
