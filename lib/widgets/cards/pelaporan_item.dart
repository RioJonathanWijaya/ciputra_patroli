import 'package:ciputra_patroli/models/event.dart';
import 'package:ciputra_patroli/views/kejadian/kejadian_detail_page.dart';
import 'package:flutter/material.dart';

class PelaporanItem extends StatelessWidget {
  final Kejadian event;
  const PelaporanItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(createRoute(event));
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://cdn0-production-images-kly.akamaized.net/DsG497R5kke55KW1OyLrBiyczh0=/1200x1200/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/5043699/original/091518500_1733818957-1733755152199_fungsi-satpam.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(event.location,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event.time,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue)),
                ],
              ),
            ),
            IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(createRoute(event));
                })
          ],
        ),
      ),
    );
  }
}

/// Custom transition for a smooth animation
Route createRoute(Kejadian event) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        KejadianDetailPage(event: event),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
