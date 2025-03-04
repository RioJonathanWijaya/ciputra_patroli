import 'package:ciputra_patroli/widgets/text/animated_title.dart';
import 'package:ciputra_patroli/widgets/text/notification_detail_tile.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class NotifikasiDetailPage extends StatelessWidget {
  final Map<String, dynamic> notification;

  NotifikasiDetailPage({required this.notification});

  @override
  Widget build(BuildContext context) {
    List<dynamic> updates = notification['updates'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          notification['title'] ?? 'Detail Kejadian',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff11c3a6b),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff11c3a6b).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTileWidget(Icons.place, 'Lokasi',
                      notification['location'] ?? 'Tidak diketahui'),
                  InfoTileWidget(Icons.access_time, 'Jam Kejadian',
                      notification['time'] ?? 'Tidak diketahui'),
                  InfoTileWidget(Icons.person, 'Korban',
                      notification['victimName'] ?? 'Tidak ada data'),
                  InfoTileWidget(Icons.home, 'Alamat Korban',
                      notification['victimAddress'] ?? 'Tidak ada data'),
                ],
              ),
            ),
            SizedBox(height: 20),
            TitleAnimation('Detail Kejadian'),
            Text(notification['details'] ?? 'Tidak ada detail',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TitleAnimation('Foto Kejadian'),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(2, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://cdn0-production-images-kly.akamaized.net/DsG497R5kke55KW1OyLrBiyczh0=/1200x1200/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/5043699/original/091518500_1733818957-1733755152199_fungsi-satpam.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            if (updates.isNotEmpty) ...[
              TitleAnimation('Update Tindakan'),
              Column(
                children: updates.map<Widget>((update) {
                  return OpenContainer(
                    closedElevation: 0,
                    openElevation: 4,
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedBuilder: (context, action) => Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading:
                            Icon(Icons.timeline, color: Color(0xff11c3a6b)),
                        title: Text(update['status'] ?? 'Tidak ada status',
                            style: TextStyle(fontSize: 14)),
                        subtitle: Text(update['time'] ?? 'Tidak ada waktu',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ),
                    openBuilder: (context, action) => Scaffold(
                      appBar: AppBar(
                        title: Text("Detail Tindakan"),
                        backgroundColor: Color(0xff11c3a6b),
                      ),
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(update['status'] ?? 'Tidak ada status',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text(update['time'] ?? 'Tidak ada waktu',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              Text('Belum ada update tindakan.',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
            ]
          ],
        ),
      ),
    );
  }
}
