import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widget/organization_filters.dart';
import 'package:fetosense_mis/screens/organization_details/widget/organization_header.dart';
import 'package:fetosense_mis/screens/organization_details/widget/organizations_table.dart';
import 'package:fetosense_mis/widget/organization_edit_popup.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:data_table_2/data_table_2.dart';

class OrganizationDetailsPageView extends StatefulWidget {
  const OrganizationDetailsPageView({super.key});

  @override
  State<OrganizationDetailsPageView> createState() =>
      _OrganizationDetailsPageViewState();
}

class _OrganizationDetailsPageViewState
    extends State<OrganizationDetailsPageView> {
  late final Client client;
  late final TextEditingController fromDateController;
  late final TextEditingController tillDateController;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    client = locator<AppwriteService>().client;
    fromDateController = TextEditingController();
    tillDateController = TextEditingController();
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    fromDateController.dispose();
    tillDateController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<OrganizationCubit>().updateSearchQuery(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              OrganizationCubit(db: Databases(client), context: context),
      child: BlocConsumer<OrganizationCubit, OrganizationState>(
        listener: (context, state) {
          // Show error messages if needed
          if (state.status == OrganizationStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          // Update date controllers when dates change
          if (state.fromDate != null && fromDateController.text.isEmpty) {
            fromDateController.text = formatDate(
              state.fromDate!.toIso8601String(),
            );
          } else if (state.fromDate == null) {
            fromDateController.clear();
          }

          if (state.tillDate != null && tillDateController.text.isEmpty) {
            tillDateController.text = formatDate(
              state.tillDate!.toIso8601String(),
            );
          } else if (state.tillDate == null) {
            tillDateController.clear();
          }
        },
        builder: (context, state) {
          return _buildPageContent(context, state);
        },
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, OrganizationState state) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181A1B),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF272A2C), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrganizationHeader(),
            OrganizationFilters(
              fromDateController: fromDateController,
              tillDateController: tillDateController,
              searchController: searchController,
            ),

            const SizedBox(height: 20),
            OrganizationsTableWidget(
              state: state,
              onEdit: (context, org) => _showEditDialog(context, org),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, models.Document org) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(dialogContext).size.width * 0.6,
            height: 600,
            child: OrganizationEditPopup(
              client: client,
              data: org.data,
              documentId: org.$id,
              onClose: () {
                Navigator.pop(dialogContext);
                // Refresh data after editing
                context.read<OrganizationCubit>().fetchOrganizations();
              },
            ),
          ),
        );
      },
    );
  }
}
