import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/screens/device_edit/device_edit_view.dart';
import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_details_cubit.dart';
import 'widgets/device_details_filters.dart';
import 'widgets/device_details_header.dart';
import 'widgets/device_table.dart';

/// The main view for displaying device details.
///
/// Provides a [DeviceDetailsCubit] to manage state and renders the [_DeviceDetailsView].
class DeviceDetailsView extends StatelessWidget {
  /// Creates a [DeviceDetailsView] widget.
  const DeviceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceDetailsCubit()..init(),
      child: const _DeviceDetailsView(),
    );
  }
}

/// Internal widget that builds the device details UI.
///
/// Uses [BlocBuilder] to listen to [DeviceDetailsCubit] state and renders the device details table and filters.
class _DeviceDetailsView extends StatelessWidget {
  /// Creates a [_DeviceDetailsView] widget.
  const _DeviceDetailsView();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceDetailsCubit, DeviceDetailsState>(
      builder: (context, state) {
        final cubit = context.read<DeviceDetailsCubit>();

        return Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF181A1B),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFF272A2C)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DeviceDetailsHeader(),
              DeviceDetailsFilters(cubit: cubit, state: state),

              const SizedBox(height: 20),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
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

                        child: DeviceTable(state: state),
                      ),
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
