import 'dart:convert';
import 'dart:developer';
import 'package:ciputra_patroli/models/kejadian.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../models/satpam.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<Satpam?> getSatpamById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/satpam/$id'));

    if (response.statusCode == 200) {
      return Satpam.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPenugasanById(String id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/penugasan_patroli/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<List<Kejadian>> fetchAllKejadian() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kejadian'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final kejadianList = data
            .map((item) {
              try {
                if (item != null) {
                  return Kejadian.fromMap(item);
                } else {
                  throw Exception('Item is null');
                }
              } catch (e) {
                print("Error mapping item: $e");
                return null;
              }
            })
            .where((item) => item != null)
            .toList();

        return kejadianList.cast<Kejadian>();
      } else {
        throw Exception(
            'Failed to load kejadians data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching kejadian data: $e");
      throw Exception('Failed to load kejadian data');
    }
  }

  Future<List<Kejadian>> fetchKejadianWithNotification() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/kejadian?is_notifikasi=true'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final kejadianList = data
            .map((item) {
              try {
                if (item != null) {
                  return Kejadian.fromMap(item);
                } else {
                  throw Exception('Item is null');
                }
              } catch (e) {
                print("Error mapping item: $e");
                return null;
              }
            })
            .where((item) => item != null)
            .toList();

        return kejadianList.cast<Kejadian>();
      } else {
        throw Exception(
            'Failed to load kejadians with notification, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching kejadian with notification data: $e");
      throw Exception('Failed to load kejadian with notification data');
    }
  }

  Future<bool> saveKejadian(Kejadian kejadian) async {
    final url = Uri.parse('$baseUrl/kejadian/save');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(kejadian.toMap()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['success'] == true;
    } else {
      return false;
    }
  }

  Future<void> sendNotification(
      String kejadianId, String title, String message) async {
    log("ini kejadian ${kejadianId}");
    final url = Uri.parse('$baseUrl/send-notification');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'kejadian_id': kejadianId,
        'title': title,
        'message': message,
      }),
    );

    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log('Notification sent successfully!');
    } else {
      log('Failed to send notification: ${response.body}');
    }
  }

  Future<bool> updateFcmToken(String satpamId, String fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/satpam/update-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'satpam_id': satpamId,
          'fcm_token': fcmToken,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating FCM token: $e');
      return false;
    }
  }

  Future<String?> getFcmTokenBySatpamId(String satpamId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/satpam/$satpamId/fcm-token'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['fcm_token'];
      }
      return null;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
}
