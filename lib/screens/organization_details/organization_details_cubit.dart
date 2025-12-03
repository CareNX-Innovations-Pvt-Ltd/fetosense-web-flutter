import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/models/org_details_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

part 'organization_details_state.dart';

/// Cubit for managing the state and logic of the organization details screen.
///
/// Handles fetching organization details, including device, mother, and test counts for each organization.
/// Also manages Excel export and date filtering.
class OrganizationCubit extends Cubit<OrganizationState> {
  /// Appwrite [Databases] instance for organization data operations.
  final Databases db = Databases(locator<AppwriteService>().client);
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void setSelectedState(String? stateName) {
    emit(state.copyWith(selectedState: stateName, selectedCity: null));
  }

  void setSelectedCity(String? cityName) {
    emit(state.copyWith(selectedCity: cityName));
  }

  void setSelectedType(String? type) {
    emit(state.copyWith(selectedType: type));
  }

  void setSelectedDesignation(String? designation) {
    emit(state.copyWith(selectedDesignation: designation));
  }

  /// The [BuildContext] used for showing snackbars and dialogs.
  final BuildContext context;

  void initializeOrganizationFields(Map<String, dynamic> data) {
    nameController = TextEditingController(
      text: data['organizationName'] ?? '',
    );
    contactPersonController = TextEditingController(
      text: data['contactPerson'] ?? '',
    );
    mobileController = TextEditingController(
      text: data['mobileNo']?.toString() ?? '',
    );
    emailController = TextEditingController(text: data['email'] ?? '');
    addressController = TextEditingController(text: data['addressLine'] ?? '');

    emit(
      state.copyWith(
        selectedType:
            ['sold', 'demo', 'testing'].contains(data['status'])
                ? data['status']
                : null,
        selectedDesignation:
            ['Admin', 'Staff'].contains(data['designation'])
                ? data['designation']
                : null,
        selectedCity: data['city'],
        selectedState: data['state'],
      ),
    );
  }

  /// Creates an [OrganizationCubit] and initializes the state and data.
  OrganizationCubit({required this.context}) : super(const OrganizationState()) {
    fetchOrganizationDetails();
    computeDeviceStats();
  }

  /// Fetches organizations from the database based on the date range.
  ///
  /// Updates the state with a list of [OrganizationDetailsModel] containing counts for devices, mothers, and tests.
  Future<void> fetchOrganizationDetails() async {
    emit(state.copyWith(status: OrganizationStatus.loading));

    try {
      // First, fetch all organizations
      final organizations = await _fetchOrganizationsFromDb(
        fromDate: state.fromDate,
        tillDate: state.tillDate,
      );

      // Create a list to store all organization details
      final List<OrganizationDetailsModel> organizationDetails = [];

      // For each organization, fetch the counts from other collections
      for (final org in organizations) {
        final String orgId = org.data['organizationName'] ?? '';

        // Fetch counts for this organization from different collections
        final deviceCount = await _getDeviceCount(orgId);
        final motherCount = await _getMotherCount(orgId);
        final testCount = await _getTestCount(orgId);
        final doctorCount = await _getDoctorCount(orgId);

        // Create an OrganizationDetailsModel for this organization
        organizationDetails.add(
          OrganizationDetailsModel(
            organizations: [org],
            deviceCount: deviceCount,
            motherCount: motherCount,
            testCount: testCount,
            doctorCount: doctorCount,
          ),
        );
      }

      emit(
        state.copyWith(
          organizationDetails: organizationDetails,
          filteredOrganizationDetails: organizationDetails,
          status: OrganizationStatus.loaded,
          clearError: true,
        ),
      );

      applySearchFilter();
    } catch (e) {
      emit(
        state.copyWith(
          status: OrganizationStatus.error,
          errorMessage: "Error fetching organization details: $e",
        ),
      );
    }
  }

  /// Fetches the count of devices for a specific organization
  Future<int> _getDeviceCount(String organizationId) async {
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.deviceCollectionId,
        queries: [Query.equal('organizationId', organizationId)],
      );
      return result.total;
    } catch (e) {
      debugPrint('Error fetching device count: $e');
      return 0;
    }
  }

  /// Fetches the count of mothers for a specific organization
  Future<int> _getMotherCount(String organizationId) async {
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [
          Query.equal('organizationId', organizationId),
          Query.equal('type', 'mother'),
        ],
      );
      return result.total;
    } catch (e) {
      debugPrint('Error fetching mother count: $e');
      return 0;
    }
  }

  /// Fetches the count of mothers for a specific organization
  Future<int> _getDoctorCount(String organizationId) async {
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [
          Query.equal('organizationName', organizationId),
          Query.equal('type', 'doctor'),
        ],
      );
      return result.total;
    } catch (e) {
      debugPrint('Error fetching mother count: $e');
      return 0;
    }
  }

  /// Fetches the count of tests for a specific organization
  Future<int> _getTestCount(String organizationId) async {
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.testsCollectionId,
        queries: [Query.equal('organizationId', organizationId)],
      );
      return result.total;
    } catch (e) {
      debugPrint('Error fetching test count: $e');
      return 0;
    }
  }

  /// Handles the database query to fetch organizations.
  Future<List<models.Document>> _fetchOrganizationsFromDb({
    DateTime? fromDate,
    DateTime? tillDate,
  }) async {
    try {
      final List<String> queries = [Query.equal('type', 'organization')];

      final bool applyDateFilter = fromDate != null || tillDate != null;

      if (applyDateFilter) {
        queries.add(Query.isNotNull('createdOn'));

        if (fromDate != null) {
          queries.add(
            Query.greaterThanEqual('createdOn', fromDate.toIso8601String()),
          );
        }

        if (tillDate != null) {
          final tillDateEnd = DateTime(
            tillDate.year,
            tillDate.month,
            tillDate.day,
            23,
            59,
            59,
          );
          queries.add(
            Query.lessThanEqual('createdOn', tillDateEnd.toIso8601String()),
          );
        }
      }

      // Query the database for organization documents
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: queries,
      );

      return result.documents;
    } catch (e) {
      debugPrint('Error fetching organizations: $e');
      return [];
    }
  }

  /// Updates the search query and applies the filter.
  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    applySearchFilter();
  }

  /// Filters organizations based on the search query.
  void applySearchFilter() {
    final keyword = state.searchQuery.trim().toLowerCase();

    if (keyword.isEmpty) {
      emit(
        state.copyWith(filteredOrganizationDetails: state.organizationDetails),
      );
    } else {
      final filtered =
          state.organizationDetails.where((orgDetail) {
            if (orgDetail.organizations.isEmpty) return false;

            final org = orgDetail.organizations.first;
            final name =
                org.data['organizationName']?.toString().toLowerCase() ?? '';
            return name.contains(keyword);
          }).toList();

      emit(state.copyWith(filteredOrganizationDetails: filtered));
    }
  }

  /// Sets the from date for filtering.
  void setFromDate(DateTime? date) {
    emit(state.copyWith(fromDate: date, clearFromDate: date == null));
  }

  /// Sets the till date for filtering.
  void setTillDate(DateTime? date) {
    emit(state.copyWith(tillDate: date, clearTillDate: date == null));
  }

  /// Downloads the filtered organizations data in Excel format.
  Future<void> downloadExcel() async {
    try {
      // Convert the list of OrganizationDetailsModel to a format suitable for Excel export
      final List<Map<String, dynamic>> exportData = [];

      for (final orgDetail in state.filteredOrganizationDetails) {
        if (orgDetail.organizations.isEmpty) continue;

        final org = orgDetail.organizations.first;

        exportData.add({
          'Organization ID': org.$id,
          'Organization Name': org.data['organizationName'] ?? 'Unknown',
          'Device Count': orgDetail.deviceCount,
          'Mother Count': orgDetail.motherCount,
          'Test Count': orgDetail.testCount,
          'Created On': org.data['createdOn'] ?? 'Unknown',
          // Add more fields as needed
        });
      }

      await ExcelExportService.exportOrganizationsToExcel(
        context,
        state.organizationDetails,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
    }
  }

  /// Updates organization details in the database.
  Future<void> updateChanges(String documentId) async {
    try {
      final updatedData = {
        'organizationName': nameController.text.trim(),
        'status': state.selectedType,
        'contactPerson': contactPersonController.text.trim(),
        'designation': state.selectedDesignation,
        'mobileNo': int.parse(mobileController.text.toString()),

        'email': emailController.text.trim(),
        'addressLine': addressController.text.trim(),
        'state': state.selectedState,
        'city': state.selectedCity,
      };

      await db.updateDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        documentId: documentId,
        data: updatedData,
      );

      emit(state.copyWith(organizationDetails: state.organizationDetails));

      if (context.mounted) {}
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    contactPersonController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    return super.close();
  }

  /// Computes statistics for devices, mothers, doctors, and tests per organization.
  Future<void> computeDeviceStats() async {
    final testResult = await db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.testsCollectionId,
    );

    final Map<String, int> testsPerOrg = {};

    for (var doc in testResult.documents) {
      final data = doc.data;
      final orgId = data['organizationId'];

      if (orgId == null || orgId.isEmpty) continue;

      testsPerOrg[orgId] = (testsPerOrg[orgId] ?? 0) + 1;
    }

    final motherResult = await db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: [Query.equal('type', 'mother')],
    );

    final Map<String, int> mothersPerOrg = {};

    for (var doc in motherResult.documents) {
      final data = doc.data;
      final orgId = data['organizationId'];

      if (orgId == null || orgId.isEmpty) continue;

      mothersPerOrg[orgId] = (mothersPerOrg[orgId] ?? 0) + 1;
    }

    final doctorResult = await db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: [Query.equal('type', 'doctor')],
    );

    final Map<String, int> doctorsPerOrg = {};

    for (var doc in doctorResult.documents) {
      final data = doc.data;
      final orgId = data['organizationId'];

      if (orgId == null || orgId.isEmpty) continue;

      doctorsPerOrg[orgId] = (doctorsPerOrg[orgId] ?? 0) + 1;
    }

    final deviceResult = await db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.deviceCollectionId,
    );

    final Map<String, int> devicesPerOrg = {};

    for (var doc in deviceResult.documents) {
      final data = doc.data;
      final orgId = data['organizationId'];

      if (orgId == null || orgId.isEmpty) continue;

      devicesPerOrg[orgId] = (devicesPerOrg[orgId] ?? 0) + 1;
    }
    emit(
      state.copyWith(
        testsPerOrg: testsPerOrg,
        mothersPerOrg: mothersPerOrg,
        doctorsPerOrg: doctorsPerOrg,
        devicesPerOrg: devicesPerOrg,
      ),
    );
  }
}
