import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../utils/fetch_organizations.dart';

class DeviceRegistration extends StatefulWidget {
  final Client client;
  const DeviceRegistration({super.key, required this.client});

  @override
  State createState() => _DeviceRegistrationState();
}

class _DeviceRegistrationState extends State<DeviceRegistration> {
  final _formKey = GlobalKey<FormState>();
  late Databases db;

  TextEditingController deviceNameController = TextEditingController();
  TextEditingController kitIdController = TextEditingController();
  TextEditingController tabletSerialNumberController = TextEditingController();
  TextEditingController tocoIdController = TextEditingController();

  String? selectedOrganizationId;
  String? selectedOrganizationName;
  String? selectedProductType;

  List<Map<String, String>> organizationList = [];
  List<String> productTypeList = ["Fetosense_Main", "Fetosense_Mini"];

  @override
  void initState() {
    super.initState();
    db = Databases(widget.client);

    fetchOrganizations(db).then((docs) {
      setState(() {
        organizationList =
            docs.map((doc) {
              return {
                'id': doc.$id,
                'name': doc.data['name']?.toString() ?? '',
              };
            }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF272A2C),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0xFF3E4346), width: 0.5),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1F2223),
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 0.5),
                  ),
                ),
                child: Text(
                  "Device Registration",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Container(
                color: Color(0xFF181A1B),
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
                          backgroundColor: Color(0xFF19607A),
                          padding: EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text("Save", style: TextStyle(fontSize: 16)),
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
          _buildOrganizationDropdown(),
          _buildColumnWithDropdown(
            "Product Type",
            productTypeList,
            selectedProductType,
            "Select Product Type",
            (value) => setState(() => selectedProductType = value),
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

  Widget _buildOrganizationDropdown() {
    return _buildColumnWithDropdown(
      "Organization",
      organizationList.map((e) => e['name']!).toList(),
      selectedOrganizationName,
      "Select Organization",
      (value) {
        final selected = organizationList.firstWhere((e) => e['name'] == value);
        setState(() {
          selectedOrganizationName = selected['name'];
          selectedOrganizationId = selected['id'];
        });
      },
      true,
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
        SizedBox(height: 6),
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
                        (value == null || value.isEmpty)
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
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Color(0xFF181A1B),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1),
        borderSide: BorderSide(color: Color(0xFF373B3E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1),
        borderSide: BorderSide(color: Color(0xFF373B3E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1),
        borderSide: BorderSide(color: Color(0xFF373B3E), width: 1),
      ),
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
        await db.createDocument(
          databaseId: '67e14dc00025fa9f71ad',
          collectionId: '67e64eba00363f40d736', // Devices collection
          documentId: ID.unique(),
          data: {
            'deviceCode': kitIdController.text,
            'deviceName': deviceNameController.text,
            'organizationId': selectedOrganizationId,
            'hospitalName': selectedOrganizationName,
            'tabletSerialNumber': tabletSerialNumberController.text,
            'isValid': true,
            'isDeleted': false,
            'createdBy': 'admin',
            'createdOn': DateTime.now().toIso8601String(),
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device registered successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
