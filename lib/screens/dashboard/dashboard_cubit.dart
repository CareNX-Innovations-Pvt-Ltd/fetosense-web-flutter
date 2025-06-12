import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AuthService _authService = AuthService();
  final client = locator<AppwriteService>().client;

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

  Future<void> getUserData() async {
    Databases databases = Databases(client);
    final user = await _authService.getCurrentUser();
    final orgCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: [Query.equal('type', 'organization')],
    );
    final deviceCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.deviceCollectionId,
    );
    final motherCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: [Query.equal('type', 'mother')],
    );
    final testCount = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.testsCollectionId,
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
