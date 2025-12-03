import 'package:fetosense_mis/screens/mother_details/widget/mother_details_filter.dart';
import 'package:fetosense_mis/screens/mother_details/widget/mother_details_table.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mother_details_cubit.dart';

class MotherDetailsView extends StatelessWidget {
  const MotherDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MotherDetailsCubit(),
      child: const MotherDetails(),
    );
  }
}

class MotherDetails extends StatelessWidget {
  const MotherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = context.read<MotherDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF181A1B),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFF272A2C)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const MotherDetailsFilter(),
              const Divider(color: Colors.grey),
              // _buildFilterSection(context),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<MotherDetailsCubit, MotherDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
                    }

                    if (state.errorMessage != null) {
                      return Center(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    // Wrap your MotherDetailsTable inside vertical & horizontal scroll views
                    return SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // scroll horizontally for DataTable2
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width:
                              MediaQuery.of(context).size.width *
                              0.8, // or any suitable ratio

                          child: MotherDetailsTable(
                            filteredMothers: state.filteredMothers,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cubit = context.read<MotherDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.apartment, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            "Mother Details",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => cubit.downloadExcel(context),
            tooltip: 'Download Excel',
          ),
        ],
      ),
    );
  }

}
