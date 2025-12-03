import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/models/test_model.dart';
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
  final AuthService _authService;
  final Databases databases;
  final PreferenceHelper prefs;
  List<Test> tests = [];

  DashboardCubit({
    AuthService? authService,
    Databases? databases,
    PreferenceHelper? prefs,
  }) : _authService = authService ?? AuthService(),
       databases = databases ?? Databases(locator<AppwriteService>().client),
       prefs = prefs ?? locator<PreferenceHelper>(),
       super(
         const DashboardState(
           userEmail: "",
           isSidebarOpen: false,
           childIndex: 0,
           organizationCount: 0,
           deviceCount: 0,
           motherCount: 0,
           testCount: 0,
           tests: [],
            referralCount: 0,
         ),
       ) {
    getUserData();
    fetchAllTests();
  }

  Future<void> getUserData() async {
    final userData = prefs.getUser();
    if (userData == null) return;

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
    );

    final referrals = await databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.testsCollectionId,
      queries: [Query.equal('referral', true)],
    );

    emit(
      state.copyWith(
        userEmail: user.email,
        organizationCount: orgCount.total,
        deviceCount: deviceCount.total,
        motherCount: motherCount.total,
        testCount: testCount.total,
        referralCount: referrals.total,
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
    context.pushReplacementNamed(AppRoutes.login);
  }

  Future<void> fetchAllTests() async {
    const int batchSize = 300;
    int offset = 0;

    List<Test> allTests = [];

      try {
        while (true) {
        final result = await databases.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.testsCollectionId,
          queries: [
            Query.limit(batchSize),
            Query.offset(offset),
          ],);
        final mapped = result.documents
            .map((doc) => Test.fromMap(doc.data, doc.$id))
            .toList();

        allTests.addAll(mapped);

        if (result.documents.length < batchSize) break;
        offset += batchSize;
        }

        print("Fetched raw tests: ${allTests.length}");

        // Filter invalid dates
        allTests = allTests.where((t) {
          return t.organizationName == 'Nelson Hospital';
        }).toList();

        print("Valid tests after filtering: ${allTests.length}");

        allTests.sort((a, b) => a.createdOn!.compareTo(b.createdOn!));

        emit(state.copyWith(tests: allTests));
      } catch (e, s) {
        print(s);
        print(e);
      }

  }
}
