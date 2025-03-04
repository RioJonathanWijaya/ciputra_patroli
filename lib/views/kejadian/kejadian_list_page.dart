import 'package:ciputra_patroli/models/event.dart';
import 'package:ciputra_patroli/views/kejadian/kejadian_input_page.dart';
import 'package:ciputra_patroli/widgets/cards/pelaporan_item.dart';
import 'package:flutter/material.dart';

class ListKejadian extends StatefulWidget {
  const ListKejadian({super.key});

  @override
  State<ListKejadian> createState() => ListKejadianState();
}

class ListKejadianState extends State<ListKejadian> {
  final List<Kejadian> events = [
    Kejadian(
        image: 'assets/event.jpg',
        title: 'Music Concert',
        location: 'New York, USA',
        time: '6:00 PM'),
    Kejadian(
        image: 'assets/event.jpg',
        title: 'Tech Meetup',
        location: 'San Francisco, CA',
        time: '2:00 PM'),
  ];

  void openLaporanPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InputLaporanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return PelaporanItem(event: events[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openLaporanPage,
        backgroundColor: Color(0xff11c3a6b),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
