import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthService() {
    try {
      _auth.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      log("AuthService error: $e");
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      log("Signing in with: Email: $email, Password: $password");

      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      _user = _auth.currentUser;
      // notifyListeners();

      log("Login successful: ${_user?.email}");
      return _user;
    } catch (e) {
      log("[AuthService] Login failed: $e");
      return null;
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
      log("User signed out");
    } catch (e) {
      log("Logout failed: $e");
    }
  }
}
