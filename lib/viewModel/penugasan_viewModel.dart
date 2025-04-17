import 'dart:developer';
import 'package:ciputra_patroli/services/api_service.dart';
import 'package:ciputra_patroli/viewModel/login_viewModel.dart';
import 'package:flutter/material.dart';

class PenugasanPatroliViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LoginViewModel _loginViewModel;

  List<Map<String, dynamic>> _penugasanList = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get penugasanList => _penugasanList;
  bool get isLoading => _isLoading;

  PenugasanPatroliViewModel(this._loginViewModel);

  Future<void> getPenugasanData() async {
    final satpamId = _loginViewModel.satpamId;

    if (satpamId != null) {
      _isLoading = true;
      notifyListeners();
      log("[INFO] Fetching data for satpamId: $satpamId");

      try {
        _penugasanList = await _apiService.fetchPenugasanById(satpamId);
        log("[INFO] Data successfully fetched. Data length: ${_penugasanList.length}");

        for (var data in _penugasanList) {
          log("[DATA] ${data.toString()}");
        }

        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        log("[ERROR] Failed to load Penugasan: $e");
        notifyListeners();
      }
    } else {
      log("[ERROR] satpamId is null.");
    }
  }
}
