import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../utils/fetch_organizations.dart';

/// A StatefulWidget that represents the Device Registration form.
///
/// This widget provides a form to register a new device by entering information such as the device name, kit ID,
/// tablet serial number, and organization. The form includes validation and allows the user to select an organization
/// from a dropdown list. Upon submission, the form data is saved to the Appwrite database.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
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

    // Fetch organizations from the database and populate the dropdown list.
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

  /// Builds the form fields for the device registration form.
  /// This includes dropdowns for selecting the organization and product type,
  /// along with text fields for entering the device name, kit ID, tablet serial number, and Toco ID.
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

  /// Builds the organization dropdown widget for selecting an organization.
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

  /// Builds a row of widgets with equal spacing between them.
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

  /// Builds a column with a text field widget for input.
  /// [label] The label for the text field.
  /// [controller] The text editing controller for the field.
  /// [hintText] The placeholder text for the field.
  /// [isRequired] Whether the field is required for form validation.
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

  /// Builds a column with a dropdown widget for selection.
  /// [label] The label for the dropdown.
  /// [items] The list of items for the dropdown.
  /// [selectedValue] The currently selected value.
  /// [hintText] The placeholder text for the dropdown.
  /// [onChanged] The callback to handle selection changes.
  /// [isRequired] Whether the dropdown is required for form validation.
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

  /// Creates the input decoration for form fields with hints and styling.
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

  /// Builds the label for the form fields, optionally including an asterisk if required.
  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        if (isRequired) Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  /// Handles the saving of the form by submitting the device data to the database.
  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await db.createDocument(
          databaseId: '67e14dc00025fa9f71ad',
          collectionId: '67e64eba00363f40d736',
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
