part of 'doctor_details_cubit.dart';

class DoctorDetailsState extends Equatable {
  final List<models.Document> allDoctors;
  final List<models.Document> filteredDoctors;
  final DateTime? fromDate;
  final DateTime? tillDate;
  final bool isLoading;
  final String? error;

  const DoctorDetailsState({
    required this.allDoctors,
    required this.filteredDoctors,
    required this.fromDate,
    required this.tillDate,
    required this.isLoading,
    required this.error,
  });

  factory DoctorDetailsState.initial() => const DoctorDetailsState(
    allDoctors: [],
    filteredDoctors: [],
    fromDate: null,
    tillDate: null,
    isLoading: false,
    error: null,
  );

  DoctorDetailsState copyWith({
    List<models.Document>? allDoctors,
    List<models.Document>? filteredDoctors,
    DateTime? fromDate,
    DateTime? tillDate,
    bool? isLoading,
    String? error,
  }) {
    return DoctorDetailsState(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      fromDate: fromDate ?? this.fromDate,
      tillDate: tillDate ?? this.tillDate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    allDoctors,
    filteredDoctors,
    fromDate,
    tillDate,
    isLoading,
    error,
  ];
}
