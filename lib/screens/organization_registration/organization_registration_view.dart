import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'organization_registration_cubit.dart';

class OrganizationRegistrationView extends StatelessWidget {
  const OrganizationRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrganizationRegistrationCubit(),
      child: const _OrganizationRegistrationForm(),
    );
  }
}

class _OrganizationRegistrationForm extends StatelessWidget {
  const _OrganizationRegistrationForm();

  static const List<String> statusList = ["Trial", "Demo", "Sold"];
  static const List<String> designationList = ["Manager", "Executive", "Admin"];
  static const List<String> stateList = ["Maharashtra", "Karnataka", "Gujarat"];
  static const Map<String, List<String>> cityMap = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bangalore", "Mysore"],
    "Gujarat": ["Ahmedabad", "Surat"],
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrganizationRegistrationCubit>();
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Form(
        key: cubit.formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Organization Registration",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildFields(context),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => cubit.saveForm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFields(BuildContext context) {
    final cubit = context.read<OrganizationRegistrationCubit>();
    return Column(
      children: [
        _row([
          _textField("Organization", cubit.organizationController, true),
          _textField("Mobile", cubit.mobileController, true, isNumber: true),
        ]),
        _row([
          _dropdownField(
            label: "Status",
            items: statusList,
            value: context.select(
              (OrganizationRegistrationCubit c) => c.state.selectedStatus,
            ),
            onChanged: cubit.setStatus,
          ),
          _dropdownField(
            label: "Designation",
            items: designationList,
            value: context.select(
              (OrganizationRegistrationCubit c) => c.state.selectedDesignation,
            ),
            onChanged: cubit.setDesignation,
          ),
        ]),
        _row([
          _textField("Contact Person", cubit.contactPersonController, true),
          _textField("Email", cubit.emailController, false),
        ]),
        _row([_textField("Street", cubit.streetController, true)]),
        _row([
          _dropdownField(
            label: "Country",
            items: const ["India"],
            value: "India",
            onChanged: (_) {},
          ),
          _dropdownField(
            label: "State",
            items: stateList,
            value: context.select(
              (OrganizationRegistrationCubit c) => c.state.selectedState,
            ),
            onChanged: cubit.setStateName,
          ),
          _dropdownField(
            label: "City",
            items: cityMap[cubit.state.selectedState] ?? [],
            value: context.select(
              (OrganizationRegistrationCubit c) => c.state.selectedCity,
            ),
            onChanged: cubit.setCity,
          ),
        ]),
      ],
    );
  }

  Widget _row(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children:
            children
                .map(
                  (e) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: e,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller,
    bool required, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.grey),
          decoration: _inputDecoration(label),
          validator:
              required
                  ? (v) =>
                      (v == null || v.isEmpty) ? "$label is required" : null
                  : null,
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, true),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(label),
          dropdownColor: Colors.black45,
        ),
      ],
    );
  }

  Widget _label(String label, bool required) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        if (required) const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }
}
