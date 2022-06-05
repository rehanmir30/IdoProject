import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gumshoe/Models/IncidentsModel.dart';
import 'package:gumshoe/Screens/ChatScreen.dart';
import 'package:label_marker/label_marker.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class ActivityScreen extends StatefulWidget {
  final activityId, userId;

  const ActivityScreen(this.activityId, this.userId, {Key? key})
      : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Set<Marker> markers = {};
  MapType _currentMapType = MapType.normal;
  var longi, lati;
  List<String> members = [];
  List<String> incidentsList = [];
  GoogleMapController? controller;
  final formKey = GlobalKey<FormState>();
  String IncidentName = "";
  TextEditingController incidentName = TextEditingController();
  Location _locationTracker = Location();

  List<String> incidentCatagories = ['Man', 'Danger', 'General'];
  List<String> incidentColors = [
    'Red',
    'Yellow',
    'Green',
  ];
  String selectedCatagory = '';
  String selectedColor = '';

  @override
  void initState() {
    selectedCatagory = incidentCatagories[0];
    selectedColor = incidentColors[0];

    //getPosition();
    getAllMembers();
    getIncidents();
  }

  Future getIncidents() async {
    incidentsList.clear();
    await Firebase.initializeApp();
    final databaseReferance = await FirebaseDatabase.instance
        .reference()
        .child("Activities")
        .child(widget.activityId)
        .child("Incidents");

    await databaseReferance.once().then((value) {
      for (var element in value.snapshot.children) {
        incidentsList.add(element.key.toString());
      }
    });
  }

  // getPosition() async {
  //
  //
  //   Position? position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   longi = position.longitude;
  //   lati = position.latitude;
  // }

  Future getAllMembers() async {
    members.clear();
    await Firebase.initializeApp();
    final databaseReference = await FirebaseDatabase.instance
        .reference()
        .child("Activities")
        .child(widget.activityId)
        .child("Members");

    await databaseReference.once().then((value) {
      for (var element in value.snapshot.children) {
        members.add(element.key.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        mapToolbarEnabled: false,
        mapType: _currentMapType,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 14,
        ),
        zoomControlsEnabled: false,
        markers: markers,
        onMapCreated: ((mapController) {
          setState(() {
            controller = mapController;
          });
          makingMarkers();
        }),
        onLongPress: (latlang) {
          _addMarkerLongPress(latlang);
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 30, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentMapType = (_currentMapType == MapType.normal)
                      ? MapType.satellite
                      : MapType.normal;
                });
              },
              child: Icon(Icons.change_circle),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(widget.activityId, widget.userId)),
                );
              },
              child: Icon(Icons.chat),
            )
          ],
        ),
      ),
    );
  }

  Future makingMarkers() async {
    // await getPosition();
    final title = "Me";
    var location = await _locationTracker.getLocation();
    setState(() {
      lati = location.latitude;
      longi = location.longitude;
    });

    _locationTracker.onLocationChanged.listen((newLocalData) {
      if (controller != null) {
        lati = location.latitude;
        longi = location.longitude;
        setState(() {
          lati = location.latitude;
          longi = location.longitude;
        });
        controller!.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                target: LatLng(location.latitude!, location.longitude!),
                zoom: 14)));

        this.setState(() {
          markers
              .addLabelMarker(LabelMarker(
            label: title,
            markerId: MarkerId(title),
            position: LatLng(location.latitude!, location.longitude!),
            backgroundColor: Colors.green,
          ))
              .then(
            (value) {
              setState(() {});
            },
          );
        });

        print("new Longitude " + lati.toString());
      } else {
        Fluttertoast.showToast(msg: "Controller is null");
      }
    });
    // var newPosition = CameraPosition(target: LatLng(lati, longi), zoom: 12);
    // CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
    // controller?.moveCamera(update);
    //
    // markers
    //     .addLabelMarker(LabelMarker(
    //   label: title,
    //   markerId: MarkerId(title),
    //   position: LatLng(lati, longi),
    //   backgroundColor: Colors.green,
    // ))
    //     .then(
    //   (value) {
    //     setState(() {});
    //   },
    // );
    await setIncidentMarkers();
    await setMarkerOfAllMembers();
  }

  Future setIncidentMarkers() async {
    await Firebase.initializeApp();

    final databaseReference = await FirebaseDatabase.instance
        .reference()
        .child("Activities")
        .child(widget.activityId)
        .child("Incidents");

    for (int i = 0; i < incidentsList.length; i++) {
      var i_longi, i_lati, i_name, i_color;
      await databaseReference
          .child(incidentsList[i])
          .child("Name")
          .once()
          .then((value) {
        i_name = value.snapshot.value;
      });
      await databaseReference
          .child(incidentsList[i])
          .child("Latitude")
          .once()
          .then((value) {
        i_lati = value.snapshot.value;
      });
      await databaseReference
          .child(incidentsList[i])
          .child("Longitude")
          .once()
          .then((value) {
        i_longi = value.snapshot.value;
      });
      await databaseReference
          .child(incidentsList[i])
          .child("Color")
          .once()
          .then((value) {
        i_color = value.snapshot.value;
      });

      if (i_color == "Red") {
        markers
            .addLabelMarker(LabelMarker(
          label: i_name,
          markerId: MarkerId(i_name),
          position: LatLng(i_lati, i_longi),
          backgroundColor: Colors.red,
        ))
            .then(
          (value) {
            setState(() {});
          },
        );
      } else if (i_color == "Green") {
        markers
            .addLabelMarker(LabelMarker(
          label: i_name,
          markerId: MarkerId(i_name),
          position: LatLng(i_lati, i_longi),
          backgroundColor: Colors.lightGreen,
        ))
            .then(
          (value) {
            setState(() {});
          },
        );
      } else if (i_color == "Yellow") {
        markers
            .addLabelMarker(LabelMarker(
          label: i_name,
          markerId: MarkerId(i_name),
          position: LatLng(i_lati, i_longi),
          backgroundColor: Colors.yellow,
        ))
            .then(
          (value) {
            setState(() {});
          },
        );
      }
    }
  }

  Future setMarkerOfAllMembers() async {
    await Firebase.initializeApp();

    final databaseReference =
        await FirebaseDatabase.instance.reference().child("Users");
    for (int i = 0; i < members.length; i++) {
      if (members[i] != widget.userId) {
        var m_longi, m_lati, m_name;
        await databaseReference
            .child(members[i])
            .child("Longitude")
            .once()
            .then((value) {
          m_longi = value.snapshot.value;
        });
        await databaseReference
            .child(members[i])
            .child("Latitude")
            .once()
            .then((value) {
          m_lati = value.snapshot.value;
        });
        await databaseReference
            .child(members[i])
            .child("Name")
            .once()
            .then((value) {
          m_name = value.snapshot.value;
        });
        final title = m_name;
        markers
            .addLabelMarker(LabelMarker(
          label: title,
          markerId: MarkerId(title),
          position: LatLng(m_lati, m_longi),
          backgroundColor: Colors.green,
        ))
            .then(
          (value) {
            setState(() {});
          },
        );
      }
    }
  }

  void _addMarkerLongPress(LatLng latlang) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Add a marker!",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: TextFormField(
                              validator: (incidentName) {
                                if (incidentName!.isEmpty ||
                                    incidentName == null) {
                                  return "Name required";
                                } else {
                                  IncidentName = incidentName;
                                  return null;
                                }
                              },
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: DropdownButtonFormField(
                              elevation: 8,
                              isExpanded: true,
                              iconSize: 0.0,
                              hint: Text('Select Catagory'),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.arrow_drop_down),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.blue))),
                              items: incidentCatagories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(value)),
                                );
                              }).toList(),
                              value: incidentCatagories[0],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCatagory = newValue as String;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: DropdownButtonFormField(
                              elevation: 8,
                              iconSize: 0.0,
                              isExpanded: true,
                              hint: Text('Select Color'),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.arrow_drop_down),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.blue))),
                              items: incidentColors.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(value)),
                                );
                              }).toList(),
                              value: incidentColors[0],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedColor = newValue as String;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState != null &&
                                          formKey.currentState!.validate()) {
                                        marknewIncidentOnMaps(latlang);
                                        Navigator.pop(context);
                                      } else {
                                        return;
                                      }
                                    },
                                    child: Text("Add Marker")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Future<Uint8List> getMarker(String path) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(path);
    return byteData.buffer.asUint8List();
  }

  marknewIncidentOnMaps(LatLng latLng) async {
    final title = IncidentName;

    Uint8List personData = await getMarker("assets/images/person.png");

    await Firebase.initializeApp();
    final databaseReferance = await FirebaseDatabase.instance
        .reference()
        .child("Activities")
        .child(widget.activityId)
        .child("Incidents");

    String? key = await databaseReferance.push().key;

    await databaseReferance.child(key!).child("Name").set(IncidentName);
    await databaseReferance.child(key).child("Longitude").set(latLng.longitude);
    await databaseReferance.child(key).child("Latitude").set(latLng.latitude);
    await databaseReferance.child(key).child("Marked by").set(widget.userId);
    await databaseReferance.child(key).child("Catagory").set(selectedCatagory);
    await databaseReferance.child(key).child("Color").set(selectedColor);

    if (selectedCatagory == "Man" && selectedColor == "Red") {
      markers
          .addLabelMarker(LabelMarker(
              label: title,
              markerId: MarkerId(title),
              position: LatLng(latLng.latitude, latLng.longitude),
              backgroundColor: Colors.red,
              draggable: false,
              zIndex: 2,
              flat: true,
              anchor: Offset(0.5, 0.5),
              icon: BitmapDescriptor.fromBytes(personData)))
          .then(
        (value) {
          setState(() {});
        },
      );
    }

    // if (selectedColor == "Red") {
    //   markers
    //       .addLabelMarker(LabelMarker(
    //     label: title,
    //     markerId: MarkerId(title),
    //     position: LatLng(latLng.latitude, latLng.longitude),
    //     backgroundColor: Colors.red,
    //   ))
    //       .then(
    //     (value) {
    //       setState(() {});
    //     },
    //   );
    // }
    else if (selectedColor == "Yellow") {
      markers
          .addLabelMarker(LabelMarker(
        label: title,
        markerId: MarkerId(title),
        position: LatLng(latLng.latitude, latLng.longitude),
        backgroundColor: Colors.yellow,
      ))
          .then(
        (value) {
          setState(() {});
        },
      );
    } else if (selectedColor == "Green") {
      markers
          .addLabelMarker(LabelMarker(
        label: title,
        markerId: MarkerId(title),
        position: LatLng(latLng.latitude, latLng.longitude),
        backgroundColor: Colors.lightGreen,
      ))
          .then(
        (value) {
          setState(() {});
        },
      );
    }
  }
}
