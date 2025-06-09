import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/auth/register/register.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  var email = " ";
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Password reset email sent.',
        style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(0, 110, 233, 1),
            fontFamily: 'Poppins'),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'User not found.',
          style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(0, 110, 233, 1),
              fontFamily: 'Poppins'),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomSecondaryAppBar(title: 'Forget Password'),
      body: Container(
        height: size.height,
        width: size.width,
        color: AppColors.primary,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 80),
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75)),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  Text(
                    'Email Verification',
                    style: AppTextStyles.primaryHeadline1,
                  ),
                  SizedBox(height: 15),
                  const Text(
                    'Enter your email to reset your password.',
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                    fontSize: 16.0, fontFamily: 'Poppins'),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 110, 233, 0.1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(0, 110, 233, 0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 110, 233, 0.1)),
                                ),
                                errorStyle: const TextStyle(
                                    fontSize: 15.0, color: Colors.red),
                              ),
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an Email';
                                } else if (!value.contains('@')) {
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account?',
                                    style: TextStyle(fontFamily: 'Poppins')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            Register(),
                                        transitionDuration:
                                            const Duration(seconds: 0),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                        color: Color.fromRGBO(0, 110, 233, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
