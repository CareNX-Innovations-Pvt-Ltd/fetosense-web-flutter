import 'package:fetosense_mis/utils/format_date.dart';
import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';

class DeviceDetailsFilters extends StatelessWidget {
  final DeviceDetailsCubit cubit;
  final DeviceDetailsState state;

  const DeviceDetailsFilters({
    Key? key,
    required this.cubit,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  onDateSelected: cubit.updateFromDate,
                  onDateCleared: () => cubit.updateFromDate(null),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: customDatePicker(
                  context: context,
                  label: "Till Date",
                  selectedDate: state.tillDate,
                  controller: TextEditingController(
                    text: formatDate(
                      state.tillDate?.toIso8601String(),
                    ), // fixed to tillDate here
                  ),
                  onDateSelected: cubit.updateTillDate,
                  onDateCleared: () => cubit.updateTillDate(null),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: cubit.fetchDeviceData,
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
            onChanged: cubit.applySearch,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF181A1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
