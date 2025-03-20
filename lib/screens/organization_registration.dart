import 'package:flutter/material.dart';
import 'sidebar.dart'; // Import the sidebar
import 'appbar.dart'; // Import the appbar

class OrganizationRegistration extends StatefulWidget {
  const OrganizationRegistration({super.key});

  @override
  State createState() => _OrganizationRegistrationState();
}

class _OrganizationRegistrationState extends State<OrganizationRegistration> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  TextEditingController organizationController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  // Dropdown selected values
  String? selectedStatus;
  String? selectedDesignation;
  String? selectedState;
  String? selectedCity;

  // Dummy data for dropdowns
  List<String> statusList = ["Trial", "Demo", "Sold"];
  List<String> designationList = ["Manager", "Executive", "Admin"];
  List<String> stateList = ["Maharashtra", "Karnataka", "Gujarat"];
  Map<String, List<String>> cityMap = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bangalore", "Mysore"],
    "Gujarat": ["Ahmedabad", "Surat"],
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(15.0),
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
                Text(
                  "Organization Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  // width: 700,
                  // padding: EdgeInsets.symmetric(horizontal: -10),
                  height: 1,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                ),
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
        ),
      ),
    );
  }

  /*
  child: Expanded(
        child: SingleChildScrollView(
          child: Container(
            width: 700, // Set form width
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Organization Registration",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    // width: 700,
                    // padding: EdgeInsets.symmetric(horizontal: -10),
                    height: 1,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 0),
                  ),
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
          ),
        ),
      ),
   */
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
          height: 40, // Set fixed height
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
          height: 40, // Set fixed height
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ), // Adjust height
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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      print("Form Submitted!");
    }
  }
}
