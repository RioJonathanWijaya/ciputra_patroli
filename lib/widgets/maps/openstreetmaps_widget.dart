import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenStreetMapWidget extends StatefulWidget {
  const OpenStreetMapWidget({super.key});

  @override
  State<OpenStreetMapWidget> createState() => _OpenStreetMapWidgetState();
}

class _OpenStreetMapWidgetState extends State<OpenStreetMapWidget> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  bool isLoading = true;
  LatLng? _currentPosition;
  LatLng? _destination;
  List<LatLng> _routes = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _initializeLocation() async {
    if (!await _checkRequestPermission()) return;

    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(locationData.latitude!, locationData.longitude!);
          isLoading = false; // stop loading once location is obtained
        });
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentPosition!, 15);
    } catch (e) {
      const SnackBar(content: Text("Location is not available"));
    }
  }

  Future<bool> _checkRequestPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? LatLng(0, 0),
              initialZoom: _currentPosition != null ? 15 : 2,
              minZoom: 0,
              maxZoom: 100,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              CurrentLocationLayer(
                style: const LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: Size(35, 35),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _getCurrentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.my_location,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
