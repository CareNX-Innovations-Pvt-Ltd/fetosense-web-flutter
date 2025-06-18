import 'dart:developer';

import 'package:fetosense_mis/screens/organization_details/organization_details_cubit.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_filters.dart';
import 'package:fetosense_mis/screens/organization_details/widgets/organization_table.dart';
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
  const OrganizationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrganizationCubit>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181A1B),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF272A2C)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.apartment, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Organization Details',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () {
                      cubit.downloadExcel();
                    },
                    tooltip: 'Download Excel',
                  ),
                ],
              ),
            ),
            const OrganizationFilter(),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // scroll horizontally for DataTable2
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // or any suitable ratio

                    child: const OrganizationDataTableWidget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
