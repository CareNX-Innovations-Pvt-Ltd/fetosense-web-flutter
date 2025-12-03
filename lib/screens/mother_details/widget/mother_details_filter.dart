import 'package:fetosense_mis/screens/mother_details/mother_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MotherDetailsFilter extends StatelessWidget {
  const MotherDetailsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildSearchBar(context), _buildFilterSection(context)],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return BlocBuilder<MotherDetailsCubit, MotherDetailsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: buildDatePicker(
                  context,
                  'From Date',
                  state.fromDate,
                      (date) => context.read<MotherDetailsCubit>().setFromDate(date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildDatePicker(
                  context,
                  'Till Date',
                  state.tillDate,
                      (date) => context.read<MotherDetailsCubit>().setTillDate(date),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<MotherDetailsCubit>().fetchMothersId();
                },
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  context.read<MotherDetailsCubit>().setFromDate(null);
                  context.read<MotherDetailsCubit>().setTillDate(null);
                  context.read<MotherDetailsCubit>().fetchMothersId();
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

  Widget buildDatePicker(
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
                color: selectedDate != null ? Colors.white : Colors.grey,
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
      child: SizedBox(
        height: 48,
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search mothers...',
            prefixIcon: Icon(Icons.search, color: Colors.tealAccent),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<MotherDetailsCubit>().setSearchQuery(value);
          },
        ),
      ),
    );
  }
}
