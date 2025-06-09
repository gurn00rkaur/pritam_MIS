import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_bottom_navigationbar.dart';
import 'package:pritam_manage_info_sys/presentation/features/auth/login/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAyUDhbd0l2IXCOwUo8PZQJ-v1Kv1CdJ74",
            authDomain: "pritam-info-sys.firebaseapp.com",
            projectId: "pritam-info-sys",
            storageBucket: "pritam-info-sys.firebasestorage.app",
            messagingSenderId: "274408407042",
            appId: "1:274408407042:web:fdfc59931bd4d163c8a71b",
            measurementId: "G-7N2V507S1X"),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Handle initialization error
    print("Firebase initialization error: $e");
    return; // Exit if Firebase initialization fails
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pritam_manage_info_sys',
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(), // Dynamically check login state
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.textWhite,
          surfaceTintColor: AppColors.textWhite,
          shadowColor: AppColors.background,
          elevation: 1,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
    );
  }
}

/// **🔍 Check if User is Logged In**
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("🔍 AuthChecker -> connectionState: ${snapshot.connectionState}");
        print("🔍 AuthChecker -> hasData: ${snapshot.hasData}");
        print("🔍 AuthChecker -> user: ${snapshot.data}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("⏳ Waiting for Firebase auth...");
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          print("✅ User is logged in. Proceeding to BottomNavBarExample...");
          return const BottomNavBarExample();
        } else {
          print("🛑 No user found. Showing LoginPage...");
          return const LoginPage();
        }
      },
    );
  }
}
