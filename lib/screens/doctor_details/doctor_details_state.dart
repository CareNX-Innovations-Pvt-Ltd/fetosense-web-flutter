part of 'doctor_details_cubit.dart';

class DoctorDetailsState {
  final DateTime? fromDate;
  final DateTime? tillDate;
  final List<models.Document> allDoctors;
  final List<models.Document> filteredDoctors;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  DoctorDetailsState({
    this.fromDate,
    this.tillDate,
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
  });

  DoctorDetailsState copyWith({
    DateTime? fromDate,
    DateTime? tillDate,
    List<models.Document>? allDoctors,
    List<models.Document>? filteredDoctors,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return DoctorDetailsState(
      fromDate: fromDate ?? this.fromDate,
      tillDate: tillDate ?? this.tillDate,
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DoctorInitial extends DoctorDetailsState {}
