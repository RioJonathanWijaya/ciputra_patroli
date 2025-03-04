import 'dart:async';
import 'dart:io';
import 'package:ciputra_patroli/widgets/appbar/appbar.dart';
import 'package:ciputra_patroli/widgets/maps/openstreetmaps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class StartPatroli extends StatefulWidget {
  const StartPatroli({super.key});

  @override
  _StartPatroliState createState() => _StartPatroliState();
}

class _StartPatroliState extends State<StartPatroli> {
  LatLng _currentLocation = const LatLng(0, 0);
  late final MapController _mapController;
  final TextEditingController _textController = TextEditingController();
  late DraggableScrollableController _draggableController;
  late String tanggalPatroli;
  late String jamMulaiPatroli;
  late DateTime startTime;
  late String durationString;
  late Timer timer;
  File? buktiImage;
  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    tanggalPatroli = DateFormat('dd MMMM yyyy').format(DateTime.now());
    startTime = DateTime.now();
    jamMulaiPatroli = DateFormat('HH:mm:ss').format(startTime);
    durationString = _formatDuration(const Duration(minutes: 0));
    _getCurrentLocation();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    return '$minutes menit';
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        Duration diff = DateTime.now().difference(startTime);
        durationString = _formatDuration(diff);
      });
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    print("test");

    if (pickedFile != null) {
      setState(() {
        buktiImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation, 15.0);
    });

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation, 15.0);
      });
    });
  }

  void submitForm() {
    print("Tanggal Patroli: $tanggalPatroli");
    print("Jam Mulai Patroli: $jamMulaiPatroli");
    print("Lokasi: $_currentLocation");
    print("Durasi Patroli: $durationString");
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Patroli berhasil disimpan!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Mulai Patroli"),
      body: Stack(
        children: [
          OpenStreetMapWidget(),
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              controller: _draggableController,
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.6,
              snapSizes: const [0.3, 0.6],
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Patroli Ke-2",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_pin),
                                        SizedBox(width: 5),
                                        Text("Cluster Emerald Timur",
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    const Text("Tanggal Patroli",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(tanggalPatroli,
                                        style: const TextStyle(fontSize: 20)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://cdn0-production-images-kly.akamaized.net/DsG497R5kke55KW1OyLrBiyczh0=/1200x1200/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/5043699/original/091518500_1733818957-1733755152199_fungsi-satpam.jpg',
                                        height: 90,
                                        width: 90,
                                      ),
                                    ),
                                    const Text(
                                      "Isyak Wahjudi",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "60289",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Divider(height: 50, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Jam Mulai Patroli",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(jamMulaiPatroli,
                                        style: const TextStyle(fontSize: 20)),
                                  ],
                                ),
                                const SizedBox(width: 85),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Durasi Patroli",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(durationString,
                                        style: const TextStyle(fontSize: 20)),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Text("Bukti Patroli",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text(
                                "(diwajibkan foto selfie dengan menunjukkan wajah dan lokasi patroli.)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 14)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: pickImage,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.add, size: 32),
                            ),
                            const SizedBox(height: 20),
                            buktiImage != null
                                ? Image.file(buktiImage!,
                                    width: 100, height: 100)
                                : Container(),
                            const Text("Foto Kejadian (bila ada)",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: pickImage,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.add, size: 32),
                            ),
                            const SizedBox(height: 20),
                            buktiImage != null
                                ? Image.file(buktiImage!,
                                    width: 100, height: 100)
                                : Container(),
                            const SizedBox(height: 20),
                            const Text("Keterangan Kejadian",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 10),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _textController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter some text";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: submitForm,
                              child: const Text("Selesai Patroli"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
