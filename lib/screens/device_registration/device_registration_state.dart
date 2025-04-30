
part of 'device_registration_cubit.dart';


/// Represents the state of the device registration process.
class DeviceRegistrationState extends Equatable {
  final List<Map<String, String>> organizationList;
  final List<String> productTypeList;
  final String? selectedOrganizationId;
  final String? selectedOrganizationName;
  final String? selectedProductType;
  final String deviceName;
  final String kitId;
  final String tabletSerialNumber;
  final String tocoId;
  final bool isSubmitting;
  final String? errorMessage;
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
      selectedOrganizationId: clearSelectedOrganizationId != null
          ? clearSelectedOrganizationId()
          : (selectedOrganizationId ?? this.selectedOrganizationId),
      selectedOrganizationName: clearSelectedOrganizationName != null
          ? clearSelectedOrganizationName()
          : (selectedOrganizationName ?? this.selectedOrganizationName),
      selectedProductType: clearSelectedProductType != null
          ? clearSelectedProductType()
          : (selectedProductType ?? this.selectedProductType),
      deviceName: deviceName ?? this.deviceName,
      kitId: kitId ?? this.kitId,
      tabletSerialNumber: tabletSerialNumber ?? this.tabletSerialNumber,
      tocoId: tocoId ?? this.tocoId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage != null
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