import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';
part 'device_registration_state.dart';

/// Cubit for handling the business logic and state management of device registration.
///
/// Responsible for fetching organizations, registering devices, and managing device registration state.
class DeviceRegistrationCubit extends Cubit<DeviceRegistrationState> {
  /// The Appwrite [Databases] instance for database operations.
  final Databases db;

  /// Creates a [DeviceRegistrationCubit] with the given [db] instance.
  DeviceRegistrationCubit({required this.db})
    : super(const DeviceRegistrationState());

  /// Helper for accessing user preferences.
  final prefs = locator<PreferenceHelper>();

  /// Fetches organizations from the database and updates the state.
  Future<void> fetchOrganizations() async {
    try {
      final result = await fetchOrganizationsFromDb(db);
      emit(
        state.copyWith(
          organizationList:
              result.map((doc) {
                return {
                  'id': doc.$id,
                  'name': doc.data['organizationName']?.toString() ?? '',
                };
              }).toList(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to load organizations: $e'));
    }
  }

  /// Updates the selected organization.
  void updateSelectedOrganization(String name, String id) {
    emit(
      state.copyWith(
        selectedOrganizationName: name,
        selectedOrganizationId: id,
      ),
    );
  }

  /// Updates the selected product type.
  void updateSelectedProductType(String? type) {
    emit(state.copyWith(selectedProductType: type));
  }

  /// Updates the device name.
  void updateDeviceName(String name) {
    emit(state.copyWith(deviceName: name));
  }

  /// Updates the kit ID.
  void updateKitId(String id) {
    emit(state.copyWith(kitId: id));
  }

  /// Updates the tablet serial number.
  void updateTabletSerialNumber(String serialNumber) {
    emit(state.copyWith(tabletSerialNumber: serialNumber));
  }

  /// Updates the Toco ID.
  void updateTocoId(String id) {
    emit(state.copyWith(tocoId: id));
  }

  /// Validates the form data before submission.
  bool validateForm() {
    final requiredFields = [
      state.selectedOrganizationId,
      state.selectedProductType,
      state.deviceName,
      state.kitId,
    ];

    return !requiredFields.any((field) => field == null || field.isEmpty);
  }

  /// Reset the error message.
  void clearError() {
    emit(state.copyWith(clearErrorMessage: () => null));
  }

  /// Reset the success state.
  void resetSuccess() {
    emit(state.copyWith(isSuccess: false));
  }

  /// Submits the device registration data to the database.
  Future<void> registerDevice() async {
    if (!validateForm()) {
      emit(state.copyWith(errorMessage: 'Please fill in all required fields.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: () => null));
    UserModel? userModel = prefs.getUser();
    if (userModel?.role == UserRoles.admin) {
      try {
        await db.createDocument(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.deviceCollectionId,
          documentId: ID.unique(),
          data: {
            'deviceCode': state.kitId,
            'deviceName': state.deviceName,
            'organizationId': state.selectedOrganizationId,
            'hospitalName': state.selectedOrganizationName,
            'tabletSerialNumber': state.tabletSerialNumber,
            'productType': state.selectedProductType,
            'tocoId': state.tocoId,
            'isValid': true,
            'isDeleted': false,
            'createdBy': 'admin',
            'createdOn': DateTime.now().toIso8601String(),
          },
        );

       // String docId = ID.unique();
       //  await db.createDocument(
       //    databaseId: AppConstants.appwriteDatabaseId,
       //    collectionId: AppConstants.userCollectionId,
       //    documentId: docId,
       //    data: {
       //      'deviceCode': state.kitId,
       //      'deviceName': state.deviceName,
       //      'organizationId': state.selectedOrganizationId,
       //      'organizationName': state.selectedOrganizationName,
       //      'delete': false,
       //      'createdBy': 'admin',
       //      'createdOn': DateTime.now().toIso8601String(),
       //      'type': 'device',
       //      'name': state.deviceName,
       //      'noOfTests': 0,
       //      'noOfMother': 0,
       //      'sync':1,
       //      'testAccount': false,
       //      'isActive': true,
       //      'documentId': docId
       //    },
       //  );
       //


        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: 'Error: $e'));
      }
    } else {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: '${userModel?.role} role cannot register device',
        ),
      );
    }
  }
}

/// Helper function to fetch organizations from the database.
/// This would normally be in a repository class, but included here for simplicity.
Future<List<Document>> fetchOrganizationsFromDb(Databases db) async {
  final result = await db.listDocuments(
    databaseId: AppConstants.appwriteDatabaseId,
    collectionId: AppConstants.userCollectionId,
    queries: [
      Query.equal('type', 'organization'),
    ],
  );

  return result.documents;
}
