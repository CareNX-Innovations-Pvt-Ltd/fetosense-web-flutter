part of 'doctor_edit_cubit.dart';

/// Base class for all doctor edit states.
abstract class DoctorEditState {}

/// State representing the initial state of the doctor edit screen.
class DoctorEditInitial extends DoctorEditState {}

/// State representing that doctor data is being loaded.
class DoctorEditLoading extends DoctorEditState {}

/// State representing that doctor data has been loaded successfully.
class DoctorEditLoaded extends DoctorEditState {}

/// State representing that doctor data is being saved.
class DoctorEditSaving extends DoctorEditState {}

/// State representing that doctor data has been saved successfully.
class DoctorEditSaved extends DoctorEditState {}

/// State representing an error during doctor edit operations.
class DoctorEditError extends DoctorEditState {
  /// The error message describing what went wrong.
  final String message;
  DoctorEditError(this.message);
}
