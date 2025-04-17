import 'dart:developer';
import 'package:ciputra_patroli/models/patroli.dart';
import 'package:ciputra_patroli/models/patroli_checkpoint.dart';
import 'package:ciputra_patroli/models/penugasan.dart';
import 'package:ciputra_patroli/services/firebase_service.dart';
import 'package:ciputra_patroli/viewModel/login_viewModel.dart';
import 'package:ciputra_patroli/services/location_service.dart'; // Add LocationService import
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // Import LatLng

import '../models/satpam.dart';
import '../services/api_service.dart';

class PatroliViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LoginViewModel _loginViewModel;
  final FirebaseService _firebaseService = FirebaseService();
  final LocationService _locationService =
      LocationService(); // Instance of LocationService

  Satpam? _satpam;
  bool _isLoading = false;

  Satpam? get satpam => _satpam;
  bool get isLoading => _isLoading;

  Patroli? _currentPatroli;
  Patroli? get currentPatroli => _currentPatroli;

  PatroliViewModel(this._loginViewModel) {
    loadSatpamData();
  }

  Future<void> loadSatpamData() async {
    final satpamId = _loginViewModel.satpamId;

    if (satpamId != null) {
      log("[DEBUG] Loading Satpam data in PatroliViewModel...");
      _setLoading(true);

      try {
        _satpam = _loginViewModel.satpam;
        log("[DEBUG] PatroliViewModel Satpam Loaded: ${_satpam?.toString()}");
      } catch (e, stacktrace) {
        log("[ERROR] Failed to load Satpam in PatroliViewModel: $e");
        log("[STACKTRACE] $stacktrace");
      } finally {
        _setLoading(false);
      }
    } else {
      log("[WARNING] No Satpam ID found in session.");
    }
  }

  void createPatroli({
    required String satpamId,
    required String lokasiId,
    required String penugasanId,
    required String jadwalPatroliId,
  }) {
    _currentPatroli = Patroli(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jamMulai: DateTime.now(),
      jamSelesai: null,
      durasiPatroli: Duration.zero,
      catatanPatroli: '',
      rutePatroli: ' ',
      satpamId: satpamId,
      lokasiId: lokasiId,
      jadwalPatroliId: jadwalPatroliId,
      penugasanId: penugasanId,
      isTerlambat: false,
      tanggal: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> submitCheckpoint({
    required Patroli patroli,
    required Penugasan penugasan,
    required int currentIndex,
    required String imagePath,
    required DateTime timestamp,
    required String keterangan,
  }) async {
    if (_currentPatroli == null) {
      log('[ERROR] _currentPatroli is null.');
      return;
    }

    LatLng? currentLocation = await _locationService.fetchCurrentLocation();
    if (currentLocation == null) {
      log('[ERROR] Failed to fetch current location.');
      return;
    }

    final penugasanTitikPatroli = penugasan.titikPatroli[currentIndex];
    final checkpointLatitude = penugasanTitikPatroli['lat'];
    final checkpointLongitude = penugasanTitikPatroli['lng'];

    final distanceStatus = _checkDistance(
        currentLocation, checkpointLatitude, checkpointLongitude);
    final isLate = _checkLateness(timestamp);

    String status = isLate ? 'Late' : 'On Time';

    _addCheckpointToPatroli(
      patroliId: _currentPatroli!.id,
      checkpointLatitude: checkpointLatitude,
      checkpointLongitude: checkpointLongitude,
      imagePath: imagePath,
      timestamp: timestamp,
      keterangan: keterangan,
      status: status,
      distanceStatus: distanceStatus,
      currentLocation: currentLocation,
    );

    _firebaseService.savePatroli(_currentPatroli!);
    notifyListeners();
  }

  void _addCheckpointToPatroli({
    required String patroliId,
    required double checkpointLatitude,
    required double checkpointLongitude,
    required String imagePath,
    required DateTime timestamp,
    required String keterangan,
    required String status,
    required String distanceStatus,
    required LatLng currentLocation,
  }) {
    final newCheckpoint = PatroliCheckpoint(
      patroliId: patroliId,
      latitude: checkpointLatitude,
      longitude: checkpointLongitude,
      imagePath: imagePath,
      timestamp: timestamp.toIso8601String(),
      keterangan: keterangan,
      status: status,
      distanceStatus: distanceStatus,
      currentLatitude: currentLocation.latitude,
      currentLongitude: currentLocation.longitude,
    );

    _firebaseService.saveCheckpoint(newCheckpoint);

    log('Checkpoint added: ${newCheckpoint.toJson()}');
    log('Patroli jamSelesai updated to: ${_currentPatroli!.jamSelesai}');
  }

  String _checkDistance(LatLng currentLocation, double checkpointLatitude,
      double checkpointLongitude) {
    final distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      checkpointLatitude,
      checkpointLongitude,
    );
    return distanceInMeters <= 5 ? 'Close' : 'Far';
  }

  bool _checkLateness(DateTime currentTimestamp) {
    if (_currentPatroli!.checkpoints.isEmpty) return false;

    final lastCheckpoint = _currentPatroli!.checkpoints.last;
    final lastTimestamp = DateTime.parse(lastCheckpoint['timestamp']);

    final difference = currentTimestamp.difference(lastTimestamp).inMinutes;
    return difference > 15;
  }

  void endPatroli({
    required String catatanPatroli,
  }) {
    if (_currentPatroli != null) {
      _currentPatroli!.catatanPatroli = catatanPatroli;
      _currentPatroli!.jamSelesai = DateTime.now();

      if (_currentPatroli!.jamMulai != null &&
          _currentPatroli!.jamSelesai != null) {
        final duration =
            _currentPatroli!.jamSelesai!.difference(_currentPatroli!.jamMulai!);
        _currentPatroli!.durasiPatroli = duration;
        notifyListeners();
      }
    }

    savePatroli();
  }

  void savePatroli() {
    _firebaseService.savePatroli(_currentPatroli!);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
