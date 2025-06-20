import 'package:flutter/material.dart';
import '../organization_details_cubit.dart';
import 'edit_popup_widgets/stat_card.dart';
import 'edit_popup_widgets/tile_card.dart';

class OrganizationInfoPanel extends StatelessWidget {
  final Map<String, dynamic> data;
  final OrganizationCubit cubit;

  const OrganizationInfoPanel({
    super.key,
    required this.data,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1F2224), const Color(0xFF181A1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF3E91C8), Color(0xFF1A5A7A)],
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.business, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 12),
          Text(
            data['organizationName'] ?? 'Organization Name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            data['mobile'] ?? '',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade700),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  count: data['mother']?.toString() ?? "0",
                  label: "Mothers",
                  icon: Icons.pregnant_woman,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  count: data['test']?.toString() ?? "0",
                  label: "Tests",
                  icon: Icons.monitor_heart,
                  color: Colors.teal.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TileCard(
            label: "Address",
            value:
                cubit.addressController.text.isEmpty
                    ? "NA"
                    : cubit.addressController.text,
          ),
        ],
      ),
    );
  }
}
