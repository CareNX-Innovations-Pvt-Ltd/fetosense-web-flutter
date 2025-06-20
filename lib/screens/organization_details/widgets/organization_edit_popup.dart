import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/state_map.dart';
import '../../../widget/columns.dart';
import 'edit_popup_widgets/stat_card.dart';
import 'edit_popup_widgets/tile_card.dart';
import 'organization_edit_form.dart';
import 'organization_info_panel.dart';

/// A StatefulWidget that represents the Organization Edit Popup.
///
/// This widget is used to edit the details of an organization. It allows the user to update
/// fields such as organization name, contact person, mobile number, email, address, status,
/// designation, state, and city. It uses a form with various input fields, including text fields
/// and dropdowns, to collect the new values. The changes are then sent to the database when the user
/// presses the "Update" button.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
/// The [data] represents the current organization data that will be populated into the form fields.
/// The [documentId] is the unique ID of the organization document that is being edited.
/// The [onClose] is a callback that is called when the popup is closed.
///
///
class OrganizationEditPopup extends StatefulWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final VoidCallback onClose;

  const OrganizationEditPopup({
    super.key,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  State<OrganizationEditPopup> createState() => _OrganizationEditPopupState();
}

class _OrganizationEditPopupState extends State<OrganizationEditPopup> {
  static List<String> stateList = indiaStatesWithCities.keys.toList();

  @override
  void initState() {
    super.initState();
    context.read<OrganizationCubit>().initializeOrganizationFields(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationCubit, OrganizationState>(
      builder: (context, state) {
        final cubit = context.read<OrganizationCubit>();

        return Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 1000),
          decoration: BoxDecoration(
            color: const Color(0xFF181A1B),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF3E4346)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: OrganizationInfoPanel(data: widget.data, cubit: cubit),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: OrganizationEditForm(
                    stateList: stateList,
                    cubit: cubit,
                    state: state,
                    documentId: widget.documentId,
                    onClose: widget.onClose,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
