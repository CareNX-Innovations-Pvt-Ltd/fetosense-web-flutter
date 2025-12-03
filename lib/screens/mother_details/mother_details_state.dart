part of 'mother_details_cubit.dart';

/// State class for the mother details screen.
///
/// Holds all mother data, filtered mother data, date filters, search query, loading and error states.
/// Used by [MotherDetailsCubit] to manage the UI state for mother details.
@immutable
class MotherDetailsState extends Equatable {
  /// List of all mother documents fetched from Appwrite.
  final List<models.Document> allMothers;

  /// List of mothers after applying filters and search.
  final List<models.Document> filteredMothers;

  /// The start date filter for mother data.
  final DateTime? fromDate;

  /// The end date filter for mother data.
  final DateTime? tillDate;

  /// The current search query for filtering mothers.
  final String searchQuery;

  /// Whether mother data is currently being loaded.
  final bool isLoading;

  /// Error message, if any, during data fetching or processing.
  final String? errorMessage;

  const MotherDetailsState({
    this.allMothers = const [],
    this.filteredMothers = const [],
    this.fromDate,
    this.tillDate,
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  /// Returns a copy of this state with updated fields if provided.
  ///
  /// Supports overriding DateTime fields with null using override flags
  /// so clearing the dates works properly.
  MotherDetailsState copyWith({
    List<models.Document>? allMothers,
    List<models.Document>? filteredMothers,

    DateTime? fromDate,
    bool overrideFromDate = false,

    DateTime? tillDate,
    bool overrideTillDate = false,

    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MotherDetailsState(
      allMothers: allMothers ?? this.allMothers,
      filteredMothers: filteredMothers ?? this.filteredMothers,

      // IMPORTANT: This allows explicitly setting null (clear date)
      fromDate: overrideFromDate ? fromDate : (fromDate ?? this.fromDate),
      tillDate : overrideTillDate ? tillDate : (tillDate ?? this.tillDate),

      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    allMothers,
    filteredMothers,
    fromDate,
    tillDate,
    searchQuery,
    isLoading,
    errorMessage,
  ];
}
