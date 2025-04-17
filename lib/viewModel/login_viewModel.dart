import 'package:ciputra_patroli/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ciputra_patroli/auth/auth_service.dart';
import 'package:ciputra_patroli/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/satpam.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false;
  Satpam? _satpam;

  bool get isLoading => _isLoading;
  Satpam? get satpam => _satpam;
  String? get satpamId => _satpam?.satpamId;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;

    _setLoading(true);

    try {
      final user = await _authService.loginUser(email, password);
      if (user != null) {
        await fetchSatpamData(user.uid);
        await _firebaseService.updateSatpamFcmToken(satpam!.satpamId);
        _firebaseService.setupTokenRefreshListener(satpam!.satpamId);

        if (_satpam != null) {
          await _saveSession(_satpam!.satpamId);
          NavigationService.navigateTo('/home', clearStack: true);
          return true;
        }
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchSatpamData(String satpamId) async {
    try {
      _satpam = await _apiService.getSatpamById(satpamId);
      notifyListeners();
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _saveSession(String satpamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('satpamId', satpamId);
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedSatpamId = prefs.getString('satpamId');

    if (savedSatpamId != null) {
      await fetchSatpamData(savedSatpamId);
    }
  }

  Future<void> logout() async {
    await _authService.signOutUser();
    _satpam = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('satpamId');

    notifyListeners();
    NavigationService.navigateTo('/login', clearStack: true);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
