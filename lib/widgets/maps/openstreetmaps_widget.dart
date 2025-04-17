import 'dart:developer';
import 'package:ciputra_patroli/models/penugasan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapWidget extends StatefulWidget {
  final Penugasan penugasan;

  const OpenStreetMapWidget({Key? key, required this.penugasan})
      : super(key: key);

  @override
  State<OpenStreetMapWidget> createState() => _OpenStreetMapWidgetState();
}

class _OpenStreetMapWidgetState extends State<OpenStreetMapWidget> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    _currentPosition = LatLng(-7.288670, 112.634888);
    setState(() {});
  }

  List<Marker> _generateMarkersFromTitikPatroli() {
    return widget.penugasan.titikPatroli.map<Marker>((titik) {
      final lat = titik['lat'];
      final lng = titik['lng'];

      return Marker(
        point: LatLng(lat, lng),
        width: 80,
        height: 80,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 15,
                minZoom: 0,
                maxZoom: 100,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                CurrentLocationLayer(),
                MarkerLayer(
                  markers: _generateMarkersFromTitikPatroli(),
                ),
              ],
            ),
    );
  }
}
