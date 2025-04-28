import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

/// A StatefulWidget for the Organization Registration page.
///
/// This page allows users to register a new organization by providing details such as
/// organization name, mobile number, contact person, email, address, and selecting
/// various dropdowns for status, designation, state, and city. It uses form validation
/// and sends the data to the Appwrite backend when the user presses the "Save" button.
class OrganizationRegistration extends StatefulWidget {
  const OrganizationRegistration({super.key});

  @override
  State createState() => _OrganizationRegistrationState();
}

class _OrganizationRegistrationState extends State<OrganizationRegistration> {
  final _formKey = GlobalKey<FormState>();
  late Databases db;
  final client = locator<AppwriteService>().client;
  // Text controllers for each form field
  TextEditingController organizationController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  // Dropdown selection values
  String? selectedStatus;
  String? selectedDesignation;
  String? selectedState;
  String? selectedCity;

  // Predefined lists for dropdowns
  List<String> statusList = ["Trial", "Demo", "Sold"];
  List<String> designationList = ["Manager", "Executive", "Admin"];
  List<String> stateList = ["Maharashtra", "Karnataka", "Gujarat"];
  Map<String, List<String>> cityMap = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bangalore", "Mysore"],
    "Gujarat": ["Ahmedabad", "Surat"],
  };

  @override
  void initState() {
    super.initState();
    db = Databases(client);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                child: const Text(
                  "Organization Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildFormFields(),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  }

  /// Builds the form fields for the organization registration form.
  Widget _buildFormFields() {
    return Column(
      children: [
        _buildRow([
          // Row for Organization and Mobile fields
          _buildColumnWithTextField(
            "Organization",
            organizationController,
            "Enter organization name",
            true,
          ),
          _buildColumnWithTextField(
            "Mobile",
            mobileController,
            "Enter mobile number",
            true,
            isNumber: true,
          ),
        ]),
        _buildRow([
          // Row for Status and Designation dropdowns
          _buildColumnWithDropdown(
            "Status",
            statusList,
            selectedStatus,
            "Select status",
            (value) {
              setState(() => selectedStatus = value);
            },
            true,
          ),
          _buildColumnWithDropdown(
            "Designation",
            designationList,
            selectedDesignation,
            "Select designation",
            (value) {
              setState(() => selectedDesignation = value);
            },
            true,
          ),
        ]),
        _buildRow([
          // Row for Contact Person and Email fields
          _buildColumnWithTextField(
            "Contact Person",
            contactPersonController,
            "Enter contact person name",
            true,
          ),
          _buildColumnWithTextField(
            "Email",
            emailController,
            "Enter your email",
            false,
          ),
        ]),
        _buildRow([
          // Row for Street field
          _buildColumnWithTextField(
            "Street",
            streetController,
            "Enter street name",
            true,
          ),
        ]),
        _buildRow([
          // Row for Country, State, and City dropdowns
          _buildColumnWithDropdown(
            "Country",
            ["India"],
            "India",
            "Select country",
            (value) {},
            false,
          ),
          _buildColumnWithDropdown(
            "State",
            stateList,
            selectedState,
            "Select state",
            (value) {
              setState(() {
                selectedState = value;
                selectedCity = null;
              });
            },
            true,
          ),
          _buildColumnWithDropdown(
            "City",
            selectedState != null ? cityMap[selectedState] ?? [] : [],
            selectedCity,
            "Select city",
            (value) {
              setState(() => selectedCity = value);
            },
            true,
          ),
        ]),
      ],
    );
  }

  /// Builds a row of form fields for the organization registration form.
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children:
            children
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

  /// Builds a text field with validation for the given label, controller, and hint text.
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
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.grey),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: _inputDecoration(hintText),
            validator:
                isRequired
                    ? (value) =>
                        value == null || value.isEmpty
                            ? "$label is required"
                            : null
                    : null,
          ),
        ),
      ],
    );
  }

  /// Builds a dropdown widget with validation for the given label, list of items, and selected value.
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
            items:
                items
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
          ),
        ),
      ],
    );
  }

  /// Builds the input decoration for form fields.
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }

  /// Builds the label for form fields with an optional required field indicator.
  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  /// Saves the form data to the Appwrite backend by creating a new document in the database.
  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await db.createDocument(
          databaseId: '67ece4a7002a0a732dfd',
          collectionId: '67f36a7e002c46ea05f0',
          documentId: ID.unique(),
          data: {
            'name': organizationController.text,
            'mobile': mobileController.text,
            'status': selectedStatus,
            'designation': selectedDesignation,
            'contactPerson': contactPersonController.text,
            'email': emailController.text,
            'addressLine': streetController.text,
            'state': selectedState,
            'city': selectedCity,
            'country': "India",
            'type': 'organization',
            'createdOn': DateTime.now().toIso8601String(),
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
