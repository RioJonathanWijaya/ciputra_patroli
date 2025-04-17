import 'dart:convert';
import 'dart:developer';
import 'package:ciputra_patroli/models/kejadian.dart';
import 'package:ciputra_patroli/services/api_service.dart';
import 'package:ciputra_patroli/services/notification_service.dart';
import 'package:flutter/material.dart';

class KejadianViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();

  List<Kejadian> _kejadianList = [];
  bool _isLoading = false;

  List<Kejadian> get kejadianList => _kejadianList;
  bool get isLoading => _isLoading;

  KejadianViewModel();

  Future<void> getAllKejadianData() async {
    _isLoading = true;
    notifyListeners();
    log("[INFO] Fetching all kejadian data...");

    try {
      _kejadianList = await _apiService.fetchAllKejadian();
      log("[INFO] Data successfully fetched. Data length: ${_kejadianList.length}");

      for (var data in _kejadianList) {
        log("[INFO] Checking data for null values...");

        if (data is Kejadian) {
          if (data.namaKorban == null) {
            log("[ERROR] 'namaKorban' is null");
          }
          if (data.alamatKorban == null) {
            log("[ERROR] 'alamatKorban' is null");
          }
          if (data.keteranganKorban == null) {
            log("[ERROR] 'keteranganKorban' is null");
          }
          if (data.waktuSelesai == null) {
            log("[ERROR] 'waktuSelesai' is null");
          }

          log("[DATA] ${jsonEncode(data.toMap())}");
        } else {
          log("[ERROR] Data is not of type 'Kejadian'. Type is: ${data.runtimeType}");
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e, stacktrace) {
      _isLoading = false;
      log("[ERROR] Failed to load Kejadian: $e");
      log("[STACKTRACE] $stacktrace");
      notifyListeners();
    }
  }

  Future<void> getAllKejadianDataNotifikasi() async {
    _isLoading = true;
    notifyListeners();
    log("[INFO] Fetching all kejadian data...");

    try {
      _kejadianList = await _apiService.fetchKejadianWithNotification();
      log("[INFO] Data successfully fetched. Data length: ${_kejadianList.length}");

      for (var data in _kejadianList) {
        log("[INFO] Checking data for null values...");

        if (data is Kejadian) {
          if (data.namaKorban == null) {
            log("[ERROR] 'namaKorban' is null");
          }
          if (data.alamatKorban == null) {
            log("[ERROR] 'alamatKorban' is null");
          }
          if (data.keteranganKorban == null) {
            log("[ERROR] 'keteranganKorban' is null");
          }
          if (data.waktuSelesai == null) {
            log("[ERROR] 'waktuSelesai' is null");
          }

          log("[DATA] ${jsonEncode(data.toMap())}");
        } else {
          log("[ERROR] Data is not of type 'Kejadian'. Type is: ${data.runtimeType}");
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e, stacktrace) {
      _isLoading = false;
      log("[ERROR] Failed to load Kejadian: $e");
      log("[STACKTRACE] $stacktrace");
      notifyListeners();
    }
  }

  Future<bool> saveKejadian(Kejadian kejadian) async {
    _isLoading = true;
    notifyListeners();
    log("[INFO] Saving kejadian data...");

    try {
      log('yeyayayya: ${kejadian.id}');
      final success = await _apiService.saveKejadian(kejadian);

      if (success) {
        log("[INFO] Kejadian data successfully saved.");
        await getAllKejadianData();
      }

      if (kejadian.isNotifikasi) {
        await _notificationService.sendNotificationToAll(
            kejadian.namaKejadian, kejadian.lokasiKejadian);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      log("[ERROR] Failed to save Kejadian: $e");
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
