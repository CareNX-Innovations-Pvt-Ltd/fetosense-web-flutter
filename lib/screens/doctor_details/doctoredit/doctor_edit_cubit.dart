import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fetosense_mis/core/utils/app_constants.dart';

part 'doctor_edit_state.dart';

class DoctorEditCubit extends Cubit<DoctorEditState> {
  final Databases db;
  final String documentId;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  DoctorEditCubit({required this.db, required this.documentId})
    : super(DoctorEditInitial());

  /// Initialize the form with existing doctor data.
  void initialize(Map<String, dynamic> data) {
    nameController.text = data['name'] ?? '';
    mobileController.text = data['mobile'] ?? '';
    emailController.text = data['email'] ?? '';
    emit(DoctorEditLoaded());
  }

  /// Updates the doctor's details in the database.
  Future<void> updateChanges(BuildContext context, VoidCallback onClose) async {
    emit(DoctorEditSaving());
    try {
      final updatedData = {
        'name': nameController.text.trim(),
        'mobile': mobileController.text.trim(),
        'email': emailController.text.trim(),
      };

      await db.updateDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        documentId: documentId,
        data: updatedData,
      );

      emit(DoctorEditSaved());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Doctor updated successfully")),
        );
      }

      onClose();
    } catch (e) {
      emit(DoctorEditError("Update failed: $e"));

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
      }
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    return super.close();
  }
}
