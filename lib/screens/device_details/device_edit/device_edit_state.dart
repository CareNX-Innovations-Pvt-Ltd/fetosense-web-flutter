part of 'device_edit_cubit.dart';

/// Base class for all device edit states.
abstract class DeviceEditState {}

/// State representing the initial state of the device edit screen.
class DeviceEditInitial extends DeviceEditState {}

/// State representing that device data is being loaded.
class DeviceEditLoading extends DeviceEditState {}

/// State representing that device data has been loaded successfully.
class DeviceEditLoaded extends DeviceEditState {}

/// State representing that device data is being saved.
class DeviceEditSaving extends DeviceEditState {}

/// State representing that device data has been saved successfully.
class DeviceEditSaved extends DeviceEditState {}

/// State representing an error during device edit operations.
class DeviceEditError extends DeviceEditState {
  /// The error message describing what went wrong.
  final String message;
  DeviceEditError(this.message);
}
