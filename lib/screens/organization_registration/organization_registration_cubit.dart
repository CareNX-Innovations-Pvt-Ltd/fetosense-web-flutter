import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

part 'organization_registration_state.dart';

/// Cubit for managing the state and logic of the organization registration screen.
///
/// Handles form input, state and city selection, and organization registration logic.
class OrganizationRegistrationCubit
    extends Cubit<OrganizationRegistrationState> {
  /// Appwrite [Databases] instance for organization registration operations.
  final Databases db;

  /// Global key for the registration form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controller for the organization name input field.
  final TextEditingController organizationController = TextEditingController();

  /// Controller for the mobile number input field.
  final TextEditingController mobileController = TextEditingController();

  /// Controller for the contact person input field.
  final TextEditingController contactPersonController = TextEditingController();

  /// Controller for the email input field.
  final TextEditingController emailController = TextEditingController();

  /// Controller for the street address input field.
  final TextEditingController streetController = TextEditingController();

  /// Helper for accessing user preferences.
  final prefs = locator<PreferenceHelper>();

  /// Creates an [OrganizationRegistrationCubit] and initializes the state.
  OrganizationRegistrationCubit()
    : db = Databases(locator<AppwriteService>().client),
      super(OrganizationRegistrationState.initial());

  /// Sets the selected status for the organization.
  void setStatus(String? status) {
    emit(state.copyWith(selectedStatus: status));
  }

  /// Sets the selected designation for the contact person.
  void setDesignation(String? designation) {
    emit(state.copyWith(selectedDesignation: designation));
  }

  /// Sets the selected state and resets the city selection.
  void setStateName(String? stateName) {
    emit(state.copyWith(selectedState: stateName, selectedCity: null));
  }

  /// Sets the selected city.
  void setCity(String? city) {
    emit(state.copyWith(selectedCity: city));
  }

  /// Saves the organization registration form.
  ///
  /// Validates the form, checks user role, and sends the registration data to the server.
  Future<void> saveForm(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      UserModel? user = prefs.getUser();
      if (user?.role == UserRoles.admin) {
        try {
          await db.createDocument(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            documentId: ID.unique(),
            data: {
              'organizationName': organizationController.text,
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user?.role} role cannot register organization'),
          ),
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
