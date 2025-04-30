import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

part 'organization_registration_state.dart';

class OrganizationRegistrationCubit extends Cubit<OrganizationRegistrationState> {
  final Databases db;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController organizationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController streetController = TextEditingController();

  OrganizationRegistrationCubit()
      : db = Databases(locator<AppwriteService>().client),
        super(OrganizationRegistrationState.initial());

  void setStatus(String? status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void setDesignation(String? designation) {
    emit(state.copyWith(selectedDesignation: designation));
  }

  void setStateName(String? stateName) {
    emit(state.copyWith(selectedState: stateName, selectedCity: null));
  }

  void setCity(String? city) {
    emit(state.copyWith(selectedCity: city));
  }

  Future<void> saveForm(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        await db.createDocument(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.userCollectionId,
          documentId: ID.unique(),
          data: {
            'name': organizationController.text,
            'mobile': mobileController.text,
            'status': state.selectedStatus,
            'designation': state.selectedDesignation,
            'contactPerson': contactPersonController.text,
            'email': emailController.text,
            'addressLine': streetController.text,
            'state': state.selectedState,
            'city': state.selectedCity,
            'country': "India",
            'type': 'organization',
            'createdOn': DateTime.now().toIso8601String(),
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Future<void> close() {
    organizationController.dispose();
    mobileController.dispose();
    contactPersonController.dispose();
    emailController.dispose();
    streetController.dispose();
    return super.close();
  }
}
