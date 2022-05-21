import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController? controllers;
  final formKey=GlobalKey<FormState>();
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var Email, Subject,Message;
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.4219537, -122.0840252),
                  zoom: 15,
                ),
                zoomControlsEnabled: false,
                markers: markers.values.toSet(),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 250,
                height: 150,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "37.4219537 ,-122.0840252",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Address first line",
                          )),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Address second line",
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Form(
                      key:formKey,
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text("Contact Us",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                          Container(
                            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                            child: TextFormField(
                              validator: (email) {
                                if (email!.isEmpty || email == null) {
                                  return "Email required";
                                } else if (!emailValid.hasMatch(email)) {
                                  return "Email format is not valid";
                                } else {
                                  Email = email;
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                            child: TextFormField(
                              validator: (subject) {
                                if (subject!.isEmpty || subject == null) {
                                  return "Subject required";
                                }  else {
                                  Subject = subject;
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: 'Subject',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 20),
                            child: TextFormField(
                              validator: (message) {
                                if (message!.isEmpty || message == null) {
                                  return "Message required";
                                }  else {
                                  Message = message;
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: 'Message',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        padding:
                        const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        color: Color(0xFF002d56),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () {
                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                          //  SignInFunc(Email, Password);
                          }
                        },
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Send',
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controllers = controller;

    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(37.4219537, -122.0840252),
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
