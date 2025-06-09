import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/db_firestore_profile.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_login_tff.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/auth/login/pages/login_page.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> registration() async {
    // Get values from controllers
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text("Please enter a valid email address"),
        ),
      );
      return;
    }

    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await DatabaseFirestore().addProfile(
          name: name,
          // lastname: '',
          role: '',
          businessName: '',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: const Text(
              "Account created successfully",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred";
        if (e.code == 'weak-password') {
          errorMessage = "Password provided is too weak";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "Email already in use";
        } else {
          errorMessage = e.message ?? "An error occurred";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(errorMessage, style: const TextStyle(fontSize: 18)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent[300],
          content: const Text("Password and Confirm Password do not match"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 80),
        color: AppColors.primary,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // const Text('Create your account', style: AppTextStyles.bodyText1),
          // const SizedBox(height: 30),
          Text(
            'Sign-in',
            style: AppTextStyles.headline1,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    height: size.height * 0.80,
                    width: size.width,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(75)),
                      color: AppColors.background,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Hello! Sign in to stay connected",
                          style: AppTextStyles.bodyText1,
                        ),
                        SizedBoxHelper.height14(),
                        CustomLoginTff(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          hintText: 'Enter Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          prefixIcon: Icons.person,
                        ),
                        SizedBox(height: 15),
                        CustomLoginTff(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          prefixIcon: Icons.email,
                        ),
                        SizedBox(height: 15),
                        CustomLoginTff(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Enter Password',
                          obscureText: !passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          prefixIcon: FeatherIcons.lock,
                        ),
                        SizedBox(height: 15),
                        CustomLoginTff(
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Enter Confirm Password',
                          obscureText: !confirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password correctly';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          prefixIcon: FeatherIcons.lock,
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: size.width * 0.6,
                          child: CustomButton(
                            onPressed: registration,
                            color: AppColors.primary,
                            text: "Register",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              ),
                              child: const Text('Login',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color.fromRGBO(0, 110, 233, 1))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
