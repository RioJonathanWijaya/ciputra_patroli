import 'package:ciputra_patroli/views/notifikasi/notifikasi_detail_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NotifikasiPage(),
  ));
}

class NotifikasiPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Kebakaran',
      'location': 'Jl. Merdeka No. 10',
      'time': '12:30 PM',
      'image': 'https://via.placeholder.com/150',
      'victimName': 'Budi Santoso',
      'victimAddress': 'Jl. Mawar No. 5',
      'details': 'Kebakaran terjadi di lantai 3 gedung utama.',
      'updates': [
        {'time': '12:35 PM', 'status': 'Pemadam kebakaran dalam perjalanan'},
        {'time': '12:50 PM', 'status': 'Api berhasil dipadamkan'},
      ]
    },
    {
      'title': 'Pencurian',
      'location': 'Mall Plaza',
      'time': '02:15 AM',
      'image': 'https://via.placeholder.com/150',
      'victimName': 'Siti Aminah',
      'victimAddress': 'Jl. Melati No. 8',
      'details': 'Pelaku berhasil melarikan diri sebelum polisi tiba.',
      'updates': [
        {'time': '02:20 AM', 'status': 'Polisi tiba di lokasi'},
        {'time': '02:45 AM', 'status': 'Investigasi sedang berlangsung'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(notification['title'],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text('${notification['location']} - ${notification['time']}'),
              trailing: Icon(Icons.arrow_forward, color: Colors.blueAccent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NotifikasiDetailPage(notification: notification),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
