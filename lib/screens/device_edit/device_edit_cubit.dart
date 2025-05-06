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

  Future<void> fetchTabletSerialNumber() async {
    emit(DeviceEditLoading());
    try {
      final result = await db.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.deviceCollectionId,
        queries: [Query.equal('documentId', documentId)],
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

  Future<void> updateChanges() async {
    emit(DeviceEditSaving());
    UserModel? user = prefs.getUser();
    if(user?.role == UserRoles.admin) {
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
