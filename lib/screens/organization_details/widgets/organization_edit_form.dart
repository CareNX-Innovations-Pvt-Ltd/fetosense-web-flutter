import 'package:fetosense_mis/core/utils/state_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widget/columns.dart';
import '../organization_details_cubit.dart';

class OrganizationEditForm extends StatelessWidget {
  final OrganizationCubit cubit;
  final OrganizationState state;
  final String documentId;
  final VoidCallback onClose;
  final List<String> stateList;

  const OrganizationEditForm({
    super.key,
    required this.cubit,
    required this.state,
    required this.documentId,
    required this.onClose,
    required this.stateList,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Organization Details",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          buildNameAndTypeRow(cubit, state),
          const SizedBox(height: 5),
          buildContactAndDesignationRow(cubit, state),
          const SizedBox(height: 5),
          buildMobileAndEmailRow(cubit),
          const SizedBox(height: 5),
          buildAddressField(cubit),
          const SizedBox(height: 5),
          buildStateAndCityRow(cubit, state, stateList, indiaStatesWithCities),
          const SizedBox(height: 20),
          buildActionButtons(cubit, context, documentId, onClose),
        ],
      ),
    );
  }
}

Widget buildNameAndTypeRow(OrganizationCubit cubit, OrganizationState state) {
  return Row(
    children: [
      Expanded(
        child: buildColumnWithTextField(
          "Organization Name",
          cubit.nameController,
          "Enter organization name",
          false,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: buildColumnWithDropdown(
          "Type",
          ['sold', 'demo', 'testing'],
          state.selectedType,
          "Select type",
          (val) => cubit.setSelectedType(val),
          false,
        ),
      ),
    ],
  );
}

Widget buildContactAndDesignationRow(
  OrganizationCubit cubit,
  OrganizationState state,
) {
  return Row(
    children: [
      Expanded(
        child: buildColumnWithTextField(
          "Contact Person",
          cubit.contactPersonController,
          "Enter contact person",
          false,
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: buildColumnWithDropdown(
          "Designation",
          ['Admin', 'Staff'],
          state.selectedDesignation,
          "Select designation",
          (val) => cubit.setSelectedDesignation(val),
          false,
        ),
      ),
    ],
  );
}

Widget buildMobileAndEmailRow(OrganizationCubit cubit) {
  return Row(
    children: [
      Expanded(
        child: buildColumnWithTextField(
          "Mobile",
          cubit.mobileController,
          "Enter mobile",
          true,
          isNumber: true,
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: buildColumnWithTextField(
          "Email",
          cubit.emailController,
          "Enter email",
          false,
        ),
      ),
    ],
  );
}

Widget buildAddressField(OrganizationCubit cubit) {
  return buildColumnWithTextField(
    "Address",
    cubit.addressController,
    "Enter address",
    false,
  );
}

Widget buildStateAndCityRow(
  OrganizationCubit cubit,
  OrganizationState state,
  List<String> stateList,
  Map<String, List<String>> indiaStatesWithCities,
) {
  return Row(
    children: [
      Expanded(
        child: buildColumnWithDropdown(
          "State",
          stateList,
          state.selectedState,
          "Select state",
          (val) => cubit.setSelectedState(val),
          false,
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: buildColumnWithDropdown(
          "City",
          state.selectedState != null &&
                  indiaStatesWithCities.containsKey(state.selectedState)
              ? indiaStatesWithCities[state.selectedState]!
              : [],
          state.selectedCity,
          "Select city",
          (val) => cubit.setSelectedCity(val),
          false,
        ),
      ),
    ],
  );
}

Widget buildActionButtons(
  OrganizationCubit cubit,
  BuildContext context,
  String documentId,
  VoidCallback onClose,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      OutlinedButton(
        onPressed: () {
          if (cubit.formKey.currentState!.validate()) {
            cubit.updateChanges(documentId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Organization updated successfully"),
              ),
            );
            Navigator.pop(context);
          }
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF1A86AD)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: const Text("Update", style: TextStyle(color: Color(0xFF1A86AD))),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: onClose,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A86AD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: const Text("Cancel"),
      ),
    ],
  );
}
