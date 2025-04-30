part of 'organization_registration_cubit.dart';

class OrganizationRegistrationState {
  final String? selectedStatus;
  final String? selectedDesignation;
  final String? selectedState;
  final String? selectedCity;

  const OrganizationRegistrationState({
    this.selectedStatus,
    this.selectedDesignation,
    this.selectedState,
    this.selectedCity,
  });

  factory OrganizationRegistrationState.initial() {
    return const OrganizationRegistrationState();
  }

  OrganizationRegistrationState copyWith({
    String? selectedStatus,
    String? selectedDesignation,
    String? selectedState,
    String? selectedCity,
  }) {
    return OrganizationRegistrationState(
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedDesignation: selectedDesignation ?? this.selectedDesignation,
      selectedState: selectedState ?? this.selectedState,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}
