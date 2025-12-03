part of 'doctor_details_cubit.dart';

/// Enum representing the loading status of doctor details.
enum DoctorStatus { initial, loading, loaded, error }

/// State class for the doctor details screen.
///
/// Holds all doctor documents, filtered list, search query,
/// date filters, and status/error states.
/// Used by [DoctorDetailsCubit] to manage the UI state for doctor data.
class DoctorDetailsState extends Equatable {
  /// List of all doctor documents fetched from Appwrite.
  final List<models.Document> doctorDetails;

  /// List of doctors after applying filters and search.
  final List<models.Document> filteredDoctors;

  /// Search query for filtering doctors.
  final String searchQuery;

  /// The start date filter for doctor data.
  final DateTime? fromDate;

  /// The end date filter for doctor data.
  final DateTime? tillDate;

  /// Indicates the current loading state.
  final DoctorStatus status;

  /// Error message, if any.
  final String? errorMessage;

  /// Used to clear error messages if needed.
  final bool clearError;

  /// Flag to indicate the "from date" field should be cleared in the UI.
  final bool clearFromDate;

  /// Flag to indicate the "till date" field should be cleared in the UI.
  final bool clearTillDate;

  /// Creates a [DoctorDetailsState] with the given values.
  const DoctorDetailsState({
    required this.doctorDetails,
    required this.filteredDoctors,
    required this.searchQuery,
    required this.fromDate,
    required this.tillDate,
    required this.status,
    required this.errorMessage,
    required this.clearError,
    required this.clearFromDate,
    required this.clearTillDate,
  });

  /// Returns the initial state for doctor details.
  factory DoctorDetailsState.initial() => const DoctorDetailsState(
    doctorDetails: [],
    filteredDoctors: [],
    searchQuery: "",
    fromDate: null,
    tillDate: null,
    status: DoctorStatus.initial,
    errorMessage: null,
    clearError: false,
    clearFromDate: false,
    clearTillDate: false,
  );

  /// Returns a copy of this state with updated fields if provided.
  DoctorDetailsState copyWith({
    List<models.Document>? doctorDetails,
    List<models.Document>? filteredDoctors,
    String? searchQuery,
    DateTime? fromDate,
    DateTime? tillDate,
    DoctorStatus? status,
    String? errorMessage,
    bool? clearError,
    bool? clearFromDate,
    bool? clearTillDate,
    bool overrideFromDate = false,
    bool overrideTillDate = false,
  }) {
    return DoctorDetailsState(
      doctorDetails: doctorDetails ?? this.doctorDetails,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      searchQuery: searchQuery ?? this.searchQuery,

      // NULL OVERRIDE SUPPORT
      fromDate: overrideFromDate ? fromDate : (fromDate ?? this.fromDate),
      tillDate: overrideTillDate ? tillDate : (tillDate ?? this.tillDate),

      status: status ?? this.status,
      errorMessage: errorMessage,
      clearError: clearError ?? this.clearError,
      clearFromDate: clearFromDate ?? this.clearFromDate,
      clearTillDate: clearTillDate ?? this.clearTillDate,
    );
  }


  @override
  List<Object?> get props => [
    doctorDetails,
    filteredDoctors,
    searchQuery,
    fromDate,
    tillDate,
    status,
    errorMessage,
    clearError,
    clearFromDate,
    clearTillDate,
  ];
}
