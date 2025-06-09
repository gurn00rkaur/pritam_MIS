import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/features/auth/login/pages/login_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  ChangePassword() async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter New Password',
                  labelStyle: const TextStyle(fontSize: 20.0),
                  border: const OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.redAccent[700])),
              controller: newPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  newPassword = newPasswordController.text;
                });
                ChangePassword();
              }
            },
            child: const Text(
              'Change Password',
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ]),
      ),
    );
  }
}
