import 'package:bloc/bloc.dart';
import 'package:appwrite/models.dart' as models;
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

part 'doctor_details_state.dart';

/// Cubit for managing the state and logic of the doctor details screen.
///
/// Handles fetching, filtering, and searching doctor data from Appwrite,
/// as well as updating date filters and managing loading/error states.
class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  /// Appwrite [Databases] instance for doctor data operations.
  final Databases db = Databases(locator<AppwriteService>().client);

  /// Creates a [DoctorDetailsCubit] and initializes the state + data.
  DoctorDetailsCubit() : super(DoctorDetailsState.initial()) {
    fetchDoctorDetails();
  }

  /// Sets the from date for filtering.
  void setFromDate(DateTime? date) {
    emit(state.copyWith(
      fromDate: date,
      clearFromDate: date == null,
      overrideFromDate: true,
    ));
  }

  /// Sets the till date for filtering.
  void setTillDate(DateTime? date) {
    emit(state.copyWith(
      tillDate: date,
      clearTillDate: date == null,
      overrideTillDate: true,
    ));
  }

  void clearAllFilters() {
    emit(state.copyWith(
      fromDate: null,
      tillDate: null,
      clearFromDate: true,
      clearTillDate: true,
      overrideFromDate: true,
      overrideTillDate: true,
    ));

    fetchDoctorDetails();
  }


  /// Updates the search query and reapplies the filter.
  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    applySearchFilter();
  }

  /// Applies the search filter on doctor name, email, or organization.
  void applySearchFilter() {
    final keyword = state.searchQuery.trim().toLowerCase();

    if (keyword.isEmpty) {
      emit(state.copyWith(filteredDoctors: state.doctorDetails));
    } else {
      final filtered = state.doctorDetails.where((doc) {
        final data = doc.data;
        final name = data['name']?.toString().toLowerCase() ?? '';
        final email = data['email']?.toString().toLowerCase() ?? '';
        final org = data['organizationName']?.toString().toLowerCase() ?? '';
        return name.contains(keyword) ||
            email.contains(keyword) ||
            org.contains(keyword);
      }).toList();

      emit(state.copyWith(filteredDoctors: filtered));
    }
  }

  /// Fetches doctors based on date filters and enriches each with mother/test counts.
  Future<void> fetchDoctorDetails() async {
    emit(state.copyWith(status: DoctorStatus.loading));

    try {
      // Fetch doctors from the database
      print('start fetchDoctorDetails with fromDate: ${state.fromDate}, tillDate: ${state.tillDate}');
      final doctors = await _fetchDoctorsFromDb(
        fromDate: state.fromDate,
        tillDate: state.tillDate,
      );

      // Create enriched doctor list
      final List<models.Document> enrichedDoctors = [];

      for (final doc in doctors) {
        final doctorId = doc.$id;

        // Fetch counts for this doctor
        final motherCount = await _getMotherCount(doctorId);
        final testCount = await _getTestCount(doctorId);

        // Merge original data + computed counts
        final updatedData = Map<String, dynamic>.from(doc.data)
          ..['noOfMother'] = motherCount
          ..['noOfTests'] = testCount;

        enrichedDoctors.add(
          models.Document(
            $id: doc.$id,
            $collectionId: doc.$collectionId,
            $databaseId: doc.$databaseId,
            $createdAt: doc.$createdAt,
            $updatedAt: doc.$updatedAt,
            data: updatedData,
            $permissions: doc.$permissions,
          ),
        );
      }

      // Emit updated state
      emit(
        state.copyWith(
          doctorDetails: enrichedDoctors,
          filteredDoctors: enrichedDoctors,
          status: DoctorStatus.loaded,
          clearError: true,
        ),
      );

      applySearchFilter();
    } catch (e) {
      emit(
        state.copyWith(
          status: DoctorStatus.error,
          errorMessage: "Error fetching doctor details: $e",
        ),
      );
    }
  }

  /// Fetches doctor documents from Appwrite.
  /// Fetches doctor documents from Appwrite and applies date filtering locally.
  /// This avoids server-side field name mismatches (e.g. some docs use `createdOn`,
  /// others rely on Appwrite's system `$createdAt`).
  Future<List<models.Document>> _fetchDoctorsFromDb({
    DateTime? fromDate,
    DateTime? tillDate,
  }) async {
    try {
      // Basic server-side query only for type == 'doctor'
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [Query.equal('type', 'doctor')],
      );

      final docs = result.documents;

      // If no date filters, return all fetched docs immediately
      if (fromDate == null && tillDate == null) {
        return docs;
      }

      // Prepare range: fromDate -> inclusive at 00:00:00, tillDate -> inclusive end of day
      final DateTime? from = fromDate != null
          ? DateTime(fromDate.year, fromDate.month, fromDate.day, 0, 0, 0)
          : null;
      final DateTime? till = tillDate != null
          ? DateTime(tillDate.year, tillDate.month, tillDate.day, 23, 59, 59, 999)
          : null;

      // Filter locally using either the custom 'createdOn' field or the system $createdAt
      final filtered = docs.where((doc) {
        DateTime? createdAt;

        // Try custom field first if it exists and is parseable
        final createdOnValue = doc.data['createdOn'];
        if (createdOnValue != null) {
          try {
            // If stored as ISO string
            if (createdOnValue is String) {
              createdAt = DateTime.tryParse(createdOnValue);
            }
            // If stored as int (timestamp millis)
            else if (createdOnValue is int) {
              createdAt = DateTime.fromMillisecondsSinceEpoch(createdOnValue);
            }
          } catch (_) {
            createdAt = null;
          }
        }

        // Fallback to the Appwrite createdAt value
        createdAt ??= DateTime.tryParse(doc.$createdAt);

        if (createdAt == null) {
          // If we can't determine a creation date, exclude the doc when a filter is present
          return false;
        }

        if (from != null && createdAt.isBefore(from)) return false;
        if (till != null && createdAt.isAfter(till)) return false;
        return true;
      }).toList();

      return filtered;
    } catch (e) {
      debugPrint('Error fetching doctors (with client-side date filter): $e');
      return [];
    }
  }

  /// Fetches the number of mothers linked to a doctor.
  Future<int> _getMotherCount(String doctorId) async {
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [
          Query.equal('doctorId', doctorId),
          Query.equal('type', 'mother'),
        ],
      );
      return result.total;
    } catch (e) {
      debugPrint('Error fetching mother count: $e');
      return 0;
    }
  }

  /// Fetches the number of tests linked to a doctor.
  Future<int> _getTestCount(String doctorId) async {
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.testsCollectionId,
        queries: [Query.equal('doctorId', doctorId)],
      );
      return result.total;
    } catch (e) {
      debugPrint('Error fetching test count: $e');
      return 0;
    }
  }

  /// Downloads the filtered doctor list in Excel format.
  Future<void> downloadExcel(BuildContext context) async {
    try {
      await ExcelExportService.exportDoctorsToExcel(
        context,
        state.filteredDoctors,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text("Failed to export: $e")),
      );
    }
  }
}
