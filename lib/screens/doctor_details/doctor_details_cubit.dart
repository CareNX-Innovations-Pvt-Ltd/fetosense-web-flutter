import 'package:bloc/bloc.dart';
import 'package:appwrite/models.dart' as models;
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:appwrite/appwrite.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  DoctorDetailsCubit() : super(DoctorDetailsState.initial()) {
    fetchDoctorsId();
  }

  final Databases db = Databases(locator<AppwriteService>().client);

  void updateFromDate(DateTime? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateTillDate(DateTime? date) {
    emit(state.copyWith(tillDate: date));
  }

  void applySearchFilter(String searchTerm) {
    final filtered = state.allDoctors.where((doc) {
      final data = doc.data;
      final lower = searchTerm.toLowerCase();
      return data['name']?.toLowerCase().contains(lower) == true ||
          data['email']?.toLowerCase().contains(lower) == true ||
          data['organizationName']?.toLowerCase().contains(lower) == true;
    }).toList();

    emit(state.copyWith(filteredDoctors: filtered));
  }

  Future<void> fetchDoctorsId() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final List<String> queries = [Query.equal('type', 'doctor')];

      if (state.fromDate != null) {
        queries.add(Query.greaterThanEqual('createdOn', state.fromDate!.toIso8601String()));
      }

      if (state.tillDate != null) {
        final tillEnd = DateTime(
          state.tillDate!.year,
          state.tillDate!.month,
          state.tillDate!.day,
          23, 59, 59,
        );
        queries.add(Query.lessThanEqual('createdOn', tillEnd.toIso8601String()));
      }

      final response = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: queries,
      );

      final List<models.Document> enrichedDocs = [];

      for (final doc in response.documents) {
        final doctorName = doc.data['name'] ?? 'Unknown';
        final mothers = await db.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          queries: [Query.equal('doctorName', doctorName), Query.equal('type', 'mother')],
        );

        final tests = await db.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.testsCollectionId,
          queries: [Query.equal('doctorName', doctorName)],
        );

        final updatedData = Map<String, dynamic>.from(doc.data)
          ..['noOfMother'] = mothers.total
          ..['noOfTests'] = tests.total;

        enrichedDocs.add(models.Document(
          $id: doc.$id,
          $collectionId: doc.$collectionId,
          $databaseId: doc.$databaseId,
          $createdAt: doc.$createdAt,
          $updatedAt: doc.$updatedAt,
          data: updatedData, $permissions: [],
        ));
      }

      emit(state.copyWith(
        allDoctors: enrichedDocs,
        filteredDoctors: enrichedDocs,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
