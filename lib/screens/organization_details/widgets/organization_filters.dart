import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../organization_details_cubit.dart';

class OrganizationFilter extends StatelessWidget {
  const OrganizationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildSearchBar(context), _buildFilterSection(context)],
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
      child: SizedBox(
        height: 48, // or whatever fits your design
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
      ),
    );
  }
}
