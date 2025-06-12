part of 'organization_details_cubit.dart';

enum OrganizationStatus { initial, loading, loaded, error }

class OrganizationState extends Equatable {
  final List<models.Document> organizations;
  final List<models.Document> filteredOrganizations;
  final OrganizationStatus status;
  final DateTime? fromDate;
  final DateTime? tillDate;
  final String searchQuery;
  final String? errorMessage;

  const OrganizationState({
    this.organizations = const [],
    this.filteredOrganizations = const [],
    this.status = OrganizationStatus.initial,
    this.fromDate,
    this.tillDate,
    this.searchQuery = '',
    this.errorMessage,
  });

  OrganizationState copyWith({
    List<models.Document>? organizations,
    List<models.Document>? filteredOrganizations,
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
      organizations: organizations ?? this.organizations,
      filteredOrganizations: filteredOrganizations ?? this.filteredOrganizations,
      status: status ?? this.status,
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      tillDate: clearTillDate ? null : (tillDate ?? this.tillDate),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    organizations,
    filteredOrganizations,
    status,
    fromDate,
    tillDate,
    searchQuery,
    errorMessage,
  ];
}