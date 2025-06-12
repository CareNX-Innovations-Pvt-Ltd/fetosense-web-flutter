// import 'package:fetosense_mis/core/network/appwrite_config.dart';
// import 'package:fetosense_mis/core/network/dependency_injection.dart';
// import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
// import 'package:fetosense_mis/widget/organization_edit_popup.dart';
// import 'package:fetosense_mis/utils/format_date.dart';
// import 'package:fetosense_mis/widget/custom_date_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
//
//
// class OrganizationDetailsPageView extends StatefulWidget {
//   const OrganizationDetailsPageView({super.key});
//
//   @override
//   State<OrganizationDetailsPageView> createState() => _OrganizationDetailsPageViewState();
// }
//
// class _OrganizationDetailsPageViewState extends State<OrganizationDetailsPageView> {
//   late final Client client;
//   late final TextEditingController fromDateController;
//   late final TextEditingController tillDateController;
//   late final TextEditingController searchController;
//
//   @override
//   void initState() {
//     super.initState();
//     client = locator<AppwriteService>().client;
//     fromDateController = TextEditingController();
//     tillDateController = TextEditingController();
//     searchController = TextEditingController();
//     searchController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     fromDateController.dispose();
//     tillDateController.dispose();
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     context.read<OrganizationCubit>().updateSearchQuery(searchController.text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => OrganizationCubit(
//         db: Databases(client),
//         context: context,
//       ),
//       child: BlocConsumer<OrganizationCubit, OrganizationState>(
//         listener: (context, state) {
//           // Show error messages if needed
//           if (state.status == OrganizationStatus.error && state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errorMessage!)),
//             );
//           }
//
//           // Update date controllers when dates change
//           if (state.fromDate != null && fromDateController.text.isEmpty) {
//             fromDateController.text = formatDate(state.fromDate!.toIso8601String());
//           } else if (state.fromDate == null) {
//             fromDateController.clear();
//           }
//
//           if (state.tillDate != null && tillDateController.text.isEmpty) {
//             tillDateController.text = formatDate(state.tillDate!.toIso8601String());
//           } else if (state.tillDate == null) {
//             tillDateController.clear();
//           }
//         },
//         builder: (context, state) {
//           return _buildPageContent(context, state);
//         },
//       ),
//     );
//   }
//
//   Widget _buildPageContent(BuildContext context, OrganizationState state) {
//     return Container(
//       alignment: Alignment.topCenter,
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF181A1B),
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: const Color(0xFF272A2C), width: 1),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildHeader(context),
//             _buildFilters(context),
//             const SizedBox(height: 20),
//             _buildOrganizationsTable(context, state),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: Color(0xFF1F2223),
//         border: Border(
//           bottom: BorderSide(color: Color(0xFF3E4346), width: 0.5),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.apartment, color: Colors.white, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 "Organization Details",
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//               ),
//             ],
//           ),
//           IconButton(
//             icon: const Icon(Icons.download, color: Colors.white),
//             onPressed: () => context.read<OrganizationCubit>().downloadExcel(),
//             tooltip: 'Download Excel',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilters(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8.0,
//         horizontal: 15.0,
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: customDatePicker(
//                   context: context,
//                   label: "From Date",
//                   selectedDate: context.read<OrganizationCubit>().state.fromDate,
//                   controller: fromDateController,
//                   onDateCleared: () =>
//                       context.read<OrganizationCubit>().setFromDate(null),
//                   onDateSelected: (picked) =>
//                       context.read<OrganizationCubit>().setFromDate(picked),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: customDatePicker(
//                   context: context,
//                   label: "Till Date",
//                   selectedDate: context.read<OrganizationCubit>().state.tillDate,
//                   controller: tillDateController,
//                   onDateCleared: () =>
//                       context.read<OrganizationCubit>().setTillDate(null),
//                   onDateSelected: (picked) =>
//                       context.read<OrganizationCubit>().setTillDate(picked),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               SizedBox(
//                 height: 40,
//                 child: ElevatedButton(
//                   onPressed: () =>
//                       context.read<OrganizationCubit>().fetchOrganizations(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     side: const BorderSide(color: Color(0xFF1A86AD)),
//                   ),
//                   child: const Text(
//                     "Get Data",
//                     style: TextStyle(color: Color(0xFF1A86AD)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: searchController,
//             style: const TextStyle(color: Colors.white),
//             decoration: const InputDecoration(
//               prefixIcon: Icon(Icons.search, color: Colors.white),
//               hintText: 'Search',
//               hintStyle: TextStyle(color: Colors.grey),
//               filled: true,
//               fillColor: Color(0xFF181A1B),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrganizationsTable(BuildContext context, OrganizationState state) {
//     if (state.status == OrganizationStatus.loading) {
//       return const Expanded(
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Expanded(
//       child: SingleChildScrollView(
//         child: DataTable(
//           columnSpacing: 16,
//           headingRowColor: WidgetStateProperty.all(
//             const Color(0xFF181A1B),
//           ),
//           columns: const [
//             DataColumn(
//               label: Text(
//                 "Name",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Device",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Doctors",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Mother",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Test",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Mobile",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Status",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Created On",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Address",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Email",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 "Action",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//           rows: state.filteredOrganizations.map((org) {
//             final data = org.data;
//             return DataRow(
//               cells: [
//                 DataCell(
//                   Text(
//                     data['name'] ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['device']?.toString() ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['doctors']?.toString() ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['mother']?.toString() ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['test']?.toString() ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['mobile'] ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['status'] ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     formatDate(data['createdOn']),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     '${data['addressLine'] ?? ''}, ${data['city'] ?? ''}, ${data['state'] ?? ''}, ${data['country'] ?? ''}',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   Text(
//                     data['email'] ?? '',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 DataCell(
//                   TextButton(
//                     onPressed: () {
//                       _showEditDialog(context, org);
//                     },
//                     child: const Text(
//                       "Edit",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   void _showEditDialog(BuildContext context, models.Document org) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return Dialog(
//           insetPadding: const EdgeInsets.all(20),
//           backgroundColor: Colors.transparent,
//           child: SizedBox(
//             width: MediaQuery.of(dialogContext).size.width * 0.6,
//             height: 600,
//             child: OrganizationEditPopup(
//               client: client,
//               data: org.data,
//               documentId: org.$id,
//               onClose: () {
//                 Navigator.pop(dialogContext);
//                 // Refresh data after editing
//                 context.read<OrganizationCubit>().fetchOrganizations();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// The main page view for displaying organization details.
///
/// Provides a [OrganizationCubit] to manage state and renders the [OrganizationDetailsView].
class OrganizationDetailsPageView extends StatelessWidget {
  /// Creates an [OrganizationDetailsPageView] widget.
  const OrganizationDetailsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrganizationCubit(context: context),
      child: const OrganizationDetailsView(),
    );
  }
}

/// The main view for displaying organization details.
///
/// Uses [BlocBuilder] to listen to [OrganizationCubit] state and renders the organization details UI.
class OrganizationDetailsView extends StatelessWidget {
  /// Creates an [OrganizationDetailsView] widget.
  const OrganizationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A1B),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.apartment, color: Colors.white),
            SizedBox(width: 8),
            Text('Organization Details', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              context.read<OrganizationCubit>().downloadExcel();
            },
            tooltip: 'Download Excel',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(context),
          _buildSearchBar(context),
          const Divider(),
          const SizedBox(height: 10),
          Expanded(child: _buildOrganizationsList(context)),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return BlocBuilder<OrganizationCubit, OrganizationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  context,
                  'From Date',
                  state.fromDate,
                  (date) => context.read<OrganizationCubit>().setFromDate(date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDatePicker(
                  context,
                  'Till Date',
                  state.tillDate,
                  (date) => context.read<OrganizationCubit>().setTillDate(date),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<OrganizationCubit>().fetchOrganizationDetails();
                },
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  context.read<OrganizationCubit>().setFromDate(null);
                  context.read<OrganizationCubit>().setTillDate(null);
                  context.read<OrganizationCubit>().fetchOrganizationDetails();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onDateSelected,
  ) {
    final dateFormat = DateFormat('dd MMM, yyyy');

    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null ? dateFormat.format(selectedDate) : label,
              style: TextStyle(
                color: selectedDate != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: Colors.tealAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search organizations...',
          prefixIcon: Icon(Icons.search, color: Colors.tealAccent),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          context.read<OrganizationCubit>().updateSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildOrganizationsList(BuildContext context) {
    return BlocBuilder<OrganizationCubit, OrganizationState>(
      builder: (context, state) {
        switch (state.status) {
          case OrganizationStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case OrganizationStatus.error:
            return Center(child: Text('Error: ${state.errorMessage}'));

          case OrganizationStatus.loaded:
            if (state.filteredOrganizationDetails.isEmpty) {
              return const Center(child: Text('No organizations found'));
            }

            return ListView.builder(
              itemCount: state.filteredOrganizationDetails.length,
              itemBuilder: (context, index) {
                final orgDetail = state.filteredOrganizationDetails[index];
                final org = orgDetail.organizations.first;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.black,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.data['name'] ?? 'Unknown Organization',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildCountItem(
                              context,
                              'Devices',
                              orgDetail.deviceCount,
                              Icons.devices,
                            ),
                            _buildCountItem(
                              context,
                              'Mothers',
                              orgDetail.motherCount,
                              Icons.person,
                            ),
                            _buildCountItem(
                              context,
                              'Doctors',
                              orgDetail.doctorCount,
                              Icons.medical_information_outlined,
                            ),
                            _buildCountItem(
                              context,
                              'Tests',
                              orgDetail.testCount,
                              Icons.assessment,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (org.data['createdOn'] != null)
                          Text(
                            'Created: ${DateFormat('dd MMM, yyyy').format(DateTime.parse(org.data['createdOn']))}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );

          default:
            return const Center(child: Text('No organizations loaded'));
        }
      },
    );
  }

  Widget _buildCountItem(
    BuildContext context,
    String label,
    int count,
    IconData icon,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(height: 6),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
