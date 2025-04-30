part of 'doctor_details_cubit.dart';


class DoctorDetailsState {
  final DateTime? fromDate;
  final DateTime? tillDate;
  final List<models.Document> allDoctors;
  final List<models.Document> filteredDoctors;
  final bool isLoading;
  final String? error;

  DoctorDetailsState({
    this.fromDate,
    this.tillDate,
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.isLoading = false,
    this.error,
  });

  DoctorDetailsState copyWith({
    DateTime? fromDate,
    DateTime? tillDate,
    List<models.Document>? allDoctors,
    List<models.Document>? filteredDoctors,
    bool? isLoading,
    String? error,
  }) {
    return DoctorDetailsState(
      fromDate: fromDate ?? this.fromDate,
      tillDate: tillDate ?? this.tillDate,
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DoctorInitial extends DoctorDetailsState {}

