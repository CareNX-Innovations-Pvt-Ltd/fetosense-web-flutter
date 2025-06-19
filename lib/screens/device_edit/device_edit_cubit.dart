import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

part 'device_edit_state.dart';

class DeviceEditCubit extends Cubit<DeviceEditState> {
  final Databases db;
  final String documentId;

  final deviceCodeController = TextEditingController();
  final tabletSerialNumberController = TextEditingController();
  final deviceNameController = TextEditingController();
  final prefs = locator<PreferenceHelper>();

  DeviceEditCubit({required this.db, required this.documentId})
    : super(DeviceEditInitial());

  void initialize(Map<String, dynamic> data) {
    deviceCodeController.text = data['deviceCode'] ?? '';
    deviceNameController.text = data['deviceId'] ?? '';
    fetchTabletSerialNumber();
  }

  /// Fetches the tablet serial number for the current device from Appwrite.
  ///
  /// Queries the device collection using the [documentId] and updates the
  /// [tabletSerialNumberController] with the fetched value if available.
  /// Emits [DeviceEditLoaded] on success or [DeviceEditError] on failure.
  Future<void> fetchTabletSerialNumber() async {
    emit(DeviceEditLoading());
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [Query.equal('type', 'device'), Query.equal('documentId', documentId)],
      );

      if (result.documents.isNotEmpty) {
        tabletSerialNumberController.text =
            result.documents.first.data['tabletSerialNumber'] ?? '';
      }

      emit(DeviceEditLoaded());
    } catch (e) {
      emit(DeviceEditError("Failed to fetch tablet serial number"));
    }
  }

  /// Updates the device details in Appwrite with the current values from the controllers.
  ///
  /// Only allows update if the current user has the [UserRoles.admin] role.
  /// Emits [DeviceEditSaving] while saving, and [DeviceEditLoaded] or [DeviceEditError] on completion.
  Future<void> updateChanges() async {
    emit(DeviceEditSaving());
    UserModel? user = prefs.getUser();
    if (user?.role == UserRoles.admin) {
      try {
        await db.updateDocument(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.deviceCollectionId,
          documentId: documentId,
          data: {
            'deviceCode': deviceCodeController.text.trim(),
            'deviceName': deviceNameController.text.trim(),
          },
        );

        final tabletResult = await db.listDocuments(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.deviceCollectionId,
          queries: [Query.equal('documentId', documentId)],
        );

        if (tabletResult.documents.isNotEmpty) {
          final tabletDocId = tabletResult.documents.first.$id;
          await db.updateDocument(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.deviceCollectionId,
            documentId: tabletDocId,
            data: {
              'tabletSerialNumber': tabletSerialNumberController.text.trim(),
            },
          );
        }

        emit(DeviceEditSaved());
      } catch (e) {
        emit(DeviceEditError("Failed to update device: $e"));
      }
    } else {
      emit(DeviceEditError("${user?.role} role cannot edit device"));
    }
  }

  @override
  Future<void> close() {
    deviceCodeController.dispose();
    tabletSerialNumberController.dispose();
    deviceNameController.dispose();
    return super.close();
  }
}
