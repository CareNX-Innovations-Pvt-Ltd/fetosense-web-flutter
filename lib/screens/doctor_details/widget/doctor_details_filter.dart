import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';

class DoctorDetailsFilters extends StatelessWidget {
  final DoctorDetailsCubit cubit;
  final DoctorDetailsState state;

  const DoctorDetailsFilters({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "From Date",
                  selectedDate: state.fromDate,
                  controller: TextEditingController(
                    text: formatDate(state.fromDate?.toIso8601String()),
                  ),
                  onDateCleared: () => cubit.updateFromDate(null),
                  onDateSelected: (picked) => cubit.updateFromDate(picked),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "Till Date",
                  selectedDate: state.tillDate,
                  controller: TextEditingController(
                    text: formatDate(state.fromDate?.toIso8601String()),
                  ),
                  onDateCleared: () => cubit.updateTillDate(null),
                  onDateSelected: (picked) => cubit.updateTillDate(picked),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: cubit.fetchDoctorsId,
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
            onChanged: cubit.applySearchFilter,
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
}
