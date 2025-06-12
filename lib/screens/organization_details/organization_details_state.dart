part of 'organization_details_cubit.dart';

enum OrganizationStatus { initial, loading, loaded, error }

class OrganizationState extends Equatable {
  final List<OrganizationDetailsModel> organizationDetails;
  final List<OrganizationDetailsModel> filteredOrganizationDetails;
  final OrganizationStatus status;
  final DateTime? fromDate;
  final DateTime? tillDate;
  final String searchQuery;
  final String? errorMessage;

  const OrganizationState({
    this.organizationDetails = const [],
    this.filteredOrganizationDetails = const [],
    this.status = OrganizationStatus.initial,
    this.fromDate,
    this.tillDate,
    this.searchQuery = '',
    this.errorMessage,
  });

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
      filteredOrganizationDetails: filteredOrganizationDetails ?? this.filteredOrganizationDetails,
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