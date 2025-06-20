import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'dashboard_state.dart';

/// Cubit for managing the state of the dashboard screen.
///
/// Handles user data retrieval, sidebar state, and dashboard statistics such as organization,
/// device, mother, and test counts. Uses Appwrite for backend data and supports role-based access.
class DashboardCubit extends Cubit<DashboardState> {
  /// Service for authentication and user management.
  final AuthService _authService = AuthService();

  /// Appwrite client instance for API calls.
  final client = locator<AppwriteService>().client;

  /// Helper for accessing user preferences.
  final prefs = locator<PreferenceHelper>();

  /// Creates a [DashboardCubit] and initializes user data.
  DashboardCubit()
    : super(
        const DashboardState(
          userEmail: "",
          isSidebarOpen: false,
          childIndex: 0,
          organizationCount: 0,
          deviceCount: 0,
          motherCount: 0,
          testCount: 0,
        ),
      ) {
    getUserData();
  }

  /// Fetches user data and dashboard statistics from Appwrite.
  ///
  /// Updates the state with user email and counts for organizations, devices, mothers, and tests.
  Future<void> getUserData() async {
    final userData = prefs.getUser();

    if (userData == null) return;

    final databases = Databases(client);
    final user = await _authService.getCurrentUser();
    final isRestricted = userData.role != UserRoles.admin;

    List<String> buildQueries(String type) {
      final queries = <String>[];
      if (type.isNotEmpty) queries.add(Query.equal('type', type));
      if (isRestricted) {
        queries.add(Query.equal('organizationId', userData.organizationId));
      }
      return queries;
    }

    final orgCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: buildQueries('organization'),
    );

    final deviceCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.deviceCollectionId,
    );

    final motherCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: buildQueries('mother'),
    );

    final testCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.testsCollectionId,
      queries:
          isRestricted
              ? [Query.equal('organizationId', userData.organizationId)]
              : [],
    );

    emit(
      state.copyWith(
        userEmail: user.email,
        organizationCount: orgCount.total,
        deviceCount: deviceCount.total,
        motherCount: motherCount.total,
        testCount: testCount.total,
      ),
    );
  }

  void toggleSidebar() {
    emit(state.copyWith(isSidebarOpen: !state.isSidebarOpen));
  }

  void changeChildIndex(int index) {
    emit(state.copyWith(childIndex: index));
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logoutUser();
    context.go(AppRoutes.login);
  }
}
