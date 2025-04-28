part of 'device_edit_cubit.dart';

abstract class DeviceEditState {}

class DeviceEditInitial extends DeviceEditState {}

class DeviceEditLoading extends DeviceEditState {}

class DeviceEditLoaded extends DeviceEditState {}

class DeviceEditSaving extends DeviceEditState {}

class DeviceEditSaved extends DeviceEditState {}

class DeviceEditError extends DeviceEditState {
  final String message;
  DeviceEditError(this.message);
}
