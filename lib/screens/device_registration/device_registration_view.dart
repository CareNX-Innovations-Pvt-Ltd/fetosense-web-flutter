import 'package:appwrite/appwrite.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/device_registration/device_registration_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// Widget for device registration screen that uses the Cubit pattern.
class DeviceRegistration extends StatelessWidget {
  const DeviceRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    // Get appwrite client from your service locator
    final client = locator<AppwriteService>().client;

    return BlocProvider(
      create: (context) => DeviceRegistrationCubit(
        db: Databases(client),
      )..fetchOrganizations(),
      child: const DeviceRegistrationView(),
    );
  }
}

/// The main view for device registration that consumes the DeviceRegistrationCubit.
class DeviceRegistrationView extends StatefulWidget {
  const DeviceRegistrationView({super.key});

  @override
  State<DeviceRegistrationView> createState() => _DeviceRegistrationViewState();
}

class _DeviceRegistrationViewState extends State<DeviceRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final deviceNameController = TextEditingController();
  final kitIdController = TextEditingController();
  final tabletSerialNumberController = TextEditingController();
  final tocoIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners to update cubit when text changes
    deviceNameController.addListener(_updateDeviceName);
    kitIdController.addListener(_updateKitId);
    tabletSerialNumberController.addListener(_updateTabletSerialNumber);
    tocoIdController.addListener(_updateTocoId);
  }

  void _updateDeviceName() {
    context.read<DeviceRegistrationCubit>().updateDeviceName(deviceNameController.text);
  }

  void _updateKitId() {
    context.read<DeviceRegistrationCubit>().updateKitId(kitIdController.text);
  }

  void _updateTabletSerialNumber() {
    context.read<DeviceRegistrationCubit>().updateTabletSerialNumber(tabletSerialNumberController.text);
  }

  void _updateTocoId() {
    context.read<DeviceRegistrationCubit>().updateTocoId(tocoIdController.text);
  }

  @override
  void dispose() {
    deviceNameController.dispose();
    kitIdController.dispose();
    tabletSerialNumberController.dispose();
    tocoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceRegistrationCubit, DeviceRegistrationState>(
      listener: (context, state) {
        // Show error message if there is one
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
          context.read<DeviceRegistrationCubit>().clearError();
        }

        // Show success message if registration was successful
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Device registered successfully!')),
          );

          // Reset the form
          _formKey.currentState?.reset();
          deviceNameController.clear();
          kitIdController.clear();
          tabletSerialNumberController.clear();
          tocoIdController.clear();

          context.read<DeviceRegistrationCubit>().resetSuccess();
        }
      },
      builder: (context, state) {
        return Container(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF272A2C),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFF3E4346), width: 0.5),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F2223),
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 0.5),
                      ),
                    ),
                    child: const Text(
                      "Device Registration",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Container(
                    color: const Color(0xFF181A1B),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildFormFields(context, state),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : () => _saveForm(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF19607A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: state.isSubmitting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Save", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the form fields for the device registration form.
  Widget _buildFormFields(BuildContext context, DeviceRegistrationState state) {
    return Column(
      children: [
        _buildRow([
          _buildOrganizationDropdown(context, state),
          _buildColumnWithDropdown(
            "Product Type",
            state.productTypeList,
            state.selectedProductType,
            "Select Product Type",
                (value) => context.read<DeviceRegistrationCubit>().updateSelectedProductType(value),
            true,
          ),
        ]),
        _buildRow([
          _buildColumnWithTextField(
            "Device Name (Bluetooth)",
            deviceNameController,
            "Enter Device Name",
            true,
          ),
          _buildColumnWithTextField(
            "Kit Id",
            kitIdController,
            "Enter Kit Id",
            true,
          ),
        ]),
        _buildRow([
          _buildColumnWithTextField(
            "Tablet Serial Number",
            tabletSerialNumberController,
            "Enter Tablet Serial Number",
            false,
          ),
          _buildColumnWithTextField(
            "Toco Id",
            tocoIdController,
            "Enter your Toco Id",
            false,
          ),
        ]),
      ],
    );
  }

  /// Builds the organization dropdown widget for selecting an organization.
  Widget _buildOrganizationDropdown(BuildContext context, DeviceRegistrationState state) {
    return _buildColumnWithDropdown(
      "Organization",
      state.organizationList.map((e) => e['name']!).toList(),
      state.selectedOrganizationName,
      "Select Organization",
          (value) {
        final selected = state.organizationList.firstWhere((e) => e['name'] == value);
        context.read<DeviceRegistrationCubit>().updateSelectedOrganization(
          selected['name']!,
          selected['id']!,
        );
      },
      true,
    );
  }

  /// Builds a row of widgets with equal spacing between them.
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: children
            .map(
              (e) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: e,
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  /// Builds a column with a text field widget for input.
  Widget _buildColumnWithTextField(
      String label,
      TextEditingController controller,
      String hintText,
      bool isRequired, {
        bool isNumber = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        const SizedBox(height: 6),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.grey),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: _inputDecoration(hintText),
            validator: isRequired
                ? (value) => (value == null || value.isEmpty)
                ? "$label is required"
                : null
                : null,
          ),
        ),
      ],
    );
  }

  /// Builds a column with a dropdown widget for selection.
  Widget _buildColumnWithDropdown(
      String label,
      List<String> items,
      String? selectedValue,
      String hintText,
      Function(String?) onChanged,
      bool isRequired,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ),
            )
                .toList(),
            onChanged: onChanged,
            decoration: _inputDecoration(hintText),
            dropdownColor: Colors.black45,
            validator: isRequired
                ? (value) => (value == null || value.isEmpty)
                ? "$label is required"
                : null
                : null,
          ),
        ),
      ],
    );
  }

  /// Creates the input decoration for form fields with hints and styling.
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF181A1B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1),
        borderSide: const BorderSide(color: Color(0xFF373B3E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1),
        borderSide: const BorderSide(color: Color(0xFF373B3E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1),
        borderSide: const BorderSide(color: Color(0xFF373B3E), width: 1),
      ),
    );
  }

  /// Builds the label for the form fields, optionally including an asterisk if required.
  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  /// Handles the saving of the form by validating and then submitting to cubit.
  void _saveForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<DeviceRegistrationCubit>().registerDevice();
    }
  }
}
