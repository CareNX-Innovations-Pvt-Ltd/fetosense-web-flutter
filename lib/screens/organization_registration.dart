import 'package:flutter/material.dart';
import 'sidebar.dart'; // Import the sidebar
import 'appbar.dart'; // Import the appbar

class OrganizationRegistration extends StatefulWidget {
  @override
  _OrganizationRegistrationState createState() =>
      _OrganizationRegistrationState();
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
  List<String> statusList = ["Trail", "Demo", "Sold"];
  List<String> designationList = ["Manager", "Executive", "Admin"];
  List<String> stateList = ["Maharashtra", "Karnataka", "Gujarat"];
  Map<String, List<String>> cityMap = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bangalore", "Mysore"],
    "Gujarat": ["Ahmedabad", "Surat"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: buildAppBar("User Email", () {}), // Use the imported AppBar
      body: Row(
        children: [
          buildSidebar(context, () {}), // Use the imported Sidebar
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: 900, // Set form width
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.white, blurRadius: 10)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      // Form fields as per your requirements
                      Row(
                        children: [
                          _buildLabel("Organization", true),
                          _buildTextField(
                            "Organization",
                            organizationController,
                            isRequired: true,
                          ),
                          SizedBox(width: 16),
                          _buildLabel("Mobile", true),
                          _buildTextField(
                            "Mobile",
                            mobileController,
                            isRequired: true,
                            isNumber: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildDropdownLabel("Status", true),
                          _buildDropdownField(
                            "Status",
                            statusList,
                            selectedStatus,
                            (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                          SizedBox(width: 16),
                          _buildDropdownField(
                            "Designation",
                            designationList,
                            selectedDesignation,
                            (value) {
                              setState(() {
                                selectedDesignation = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildLabel("Contact Person", true),
                          _buildTextField(
                            "Contact Person",
                            contactPersonController,
                            isRequired: true,
                          ),
                          SizedBox(width: 16),
                          _buildLabel("Email", true),
                          _buildTextField("Email", emailController),
                        ],
                      ),
                      Row(
                        children: [
                          _buildLabel("Street", true),
                          _buildTextField(
                            "Street",
                            streetController,
                            isRequired: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildDropdownField(
                            "Country",
                            ["India"],
                            "India",
                            (value) {},
                          ),
                          SizedBox(width: 16),
                          _buildDropdownField(
                            "State",
                            stateList,
                            selectedState,
                            (value) {
                              setState(() {
                                selectedState = value;
                                selectedCity = null; // Reset city selection
                              });
                            },
                          ),
                          SizedBox(width: 16),
                          _buildDropdownField(
                            "City",
                            selectedState != null
                                ? cityMap[selectedState] ?? []
                                : [],
                            selectedCity,
                            (value) {
                              setState(() {
                                selectedCity = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
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
        ],
      ),
    );
  }

  // Sidebar item widget
  Widget _sidebarItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // Method to build labels for text fields
  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(color: Colors.red), // Red color for asterisk
          ),
      ],
    );
  }

  // Method to build text fields
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    bool isNumber = false,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: "",
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          validator:
              isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return "$label is required";
                    }
                    return null;
                  }
                  : null,
        ),
      ),
    );
  }

  // Method to build dropdown fields
  Widget _buildDropdownField(
    String label,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged, {
    bool isRequired = false,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownLabel(label, isRequired),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedValue,
              items:
                  items.isNotEmpty
                      ? items
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList()
                      : [],
              onChanged: (value) {
                setState(() {
                  onChanged(value);
                });
              },
              decoration: InputDecoration(
                labelText: "",
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              dropdownColor: Colors.grey.shade900,
            ),
          ],
        ),
      ),
    );
  }

  // Method to build dropdown labels
  Widget _buildDropdownLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(color: Colors.red), // Red color for asterisk
          ),
      ],
    );
  }

  // Save form method
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      print("Form Submitted!");
      print("Organization: ${organizationController.text}");
      print("Mobile: ${mobileController.text}");
      print("Status: $selectedStatus");
      print("Designation: $selectedDesignation");
      print("Contact Person: ${contactPersonController.text}");
      print("Email: ${emailController.text}");
      print("Street: ${streetController.text}");
      print("State: $selectedState");
      print("City: $selectedCity");
    }
  }
}
