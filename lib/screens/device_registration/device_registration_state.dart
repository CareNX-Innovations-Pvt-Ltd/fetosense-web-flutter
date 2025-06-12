part of 'device_registration_cubit.dart';

/// Represents the state of the device registration process.
///
/// Holds the list of organizations, product types, selected organization and product type,
/// device details, submission status, error messages, and success state. Used by [DeviceRegistrationCubit]
/// to manage the UI state for device registration.
class DeviceRegistrationState extends Equatable {
  /// List of available organizations for device registration.
  final List<Map<String, String>> organizationList;

  /// List of available product types for device registration.
  final List<String> productTypeList;

  /// The ID of the selected organization.
  final String? selectedOrganizationId;

  /// The name of the selected organization.
  final String? selectedOrganizationName;

  /// The selected product type.
  final String? selectedProductType;

  /// The entered device name.
  final String deviceName;

  /// The entered kit ID.
  final String kitId;

  /// The entered tablet serial number.
  final String tabletSerialNumber;

  /// The entered toco ID.
  final String tocoId;

  /// Whether the registration form is currently submitting.
  final bool isSubmitting;

  /// Error message, if any, during registration.
  final String? errorMessage;

  /// Whether the registration was successful.
  final bool isSuccess;

  const DeviceRegistrationState({
    this.organizationList = const [],
    this.productTypeList = const ["main", "mini"],
    this.selectedOrganizationId,
    this.selectedOrganizationName,
    this.selectedProductType,
    this.deviceName = '',
    this.kitId = '',
    this.tabletSerialNumber = '',
    this.tocoId = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  /// Creates a copy of this state with the specified fields replaced.
  DeviceRegistrationState copyWith({
    List<Map<String, String>>? organizationList,
    List<String>? productTypeList,
    String? selectedOrganizationId,
    String? Function()? clearSelectedOrganizationId,
    String? selectedOrganizationName,
    String? Function()? clearSelectedOrganizationName,
    String? selectedProductType,
    String? Function()? clearSelectedProductType,
    String? deviceName,
    String? kitId,
    String? tabletSerialNumber,
    String? tocoId,
    bool? isSubmitting,
    String? errorMessage,
    String? Function()? clearErrorMessage,
    bool? isSuccess,
  }) {
    return DeviceRegistrationState(
      organizationList: organizationList ?? this.organizationList,
      productTypeList: productTypeList ?? this.productTypeList,
      selectedOrganizationId:
          clearSelectedOrganizationId != null
              ? clearSelectedOrganizationId()
              : (selectedOrganizationId ?? this.selectedOrganizationId),
      selectedOrganizationName:
          clearSelectedOrganizationName != null
              ? clearSelectedOrganizationName()
              : (selectedOrganizationName ?? this.selectedOrganizationName),
      selectedProductType:
          clearSelectedProductType != null
              ? clearSelectedProductType()
              : (selectedProductType ?? this.selectedProductType),
      deviceName: deviceName ?? this.deviceName,
      kitId: kitId ?? this.kitId,
      tabletSerialNumber: tabletSerialNumber ?? this.tabletSerialNumber,
      tocoId: tocoId ?? this.tocoId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage:
          clearErrorMessage != null
              ? clearErrorMessage()
              : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    organizationList,
    productTypeList,
    selectedOrganizationId,
    selectedOrganizationName,
    selectedProductType,
    deviceName,
    kitId,
    tabletSerialNumber,
    tocoId,
    isSubmitting,
    errorMessage,
    isSuccess,
  ];
}
