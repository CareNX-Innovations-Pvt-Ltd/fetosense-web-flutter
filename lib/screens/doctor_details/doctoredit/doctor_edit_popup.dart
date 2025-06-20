import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widget/columns.dart';
import '../../organization_details/widgets/edit_popup_widgets/stat_card.dart';
import 'doctor_edit_cubit.dart';

/// A StatefulWidget that represents the Doctor Edit popup dialog.
///
/// This widget allows the user to edit the details of a doctor, such as their name, mobile number, and email.
/// It provides a form for editing the doctor's information and allows for resetting the doctor's password.
/// Upon successful editing, the doctor’s data is updated in the database.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
/// The [data] contains the current doctor's data that is being edited.
/// The [documentId] is the unique identifier of the doctor document in the database.
/// The [onClose] callback is triggered when the user closes the popup.

class DoctorEditPopup extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final VoidCallback onClose;

  const DoctorEditPopup({
    super.key,
    required this.data,
    required this.documentId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = DoctorEditCubit(
          db: Databases(locator<AppwriteService>().client),
          documentId: documentId,
        );
        cubit.initialize(data);
        return cubit;
      },
      child: BlocBuilder<DoctorEditCubit, DoctorEditState>(
        builder: (context, state) {
          final cubit = context.read<DoctorEditCubit>();

          return Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 1000),
            decoration: BoxDecoration(
              color: const Color(0xFF181A1B),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF3E4346)),
            ),
            child: Row(
              children: [
                // Static Info Card
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181A1B),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF3E4346)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/doctor/48-481383_doctor-icon-png-transparent-png.png',
                          height: 60,
                          width: 60,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['name'] ?? '-',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: const Color(0xFF1A86AD),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Reset Password"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            StatCard(
                              count: data['mother']?.toString() ?? "0",
                              label: "Mothers",
                              icon: Icons.pregnant_woman,
                              color: Colors.red.shade900,
                            ),
                            const SizedBox(width: 10),
                            StatCard(
                              count: data['test']?.toString() ?? "0",
                              label: "Tests",
                              icon: Icons.monitor_heart,
                              color: Colors.teal.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Doctor Details",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                        buildColumnWithTextField(
                          "Email",
                          cubit.emailController,
                          "Enter email",
                          true,
                        ),
                        const SizedBox(height: 10),
                        buildColumnWithTextField(
                          "Name",
                          cubit.nameController,
                          "Enter name",
                          false,
                        ),
                        const SizedBox(height: 10),
                        buildColumnWithTextField(
                          "Mobile",
                          cubit.mobileController,
                          "Enter mobile number",
                          false,
                          isNumber: true,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed:
                                  () => cubit.updateChanges(context, onClose),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF1A86AD),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                              child: const Text(
                                "Update",
                                style: TextStyle(color: Color(0xFF1A86AD)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: onClose,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A86AD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                        if (state is DoctorEditSaving)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1A86AD),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
