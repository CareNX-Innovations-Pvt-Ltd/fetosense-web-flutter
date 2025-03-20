import 'package:flutter/material.dart';

class DeviceRegistration extends StatefulWidget {
  @override
  _DeviceRegistrationState createState() => _DeviceRegistrationState();
}

class _DeviceRegistrationState extends State<DeviceRegistration> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  String? selectedOrganization;
  String? selectedProductType;

  // Controllers for input fields
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController kitIdController = TextEditingController();
  final TextEditingController tocoIdController = TextEditingController();
  final TextEditingController tabletSerialController = TextEditingController();

  // Sample dropdown data (Replace with API data)
  final List<String> organizationList = ["Org 1", "Org 2", "Org 3"];
  final List<String> productTypeList = ["Type A", "Type B", "Type C"];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print("Submitting Device Registration:");
      print("Organization: $selectedOrganization");
      print("Product Type: $selectedProductType");
      print("Device Name: ${deviceNameController.text}");
      print("Kit ID: ${kitIdController.text}");
      print("Toco ID: ${tocoIdController.text}");
      print("Tablet Serial Number: ${tabletSerialController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Device Registration"),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Container(
          width: 900,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Device Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    _buildDropdownField(
                      "Organization",
                      organizationList,
                      selectedOrganization,
                      (value) {
                        setState(() {
                          selectedOrganization = value;
                        });
                      },
                    ),
                    SizedBox(width: 20),
                    _buildDropdownField(
                      "Product Type",
                      productTypeList,
                      selectedProductType,
                      (value) {
                        setState(() {
                          selectedProductType = value;
                        });
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    _buildTextField(
                      "Device Name (Bluetooth)",
                      deviceNameController,
                    ),
                    SizedBox(width: 20),
                    _buildTextField("Kit ID", kitIdController),
                  ],
                ),

                Row(
                  children: [
                    _buildTextField("Toco ID", tocoIdController),
                    SizedBox(width: 20),
                    _buildTextField(
                      "Tablet Serial Number",
                      tabletSerialController,
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
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

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
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
          onChanged: (value) {
            onChanged(value);
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          dropdownColor: Colors.grey.shade900,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          validator: (value) => value!.isEmpty ? "Required" : null,
        ),
      ),
    );
  }
}
