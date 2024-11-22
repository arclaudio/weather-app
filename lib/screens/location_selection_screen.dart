import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  LatLng _selectedLocation = const LatLng(0, 0); // Initial selected location

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedLocation = tappedPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Return selected location to the previous screen
              Navigator.pop(context, _selectedLocation);
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (_) {}, // We don't use the map controller in this example
        onTap: _onMapTap,
        initialCameraPosition: CameraPosition(
          target: _selectedLocation,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: _selectedLocation,
          ),
        },
      ),
    );
  }
}
