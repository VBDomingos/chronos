import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDialog extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapDialog({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    print('latitude: $latitude');
    print('longitude: $longitude');
    return Dialog(
      child: Container(
        width: double.infinity,
        height: 400,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(latitude, longitude),
                  builder: (ctx) => Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
