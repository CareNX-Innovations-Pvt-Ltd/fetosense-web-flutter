import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

part 'mother_details_state.dart';

/// Fetches mothers from the database with optional date filtering.
///
/// Queries the Appwrite database for documents of type 'mother'.
/// Optionally filters by [fromDate] and [tillDate] if provided.
///
/// Returns a [List] of Appwrite [Document]s representing mothers.
Future<List<models.Document>> fetchMothers(
  Databases db, {
  DateTime? fromDate,
  DateTime? tillDate,
}) async {
  // Implementation would depend on your actual query logic
  // This is a placeholder based on the original code
  List<String> queries = [];

  queries.add(Query.equal('type', 'mother'));

  if (fromDate != null) {
    queries.add(
      Query.greaterThanEqual('createdOn', fromDate.toIso8601String()),
    );
  }

  if (tillDate != null) {
    queries.add(Query.lessThanEqual('createdOn', tillDate.toIso8601String()));
  }

  final result = await db.listDocuments(
    databaseId: AppConstants.appwriteDatabaseId,
    collectionId: AppConstants.userCollectionId,
    queries: queries,
  );

  return result.documents;
}

class MotherDetailsCubit extends Cubit<MotherDetailsState> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController tillDateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late final Databases db;
  final client = locator<AppwriteService>().client;

  MotherDetailsCubit() : super(const MotherDetailsState()) {
    db = Databases(client);
    _initControllers();
    fetchMothersId();
  }

  void _initControllers() {
    searchController.addListener(_applySearchFilter);
  }

  @override
  Future<void> close() {
    fromDateController.dispose();
    tillDateController.dispose();
    searchController.dispose();
    return super.close();
  }

  /// Updates the fromDate and controller text
  void setFromDate(DateTime? date) {
    if (date != null) {
      fromDateController.text = date.toString().split(' ')[0];
    }

    // IMPORTANT: overrideFromDate = true allows clearing
    emit(state.copyWith(fromDate: date, overrideFromDate: true));
  }

  /// Updates the tillDate and controller text
  void setTillDate(DateTime? date) {
    if (date != null) {
      tillDateController.text = date.toString().split(' ')[0];
    }

    emit(state.copyWith(tillDate: date, overrideTillDate: true));
  }

  /// Clears both dates and refreshes list
  void clearAllFilters() {
    fromDateController.clear();
    tillDateController.clear();

    emit(
      state.copyWith(
        fromDate: null,
        overrideFromDate: true,
        tillDate: null,
        overrideTillDate: true,
      ),
    );

    // Ensure state is updated before fetching
    Future.microtask(() => fetchMothersId());
  }

  /// Updates the search query and filters the mothers list
  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applySearchFilter();
  }

  /// Fetches the list of mothers from the database based on the date range
  Future<void> fetchMothersId() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final result = await _fetchMothersLocalFilter(
        fromDate: state.fromDate,
        tillDate: state.tillDate,
      );

      emit(
        state.copyWith(
          allMothers: result,
          filteredMothers: result,
          isLoading: false,
        ),
      );

      _applySearchFilter();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Error fetching mothers: $e",
        ),
      );
      debugPrint("Error fetching mothers: $e");
    }
  }

  /// Applies the search filter based on the search field
  void _applySearchFilter() {
    final keyword = state.searchQuery.trim().toLowerCase();

    if (keyword.isEmpty) {
      emit(state.copyWith(filteredMothers: state.allMothers));
    } else {
      final filtered =
          state.allMothers.where((mother) {
            final name = mother.data['name']?.toString().toLowerCase() ?? '';
            return name.contains(keyword);
          }).toList();
      emit(state.copyWith(filteredMothers: filtered));
    }
  }

  /// Local date filtering (same logic as DoctorDetails)
  Future<List<models.Document>> _fetchMothersLocalFilter({
    DateTime? fromDate,
    DateTime? tillDate,
  }) async {
    final result = await db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: [Query.equal('type', 'mother'), Query.limit(1000)],
    );

    final docs = result.documents;

    if (fromDate == null && tillDate == null) return docs;

    final from =
        fromDate != null
            ? DateTime(fromDate.year, fromDate.month, fromDate.day, 0, 0, 0)
            : null;

    final till =
        tillDate != null
            ? DateTime(
              tillDate.year,
              tillDate.month,
              tillDate.day,
              23,
              59,
              59,
              999,
            )
            : null;

    return docs.where((doc) {
      DateTime? created;

      final createdOn = doc.data['createdOn'];

      if (createdOn is String) created = DateTime.tryParse(createdOn);
      if (createdOn is int) {
        created = DateTime.fromMillisecondsSinceEpoch(createdOn);
      }

      created ??= DateTime.tryParse(doc.$createdAt);
      if (created == null) return false;

      if (from != null && created.isBefore(from)) return false;
      if (till != null && created.isAfter(till)) return false;

      return true;
    }).toList();
  }

  Future<void> downloadExcel(BuildContext context) async {
    try {
      await ExcelExportService.exportMothersToExcel(
        context,
        state.filteredMothers,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
    }
  }
}
