import 'package:ciputra_patroli/views/patroli/patroli_histori_page.dart';
import 'package:ciputra_patroli/views/patroli/patroli_mulai_page.dart';
import 'package:ciputra_patroli/widgets/button/patroli_button.dart';
import 'package:flutter/material.dart';

class PatroliPage extends StatelessWidget {
  const PatroliPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              "Selamat Siang",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
            ),
          ),
          const Text("Ahmad Santosa",
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          PatroliButton(
            icon: Icons.security,
            text: "Mulai Patroli",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StartPatroli()));
            },
          ),
          PatroliButton(
              icon: Icons.access_time,
              text: "History Patroli",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoriPatroli()));
              }),
        ],
      ),
    );
  }
}
