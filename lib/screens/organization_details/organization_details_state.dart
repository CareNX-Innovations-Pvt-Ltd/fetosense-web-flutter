part of 'organization_details_cubit.dart';

/// Status values for organization data loading and error handling.
enum OrganizationStatus { initial, loading, loaded, error }

/// State class for the organization details screen.
///
/// Holds all organization data, filtered organization data, status, date filters, search query, and error state.
/// Used by [OrganizationCubit] to manage the UI state for organization details.
class OrganizationState extends Equatable {
  /// List of all organization details models fetched from Appwrite.
  final List<OrganizationDetailsModel> organizationDetails;

  /// List of organizations after applying filters and search.
  final List<OrganizationDetailsModel> filteredOrganizationDetails;

  /// The current status of the organization data (loading, loaded, etc.).
  final OrganizationStatus status;

  /// The start date filter for organization data.
  final DateTime? fromDate;

  /// The end date filter for organization data.
  final DateTime? tillDate;

  /// The current search query for filtering organizations.
  final String searchQuery;

  /// Error message, if any, during data fetching or processing.
  final String? errorMessage;

  /// Creates an [OrganizationState] with the given values.
  const OrganizationState({
    this.organizationDetails = const [],
    this.filteredOrganizationDetails = const [],
    this.status = OrganizationStatus.initial,
    this.fromDate,
    this.tillDate,
    this.searchQuery = '',
    this.errorMessage,
  });

  /// Returns a copy of this state with updated fields if provided.
  OrganizationState copyWith({
    List<OrganizationDetailsModel>? organizationDetails,
    List<OrganizationDetailsModel>? filteredOrganizationDetails,
    OrganizationStatus? status,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? tillDate,
    bool clearTillDate = false,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrganizationState(
      organizationDetails: organizationDetails ?? this.organizationDetails,
      filteredOrganizationDetails:
          filteredOrganizationDetails ?? this.filteredOrganizationDetails,
      status: status ?? this.status,
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      tillDate: clearTillDate ? null : (tillDate ?? this.tillDate),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    organizationDetails,
    filteredOrganizationDetails,
    status,
    fromDate,
    tillDate,
    searchQuery,
    errorMessage,
  ];
}
