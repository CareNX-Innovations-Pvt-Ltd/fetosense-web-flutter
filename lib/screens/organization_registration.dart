import 'package:flutter/material.dart';

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
  List<String> statusList = ["Active", "Inactive"];
  List<String> designationList = ["Manager", "Executive", "Admin"];
  List<String> stateList = ["Maharashtra", "Karnataka", "Gujarat"];
  Map<String, List<String>> cityMap = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bangalore", "Mysore"],
    "Gujarat": ["Ahmedabad", "Surat"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Organization Registration"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 900, // Set form width
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade900, blurRadius: 10),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Organization Registration",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      _buildTextField("Organization", organizationController,
                          isRequired: true),
                      SizedBox(width: 16),
                      _buildTextField("Mobile", mobileController,
                          isRequired: true, isNumber: true),
                    ],
                  ),

                  Row(
                    children: [
                     _buildDropdownField(
  "City",
  selectedState != null ? cityMap[selectedState] ?? [] : [],
  selectedCity,
  (value) {
    setState(() {
      selectedCity = value;
    });
  },
),

                      SizedBox(width: 16),
                      _buildDropdownField(
                          "Designation", designationList, selectedDesignation,
                          (value) {
                        setState(() {
                          selectedDesignation = value;
                        });
                      }),
                    ],
                  ),

                  Row(
                    children: [
                      _buildTextField("Contact Person", contactPersonController,
                          isRequired: true),
                      SizedBox(width: 16),
                      _buildTextField("Email", emailController),
                    ],
                  ),

                  _buildTextField("Street", streetController, isRequired: true),

                  Row(
                    children: [
                      _buildDropdownField("Country", ["India"], "India",
                          (value) {}),
                      SizedBox(width: 16),
                      _buildDropdownField("State", stateList, selectedState,
                          (value) {
                        setState(() {
                          selectedState = value;
                          selectedCity = null; // Reset city selection
                        });
                      }),
                      SizedBox(width: 16),
                      _buildDropdownField(
                          "City",
                          selectedState != null
                              ? cityMap[selectedState] ?? []
                              : [],
                          selectedCity, (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      }),
                    ],
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text("Save",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isRequired = false, bool isNumber = false}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey.shade900,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          validator: isRequired
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

  Widget _buildDropdownField(
    String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items.isNotEmpty
            ? items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList()
            : [], // Ensure it never gets empty
        onChanged: (value) {
          setState(() {
            onChanged(value);
          });
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey.shade900, // Ensure it’s visible on dark background
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        dropdownColor: Colors.grey.shade900, // Set dropdown background color
      ),
    ),
  );
}


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
