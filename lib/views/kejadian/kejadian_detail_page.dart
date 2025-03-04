import 'package:ciputra_patroli/models/event.dart';
import 'package:ciputra_patroli/widgets/text/animated_title.dart';
import 'package:flutter/material.dart';

class KejadianDetailPage extends StatelessWidget {
  final Kejadian event;

  const KejadianDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    Color mainColor = const Color(0xff11c3a6b);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  buildDetailItem(Icons.calendar_today, "Tanggal",
                      "10 Januari 2025", mainColor),
                  SizedBox(
                    width: 75,
                  ),
                  buildDetailItem(Icons.access_time, "Jam", "10:30", mainColor),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildSectionTitle("Penanggung Jawab", mainColor),
            buildInfoBox("John Doe", mainColor),
            const SizedBox(height: 20),
            buildSectionTitle("Foto Kejadian", mainColor),
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
            const SizedBox(height: 30),
            buildSectionTitle("Lokasi Kejadian", mainColor),
            buildInfoBox("Cluster Emerald Timur 8", mainColor),
            const SizedBox(height: 20),
            buildSectionTitle("Deskripsi Kejadian", mainColor),
            buildDescriptionBox(
              "dasadbajbdsajbdajidbajbdajbdjahdiuahduiqbwduiqbdiuqwbduiqbdquibdqiubdqiudbqiudbqdbqadhavdhsauvduhavduavdaudvsauyvdsauydvauvdauysvduavdsuayvdauysvduyavsdhsabdvahjvdsajhvdaduywqvydqvdqvdqdvquvdquyvdwyuqvdyuqvd",
              mainColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, Color color) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TitleAnimation(title));
  }

  Widget buildDetailItem(
      IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ],
    );
  }

  Widget buildInfoBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget buildDescriptionBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
