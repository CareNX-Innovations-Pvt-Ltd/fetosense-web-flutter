import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  DoctorDetailsCubit() : super(DoctorInitial());

  final Databases db = Databases(locator<AppwriteService>().client);

  DateTime? fromDate;
  DateTime? tillDate;
  List<models.Document> allDoctors = [];

  void updateFromDate(DateTime? date) {
    fromDate = date;
    emit(state.copyWith(fromDate: date));
  }

  void updateTillDate(DateTime? date) {
    tillDate = date;
    emit(state.copyWith(tillDate: date));
  }

  Future<List> fetchDoctorsId() async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<String> queries = [Query.equal('type', 'doctor')];

      final bool applyDateFilter = fromDate != null || tillDate != null;

      if (applyDateFilter) {
        queries.add(Query.isNotNull('createdOn'));

        if (fromDate != null) {
          queries.add(
            Query.greaterThanEqual('createdOn', fromDate!.toIso8601String()),
          );
        }

        if (tillDate != null) {
          final tillDateEnd = DateTime(
            tillDate!.year,
            tillDate!.month,
            tillDate!.day,
            23,
            59,
            59,
          );
          queries.add(
            Query.lessThanEqual('createdOn', tillDateEnd.toIso8601String()),
          );
        }
      }

      // Query the database for doctor documents
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: queries,
      );
      emit(state.copyWith(isLoading: false));
      applySearchFilter(state.searchQuery ?? '');
      emit(state.copyWith(filteredDoctors: result.documents));

      debugPrint(result.documents.toString());
      return result.documents;
    } catch (e) {
      print(' Error fetching doctors: $e');
      return [];
    }
  }

  void applySearchFilter(String query) {
    final keyword = query.trim().toLowerCase();
    final filtered =
        keyword.isEmpty
            ? state.allDoctors
            : state.allDoctors.where((doc) {
              final name =
                  (doc.data['doctorName'] ?? '').toString().toLowerCase();
              return name.contains(keyword);
            }).toList();

    emit(state.copyWith(searchQuery: query, filteredDoctors: filtered));
  }
}
