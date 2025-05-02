part of 'mother_details_cubit.dart';

@immutable
class MotherDetailsState extends Equatable {
  final List<models.Document> allMothers;
  final List<models.Document> filteredMothers;
  final DateTime? fromDate;
  final DateTime? tillDate;
  final String searchQuery;
  final bool isLoading;
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

  MotherDetailsState copyWith({
    List<models.Document>? allMothers,
    List<models.Document>? filteredMothers,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? tillDate,
    bool clearTillDate = false,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MotherDetailsState(
      allMothers: allMothers ?? this.allMothers,
      filteredMothers: filteredMothers ?? this.filteredMothers,
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      tillDate: clearTillDate ? null : (tillDate ?? this.tillDate),
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
