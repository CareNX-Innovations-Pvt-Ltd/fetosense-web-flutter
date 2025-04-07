import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class OrganizationRegistration extends StatefulWidget {
  final Client client;
  const OrganizationRegistration({super.key, required this.client});

  @override
  State createState() => _OrganizationRegistrationState();
}

class _OrganizationRegistrationState extends State<OrganizationRegistration> {
  final _formKey = GlobalKey<FormState>();

  late Databases db;

  TextEditingController organizationController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  String? selectedStatus;
  String? selectedDesignation;
  String? selectedState;
  String? selectedCity;

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
    db = Databases(widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.all(16),
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
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                child: Text(
                  "Organization Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _buildFormFields(),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[700],
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
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

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildRow([
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
          _buildColumnWithTextField(
            "Street",
            streetController,
            "Enter street name",
            true,
          ),
        ]),
        _buildRow([
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
        SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.grey),
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
        SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            items:
                items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(color: Colors.white)),
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }

  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        if (isRequired) Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await db.createDocument(
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
          SnackBar(content: Text('Organization saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
