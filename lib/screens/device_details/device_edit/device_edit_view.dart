import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_editform.dart';
import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/appwrite.dart';

import 'device_edit_cubit.dart';

/// A popup widget for editing device details.
///
/// Wraps the [_DeviceEditView] with a [BlocProvider] and initializes the cubit with device data.
class DeviceEditPopup extends StatelessWidget {
  /// The device data to edit.
  final Map<String, dynamic> data;

  /// The document ID of the device.
  final String documentId;

  /// Callback to close the popup.
  final VoidCallback onClose;

  /// Creates a [DeviceEditPopup] widget.
  const DeviceEditPopup({
    super.key,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final client = locator<AppwriteService>().client;
    final db = Databases(client);

    return BlocProvider(
      create:
          (_) =>
              DeviceEditCubit(db: db, documentId: documentId)..initialize(data),
      child: _DeviceEditView(data: data, onClose: onClose),
    );
  }
}

/// Internal widget that builds the device edit UI.
///
/// Uses [BlocBuilder] to listen to [DeviceEditCubit] state and renders the edit form.
class _DeviceEditView extends StatelessWidget {
  /// The device data to edit.
  final Map<String, dynamic> data;

  /// Callback to close the popup.
  final VoidCallback onClose;

  /// Creates a [_DeviceEditView] widget.
  const _DeviceEditView({required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeviceEditCubit>();

    return BlocListener<DeviceEditCubit, DeviceEditState>(
      listener: (context, state) {
        if (state is DeviceEditSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Device updated successfully')),
          );
          onClose();
        } else if (state is DeviceEditError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        decoration: BoxDecoration(
          color: const Color(0xFF181A1B),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF3E4346)),
        ),
        child: Row(
          children: [
            DeviceInfoCard(data: data),
            DeviceEditForm(cubit: cubit, onClose: onClose),
          ],
        ),
      ),
    );
  }
}
