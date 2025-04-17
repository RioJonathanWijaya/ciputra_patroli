import 'package:uuid/uuid.dart';

class PatroliCheckpoint {
  final String id;
  final String patroliId;
  final double latitude;
  final double longitude;
  final String imagePath;
  final String timestamp;
  final String keterangan;
  final String status;
  final String distanceStatus;
  final double currentLatitude;
  final double currentLongitude;

  PatroliCheckpoint({
    required this.patroliId,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.timestamp,
    required this.keterangan,
    required this.status,
    required this.distanceStatus,
    required this.currentLatitude,
    required this.currentLongitude,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patroli_id': patroliId,
      'latitude': latitude,
      'longitude': longitude,
      'image_path': imagePath,
      'timestamp': timestamp,
      'keterangan': keterangan,
      'status': status,
      'distance_status': distanceStatus,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }
}
