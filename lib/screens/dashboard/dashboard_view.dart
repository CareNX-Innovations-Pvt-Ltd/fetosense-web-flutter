import 'package:fetosense_mis/core/models/models.dart';
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/screens/analytics/doctors_analytics.dart';
import 'package:fetosense_mis/screens/analytics/organizations_analytics.dart';
import 'package:fetosense_mis/screens/dashboard/widget/graph_card.dart';
import 'package:fetosense_mis/screens/device_details/device_details_view.dart';
import 'package:fetosense_mis/screens/device_registration/device_registration_view.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_view.dart';
import 'package:fetosense_mis/screens/generate_qr_page.dart';
import 'package:fetosense_mis/screens/mother_details/mother_details_view.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_view.dart';
import 'package:fetosense_mis/screens/organization_registration/organization_registration_view.dart';
import 'package:fetosense_mis/widget/appbar.dart';
import 'package:fetosense_mis/widget/bottom_navigation_bar.dart';
import 'package:fetosense_mis/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dashboard_cubit.dart';
import 'widget/hover_stat_card.dart';

/// The main dashboard screen widget.
///
/// Wraps the [DashboardView] with a [BlocProvider] and sets the initial child index.
class DashboardScreen extends StatelessWidget {
  /// The index of the child widget to display initially.
  final int childIndex;

  /// Creates a [DashboardScreen] with the given [childIndex].
  const DashboardScreen({super.key, required this.childIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit()..changeChildIndex(childIndex),
      child: const DashboardView(),
    );
  }
}

/// The main dashboard view widget.
///
/// Displays the dashboard UI and manages its state.
class DashboardView extends StatefulWidget {
  /// Creates a [DashboardView] widget.
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

/// State class for [DashboardView].
///
/// Handles sidebar animation, user preferences, and user model loading.
class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  /// Animation controller for the sidebar.
  late final AnimationController _sidebarAnimationController;

  /// Reference to the preferences helper.
  final prefs = locator<PreferenceHelper>();

  /// The current user model, if available.
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _sidebarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    userModel = prefs.getUser();
    debugPrint('UserModel: ${userModel?.toJson()}');
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        state.isSidebarOpen
            ? _sidebarAnimationController.forward()
            : _sidebarAnimationController.reverse();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: buildAppBar(
            () => context.read<DashboardCubit>().toggleSidebar(),
            state.userEmail,
            () => context.read<DashboardCubit>().logout(context),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          buildSidebar(
                            context,
                            () =>
                                context.read<DashboardCubit>().logout(context),
                          ),

                          const SizedBox(
                            width: 12,
                          ), // space between sidebar and content
                          Expanded(child: _getChild(state.childIndex, state)),
                        ],
                      ),
                    ),
                    const BottomNavBar(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getChild(int childIndex, DashboardState state) {
    switch (childIndex) {
      case 0:
        return Column(
          children: [_buildTopStats(state), Expanded(child: GraphCard())],
        );
      case 1:
        return const OrganizationRegistrationView();
      case 2:
        return const DeviceRegistration();
      case 3:
        return const GenerateQRPage();
      case 4:
        return const OrganizationDetailsPageView();
      case 5:
        return const DeviceDetailsView();
      case 6:
        return const DoctorDetailsView();
      case 7:
        return const MotherDetailsView();
      case 8:
        return const DoctorAnalyticsPage();
      case 9:
        return const OrganizationAnalyticsPage();
      default:
        return const Center(
          child: Text("Page not found", style: TextStyle(color: Colors.white)),
        );
    }
  }

  Widget _buildTopStats(DashboardState state) {
    final stats = _getDashboardStats(state);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) => HoverStatCard(stat: stat)).toList(),
      ),
    );
  }

  List<DashboardStat> _getDashboardStats(DashboardState state) {
    return [
      DashboardStat(
        icon: Icons.business,
        title: "Organizations",
        count: state.organizationCount.toString(),
      ),
      DashboardStat(
        icon: Icons.devices,
        title: "Devices",
        count: state.deviceCount.toString(),
      ),
      DashboardStat(
        icon: Icons.pregnant_woman,
        title: "Mothers",
        count: state.motherCount.toString(),
      ),
      DashboardStat(
        icon: Icons.monitor_heart,
        title: "Tests",
        count: state.testCount.toString(),
      ),
    ];
  }
}
