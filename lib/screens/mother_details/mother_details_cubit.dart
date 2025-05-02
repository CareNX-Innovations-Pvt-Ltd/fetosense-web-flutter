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


/// Fetches mothers from the database with optional date filtering
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
    queries.add(Query.greaterThanEqual('createdAt', fromDate.toIso8601String()));
  }

  if (tillDate != null) {
    queries.add(Query.lessThanEqual('createdAt', tillDate.toIso8601String()));
  }

  final result = await db.listDocuments(
    databaseId: AppConstants.appwriteDatabaseId, // Replace with actual DB ID
    collectionId: AppConstants.userCollectionId, // Replace with actual collection ID
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
    emit(state.copyWith(fromDate: date));
  }

  /// Clears the fromDate and its controller
  void clearFromDate() {
    fromDateController.clear();
    emit(state.copyWith(clearFromDate: true));
  }

  /// Updates the tillDate and controller text
  void setTillDate(DateTime? date) {
    if (date != null) {
      tillDateController.text = date.toString().split(' ')[0];
    }
    emit(state.copyWith(tillDate: date));
  }

  /// Clears the tillDate and its controller
  void clearTillDate() {
    tillDateController.clear();
    emit(state.copyWith(clearTillDate: true));
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

      final result = await fetchMothers(
        db,
        fromDate: state.fromDate,
        tillDate: state.tillDate,
      );

      emit(state.copyWith(
        allMothers: result,
        filteredMothers: result,
        isLoading: false,
      ));

      _applySearchFilter();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Error fetching mothers: $e",
      ));
      print("Error fetching mothers: $e");
    }
  }

  /// Applies the search filter based on the text entered in the search field
  /// It filters the mothers list by the organization name
  void _applySearchFilter() {
    final keyword = state.searchQuery.trim().toLowerCase();

    if (keyword.isEmpty) {
      emit(state.copyWith(filteredMothers: state.allMothers));
    } else {
      final filtered = state.allMothers.where((org) {
        final name = org.data['organizationName']?.toString().toLowerCase() ?? '';
        return name.contains(keyword);
      }).toList();

      emit(state.copyWith(filteredMothers: filtered));
    }
  }

  /// Downloads the filtered mothers data in Excel format
  Future<void> downloadExcel(BuildContext context) async {
    try {
      await ExcelExportService.exportMothersToExcel(context, state.filteredMothers);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to export: $e")),
      );
    }
  }
}