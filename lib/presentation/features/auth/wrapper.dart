import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/data/auth/users_database_service.dart';
import 'package:pritam_manage_info_sys/data/auth/users_model.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_bottom_navigationbar.dart';

import 'package:pritam_manage_info_sys/presentation/features/auth/login/pages/login_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final UsersDatabaseService _usersDatabaseService = UsersDatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // While waiting for the connection
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // If there's an error
            else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong. Please try again later."),
              );
            }

            // If no user is logged in
            else if (!snapshot.hasData) {
              return const LoginPage();
            }

            // If a user is logged in
            else {
              final User user = snapshot.data!;
              return FutureBuilder<UsersModel?>(
                  future: _usersDatabaseService.getUserById(user.uid),
                  builder: (context, userSnapshot) {
                    // While waiting for the user data
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // If the user is not found in Firestore, navigate to UserProfilePage
                    if (!userSnapshot.hasData) {
                      return const LoginPage(); // Direct user to profile setup
                    }

                    // If the user data is available, navigate to the main app
                    return const BottomNavBarExample(
                      initialIndex: 2,
                    );
                  });
            }
          }),
    );
  }
}
