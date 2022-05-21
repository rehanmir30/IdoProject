import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

class ActivityScreen extends StatefulWidget {
  final activityId, userId;

  const ActivityScreen(this.activityId, this.userId, {Key? key})
      : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  var camera_longi ;
  var camera_lati ;
  GoogleMapController? controllers;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    getCameraLocation();
  }

  Future getCameraLocation() async {
    await Firebase.initializeApp();
    final databaseReference = await FirebaseDatabase.instance.reference();
    await databaseReference
        .child("Users")
        .child(widget.userId)
        .child("Latitude")
        .once()
        .then((value) {
      camera_lati = value.snapshot.value;
    });
    await databaseReference
        .child("Users")
        .child(widget.userId)
        .child("Longitude")
        .once()
        .then((value) {
      camera_longi =value.snapshot.value;
    });
    // print("Longitude= " + camera_longi.toString() + " + " + " Latitude= " + camera_lati.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.4219537 ,-122.0840252),
          zoom: 15,
        ),
        zoomControlsEnabled: true,
        markers: markers.values.toSet(),

      ),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    controllers = controller;

    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(37.4219537 ,-122.0840252),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'Test',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

}
