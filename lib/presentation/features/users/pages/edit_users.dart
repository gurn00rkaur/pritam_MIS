import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_Snackbaredit.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class EditUsers extends StatefulWidget {
  final String userId;
  final VoidCallback onUserEdited;

  const EditUsers(
      {super.key, required this.userId, required this.onUserEdited});

  @override
  State<EditUsers> createState() => _EditUsersState();
}

class _EditUsersState extends State<EditUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? selectedBusiness;
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          selectedBusiness = data['businessName'] ?? "Pritam";
          selectedRole = data['role'];
        });
      }
    } catch (e) {
      _showSnackbar("Error fetching user data: $e");
    }
  }

  void _editUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password.isNotEmpty && password != confirmPassword) {
      _showSnackbar("Passwords do not match!");
      return;
    }

    Map<String, dynamic> dataToUpdate = {
      'name': name,
      'email': email,
      'businessName': selectedBusiness,
      'role': selectedRole,
    };

    if (password.isNotEmpty) {
      dataToUpdate['password'] =
          password; // 🚨 Hashing should be done in backend
    }

    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .update(dataToUpdate);
      if (password.isNotEmpty) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          try {
            await user.updatePassword(password);
          } catch (e) {
            _showSnackbar("Failed to update password: $e");
            return;
          }
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return CustomSnackbaredit(
            onOk: () {
              Navigator.pop(context);
              widget.onUserEdited();
              Navigator.pop(context, true);
            },
            title: 'User  Edited!',
            message: 'The changes for the user has been edited successfully.',
          );
        },
      );
    } catch (e) {
      _showSnackbar("Error editing user details: $e");
    }
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Only build UI after data is fetched
    if (selectedBusiness == null || selectedRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSecondaryAppBar(title: 'Edit Users'),
      body: SingleChildScrollView(
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
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              AddDropdown(
                labelText: "Role",
                items: ["Super User", "Standard User", "Admin"],
                initialValue: selectedRole, // ✅ Set initial value
                onSelected: (value) => setState(() => selectedRole = value),
              ),
              if (selectedRole != "Super User")
                AddDropdown(
                  labelText: "Business Name",
                  items: ["Pritam", "Grandmamas Cafe", "Torii"],
                  initialValue: selectedBusiness, // ✅ Set initial value
                  onSelected: (value) =>
                      setState(() => selectedBusiness = value),
                ),
              CustomTff(
                labelText: "Email *",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter email",
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
              ),
              CustomTff(
                labelText: "Create Password",
                controller: _passwordController,
                keyboardType: TextInputType.text,
                isPasswordField: true,
                hintText: "Leave blank to keep current password",
              ),
              CustomTff(
                labelText: "Confirm Password",
                controller: _confirmPasswordController,
                keyboardType: TextInputType.text,
                isPasswordField: true,
                hintText: "Re-enter Password",
              ),
              const SizedBox(height: 20),
              CustomButton(
                  onPressed: _editUser, color: AppColors.primary, text: "Edit"),
            ],
          ),
        ),
      ),
    );
  }
}
