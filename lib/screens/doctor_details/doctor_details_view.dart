import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/widget/doctor_edit_popup.dart'
    show DoctorEditPopup;
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/doctor_details_filter.dart';
import 'widgets/doctor_details_table.dart';
import 'widgets/doctor_header.dart';

/// The main view for displaying doctor details.
///
/// Provides a [DoctorDetailsCubit] to manage state and renders the doctor details UI,
/// including filters, search, and a table of doctor data.
class DoctorDetailsView extends StatelessWidget {
  /// Creates a [DoctorDetailsView] widget.
  const DoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorDetailsCubit>();
    cubit.fetchDoctorsId();

    return BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
      builder: (context, state) {
        final cubit = context.read<DoctorDetailsCubit>();
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
                const DoctorDetailsHeader(),
                DoctorDetailsFilters(cubit: cubit, state: state),

                const SizedBox(height: 20),
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

                        child: DoctorDetailsTable(state: state),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
