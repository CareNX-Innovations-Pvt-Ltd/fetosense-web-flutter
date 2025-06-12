part of 'organization_registration_cubit.dart';

/// State class for the organization registration screen.
///
/// Holds the selected status, designation, state, and city for the organization registration form.
/// Used by [OrganizationRegistrationCubit] to manage the UI state for organization registration.
class OrganizationRegistrationState {
  /// The selected status for the organization.
  final String? selectedStatus;

  /// The selected designation for the contact person.
  final String? selectedDesignation;

  /// The selected state for the organization address.
  final String? selectedState;

  /// The selected city for the organization address.
  final String? selectedCity;

  /// Creates an [OrganizationRegistrationState] with the given values.
  const OrganizationRegistrationState({
    this.selectedStatus,
    this.selectedDesignation,
    this.selectedState,
    this.selectedCity,
  });

  /// Returns the initial state for organization registration.
  factory OrganizationRegistrationState.initial() {
    return const OrganizationRegistrationState();
  }

  /// Returns a copy of this state with updated fields if provided.
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
