part of 'dashboard_cubit.dart';

/// State class for the dashboard screen.
///
/// Holds user email, sidebar state, selected child index, and statistics for organizations,
/// devices, mothers, and tests. Used by [DashboardCubit] to manage dashboard UI state.
@immutable
class DashboardState {
  /// The email address of the current user.
  final String userEmail;

  /// Whether the sidebar is open.
  final bool isSidebarOpen;

  /// The index of the currently selected child widget.
  final int childIndex;

  /// The number of organizations.
  final int organizationCount;

  /// The number of devices.
  final int deviceCount;

  /// The number of mothers.
  final int motherCount;

  /// The number of tests.
  final int testCount;

  /// The number of referrals.
  final int referralCount;

  /// The list of tests.
  final List<Test> tests;

  /// Creates a [DashboardState] with the given values.
  const DashboardState({
    required this.userEmail,
    required this.isSidebarOpen,
    required this.childIndex,
    required this.organizationCount,
    required this.deviceCount,
    required this.motherCount,
    required this.testCount,
    required this.tests,
    required this.referralCount,
  });

  /// Returns a copy of this state with updated fields if provided.
  DashboardState copyWith({
    String? userEmail,
    bool? isSidebarOpen,
    int? childIndex,
    int? organizationCount,
    int? deviceCount,
    int? motherCount,
    int? testCount,
    List<Test>? tests,
    int? referralCount,
  }) {
    return DashboardState(
      userEmail: userEmail ?? this.userEmail,
      isSidebarOpen: isSidebarOpen ?? this.isSidebarOpen,
      childIndex: childIndex ?? this.childIndex,
      organizationCount: organizationCount ?? this.organizationCount,
      deviceCount: deviceCount ?? this.deviceCount,
      motherCount: motherCount ?? this.motherCount,
      testCount: testCount ?? this.testCount,
      tests: tests ?? this.tests,
      referralCount: referralCount ?? this.referralCount,
    );
  }
}
