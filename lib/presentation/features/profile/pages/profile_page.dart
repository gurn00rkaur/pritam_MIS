import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pritam_manage_info_sys/database_firestore.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_Snackbaredit.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/customprofiletff.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/auth/login/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseFirestore _dbService = DatabaseFirestore();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  String _profileImageUrl = ''; // Store profile picture URL

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Fetch user details
  }

  void _fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _roleController.text = data['role'] ?? '';
          _companyController.text =
              data['businessName'] ?? ''; // Fetch business name
          _profileImageUrl = data['profileImageUrl'] ?? '';
        });
      }
    }
  }

  // Pick image from gallery and upload to Firebase Storage
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Upload image to Firebase Storage
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('profile_pictures')
              .child('${user.uid}.jpg');
          await ref.putFile(imageFile);
          String imageUrl = await ref.getDownloadURL();

          // Save URL to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profileImageUrl': imageUrl});

          setState(() {
            _profileImageUrl = imageUrl;
          });

          showDialog(
            context: context,
            builder: (context) {
              return CustomSnackbaredit(
                onOk: () {
                  // Navigator.pop(context); // Close the snackbar dialog
                },
                title: 'User Updated',
                message: 'Your Data has been updated successfully',
              );
            },
          );
        } catch (e) {
          // Show error Custom Snackbar
          showDialog(
            context: context,
            builder: (context) {
              return CustomSnackbaredit(
                onOk: () {
                  // Navigator.pop(context); // Close the snackbar dialog
                },
                title: 'Error!',
                message: "Failed to update profile picture: $e",
              );
            },
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _profileImageUrl.isNotEmpty
                      ? NetworkImage(_profileImageUrl)
                      : const AssetImage('') as ImageProvider,
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 18),
                      onPressed: _pickAndUploadImage, // Open image picker
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${_nameController.text}', // Display full name
              style: AppTextStyles.titleBlack,
            ),
            Text(_roleController.text, style: AppTextStyles.bodyText2),
            Text(_companyController.text, style: AppTextStyles.bodyText2),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(6.0),
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTff(
                        labelText: "Full Name",
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        hintText: "Enter First Name",
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a first name'
                            : null,
                      ),
                      Customprofiletff(
                        labelText: "Role",
                        controller: _roleController,
                        keyboardType: TextInputType.text,
                        readOnly: true, // Makes field non-editable
                        hintText: "Role",
                        style: TextStyle(color: Colors.grey), // Grey text
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200], // Light grey background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppColors.primaryLight, width: 1.5),
                          ),
                        ),
                      ),
                      Customprofiletff(
                        labelText: "Business Name",
                        controller: _companyController,
                        keyboardType: TextInputType.text,
                        readOnly: true, // Makes field non-editable
                        hintText: "Business Name",
                        style: TextStyle(color: Colors.grey), // Grey text
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200], // Light grey background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppColors.primaryLight, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.all(26.0),
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primary,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.primary),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update({
                                    'name': _nameController.text.trim(),
                                  });

                                  _fetchProfile();

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomSnackbaredit(
                                        onOk: () {
                                          // Navigator.pop(
                                          //     context); // Close the snackbar dialog
                                        },
                                        title: 'User Updated',
                                        message:
                                            'Your Data has been updated successfully',
                                      );
                                    },
                                  );
                                } catch (e) {
                                  // Show error Custom Snackbar
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomSnackbaredit(
                                        onOk: () {
                                          Navigator.pop(
                                              context); // Close the snackbar dialog
                                        },
                                        title: 'Error!',
                                        message: "Failed to update profile: $e",
                                      );
                                    },
                                  );
                                }
                              }
                            }
                          },
                          child:
                              Text('Save', style: AppTextStyles.captionWhite),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 26.0),
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut(); // Logout the user
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          icon: Icon(Icons.logout_rounded,
                              color: AppColors.primary),
                          label:
                              Text('Logout', style: AppTextStyles.captionred),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
