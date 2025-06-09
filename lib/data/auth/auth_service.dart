import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      debugPrint("Something went wrong: $e");
    }

    return null;
  }

  Future<User?> logInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      debugPrint("Something went wrong: $e");
    }

    return null;
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint("Password reset email sent");
    } catch (e) {
      debugPrint("Failed to send password reset email: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Something went wrong: $e");
    }
  }
}

String exceptionHandler(String code) {
  switch (code) {
    case "invalid-email":
      return "The email address is badly formatted.";
    case "user-disabled":
      return "The user corresponding to the given email has been disabled.";
    case "user-not-found":
      return "There is no user corresponding to the given email.";
    case "wrong-password":
      return "The password is invalid.";
    case "email-already-in-use":
      return "An account already exists with that email.";
    case "weak-password":
      return "The password must be at least 6 characters long.";
    default:
      return "An unexpected error occurred. Please try again.";
  }
}
