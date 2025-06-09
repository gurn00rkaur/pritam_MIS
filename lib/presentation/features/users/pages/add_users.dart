import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_snackbaradd.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class AddUsers extends StatefulWidget {
  final VoidCallback onUserAdded;
  const AddUsers({super.key, required this.onUserAdded});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  String? selectedBusiness;
  String? selectedRole;
  bool isBusinessNameEnabled = true;

  void _addUser() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmpasswordController.text.trim();

      if (selectedBusiness == null || selectedRole == null) {
        _showSnackbar("Please select business and role.");
        return;
      }

      if (password != confirmPassword) {
        _showSnackbar("Passwords do not match.");
        return;
      }

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        // Create User in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Store User Data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'businessName': selectedRole == "Super User" ? "" : selectedBusiness,
          'role': selectedRole,
        });

        // Close the loading indicator
        Navigator.of(context).pop(); // Close the loading dialog

        // Wait for 1 second
        await Future.delayed(const Duration(seconds: 1));

        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaradd(
              onOk: () {
                Navigator.pop(context); // Close the Snackbar dialog
                widget
                    .onUserAdded(); // Call the callback to refresh the user list
                Navigator.pop(context, true);
              },
              title: 'User  Added',
              message: 'The user has been added successfully.',
            );
          },
        );
      } catch (e) {
        // Close the loading indicator
        Navigator.of(context).pop(); // Close the loading dialog
        _showSnackbar("Error adding user: $e");
      }
    }
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSecondaryAppBar(
        title: 'Add Users',
      ),
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTff(
                    labelText: "Name *",
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  AddDropdown(
                    labelText: "Role",
                    items: ["Super User", "Standard User", "Admin"],
                    onSelected: (value) {
                      setState(() {
                        selectedRole = value;
                        isBusinessNameEnabled = value != "Super User";
                        if (!isBusinessNameEnabled) selectedBusiness = "";
                      });
                    },
                  ),
                  if (selectedRole != "Super User")
                    AddDropdown(
                      labelText: "Business Name",
                      items: ["Pritam", "Grandmamas Cafe", "Torii"],
                      onSelected: (value) {
                        setState(() {
                          selectedBusiness = value;
                        });
                      },
                    ),
                  CustomTff(
                    labelText: "Email *",
                    controller: _emailController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a email';
                      }
                      return null;
                    },
                  ),
                  CustomTff(
                    labelText: "Create Password *",
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    isPasswordField: true,
                    hintText: "Enter Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  CustomTff(
                    isPasswordField: true,
                    labelText: "Confirm Password *",
                    controller: _confirmpasswordController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Password Again",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: CustomButton(
                      onPressed: _addUser,
                      color: AppColors.primary,
                      text: "Add",
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
}
