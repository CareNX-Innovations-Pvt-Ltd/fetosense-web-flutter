part of 'doctor_details_cubit.dart';

/// State class for the doctor details screen.
///
/// Holds all doctor data, filtered doctor data, date filters, loading and error states.
/// Used by [DoctorDetailsCubit] to manage the UI state for doctor details.
class DoctorDetailsState extends Equatable {
  /// List of all doctor documents fetched from Appwrite.
  final List<models.Document> allDoctors;

  /// List of doctors after applying filters and search.
  final List<models.Document> filteredDoctors;

  /// The start date filter for doctor data.
  final DateTime? fromDate;

  /// The end date filter for doctor data.
  final DateTime? tillDate;

  /// Whether doctor data is currently being loaded.
  final bool isLoading;

  /// Error message, if any, during data fetching or processing.
  final String? error;

  /// Creates a [DoctorDetailsState] with the given values.
  const DoctorDetailsState({
    required this.allDoctors,
    required this.filteredDoctors,
    required this.fromDate,
    required this.tillDate,
    required this.isLoading,
    required this.error,
  });

  /// Returns the initial state for doctor details.
  factory DoctorDetailsState.initial() => const DoctorDetailsState(
    allDoctors: [],
    filteredDoctors: [],
    fromDate: null,
    tillDate: null,
    isLoading: false,
    error: null,
  );

  /// Returns a copy of this state with updated fields if provided.
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
