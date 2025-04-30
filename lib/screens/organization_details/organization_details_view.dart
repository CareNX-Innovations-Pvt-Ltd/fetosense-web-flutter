import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_edit_popup.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;


class OrganizationDetailsPageView extends StatefulWidget {
  const OrganizationDetailsPageView({super.key});

  @override
  State<OrganizationDetailsPageView> createState() => _OrganizationDetailsPageViewState();
}

class _OrganizationDetailsPageViewState extends State<OrganizationDetailsPageView> {
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
      create: (context) => OrganizationCubit(
        db: Databases(client),
        context: context,
      ),
      child: BlocConsumer<OrganizationCubit, OrganizationState>(
        listener: (context, state) {
          // Show error messages if needed
          if (state.status == OrganizationStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          // Update date controllers when dates change
          if (state.fromDate != null && fromDateController.text.isEmpty) {
            fromDateController.text = formatDate(state.fromDate!.toIso8601String());
          } else if (state.fromDate == null) {
            fromDateController.clear();
          }

          if (state.tillDate != null && tillDateController.text.isEmpty) {
            tillDateController.text = formatDate(state.tillDate!.toIso8601String());
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
            _buildHeader(context),
            _buildFilters(context),
            const SizedBox(height: 20),
            _buildOrganizationsTable(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1F2223),
        border: Border(
          bottom: BorderSide(color: Color(0xFF3E4346), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.apartment, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Organization Details",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => context.read<OrganizationCubit>().downloadExcel(),
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "From Date",
                  selectedDate: context.read<OrganizationCubit>().state.fromDate,
                  controller: fromDateController,
                  onDateCleared: () =>
                      context.read<OrganizationCubit>().setFromDate(null),
                  onDateSelected: (picked) =>
                      context.read<OrganizationCubit>().setFromDate(picked),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "Till Date",
                  selectedDate: context.read<OrganizationCubit>().state.tillDate,
                  controller: tillDateController,
                  onDateCleared: () =>
                      context.read<OrganizationCubit>().setTillDate(null),
                  onDateSelected: (picked) =>
                      context.read<OrganizationCubit>().setTillDate(picked),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<OrganizationCubit>().fetchOrganizations(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Color(0xFF1A86AD)),
                  ),
                  child: const Text(
                    "Get Data",
                    style: TextStyle(color: Color(0xFF1A86AD)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF181A1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationsTable(BuildContext context, OrganizationState state) {
    if (state.status == OrganizationStatus.loading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 16,
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFF181A1B),
          ),
          columns: const [
            DataColumn(
              label: Text(
                "Name",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Device",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Doctors",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Mother",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Test",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Mobile",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Status",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Created On",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Address",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Email",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Action",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: state.filteredOrganizations.map((org) {
            final data = org.data;
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    data['name'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['device']?.toString() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['doctors']?.toString() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['mother']?.toString() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['test']?.toString() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['mobile'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['status'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    formatDate(data['createdOn']),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    '${data['addressLine'] ?? ''}, ${data['city'] ?? ''}, ${data['state'] ?? ''}, ${data['country'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    data['email'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  TextButton(
                    onPressed: () {
                      _showEditDialog(context, org);
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
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