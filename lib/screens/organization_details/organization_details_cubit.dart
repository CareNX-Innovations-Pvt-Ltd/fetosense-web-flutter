import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fetosense_mis/services/excel_services/organizations_excel_download.dart';
part 'organization_details_state.dart';


class OrganizationCubit extends Cubit<OrganizationState> {
  final Databases db;
  final BuildContext context;

  OrganizationCubit({required this.db, required this.context})
      : super(const OrganizationState()) {
    fetchOrganizations();
  }

  /// Fetches organizations from the database based on the date range.
  Future<void> fetchOrganizations() async {
    emit(state.copyWith(status: OrganizationStatus.loading));

    try {
      final result = await _fetchOrganizationsFromDb(
        fromDate: state.fromDate,
        tillDate: state.tillDate,
      );

      emit(state.copyWith(
        organizations: result,
        filteredOrganizations: result,
        status: OrganizationStatus.loaded,
        clearError: true,
      ));

      applySearchFilter();
    } catch (e) {
      emit(state.copyWith(
        status: OrganizationStatus.error,
        errorMessage: "Error fetching organizations: $e",
      ));
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
      print('Error fetching organizations: $e');
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
      emit(state.copyWith(filteredOrganizations: state.organizations));
    } else {
      final filtered = state.organizations.where((org) {
        final name = org.data['name']?.toString().toLowerCase() ?? '';
        return name.contains(keyword);
      }).toList();

      emit(state.copyWith(filteredOrganizations: filtered));
    }
  }

  /// Sets the from date for filtering.
  void setFromDate(DateTime? date) {
    emit(state.copyWith(
      fromDate: date,
      clearFromDate: date == null,
    ));
  }

  /// Sets the till date for filtering.
  void setTillDate(DateTime? date) {
    emit(state.copyWith(
      tillDate: date,
      clearTillDate: date == null,
    ));
  }

  /// Downloads the filtered organizations data in Excel format.
  Future<void> downloadExcel() async {
    try {
      await ExcelExportService.exportOrganizationsToExcel(
        context,
        state.filteredOrganizations,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to export: $e")),
      );
    }
  }
}