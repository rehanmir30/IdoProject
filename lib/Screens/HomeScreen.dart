import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gumshoe/Models/ActivityModel.dart';
import 'package:gumshoe/Screens/AboutUsScreen.dart';
import 'package:gumshoe/Screens/ActivityScreen.dart';
import 'package:gumshoe/Screens/ContactUsScreen.dart';
import 'package:gumshoe/Screens/JoinedActivitiesScreen.dart';
import 'package:gumshoe/Screens/LoginScreen.dart';
import 'package:gumshoe/Screens/MyActivitiesScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gumshoe/Screens/TermsOfUseScreen.dart';

import 'ScanScreen.dart';

class HomeScreen extends StatefulWidget {
  final String uid, name;

  const HomeScreen(this.uid, this.name, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String longi, lati;

  bool ActivityIdDialogError = false;
  bool PasswordDialogError = false;
  bool _isObscurePassword = true;

  String errorMessageActivityId = "";
  String errorMessageActivityPassword = "";


  final formKey = GlobalKey<FormState>();
  var id, password;
  var activityList = [];

  List<ActivityModel> allActivities = [];
  TextEditingController activityId = TextEditingController();
  TextEditingController activityPassword = TextEditingController();

  final databaseReference =
      FirebaseDatabase.instance.reference().child("Activities");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Welcome ' + widget.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: CarouselSlider(
                  options: CarouselOptions(height: 150.0),
                  items: [1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Text(
                              'Image $i',
                              style: TextStyle(fontSize: 16.0),
                            ));
                      },
                    );
                  }).toList(),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: EdgeInsets.only(top: 20, right: 12),
                    child: Text('Recent Activities ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Join an Activity'),
        onPressed: () {
          ActivityIdDialogError = false;
          PasswordDialogError = false;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextFormField(
                                  validator: (activityId) {

                                    // if (activityId!.isEmpty ||
                                    //     activityId == null) {
                                    //   return "Id required";
                                    // } else {
                                    //   id = activityId;
                                    //   return null;
                                    // }

                                    if (activityId!.isEmpty || activityId == null) {
                                      setState(() {
                                        errorMessageActivityId = "ID Required";
                                        ActivityIdDialogError = true;
                                      });
                                      return " ";
                                    } else {
                                      setState(() {
                                        ActivityIdDialogError = false;
                                        id = activityId;
                                      });
                                      return null;
                                    }
                                  },
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    hintText: 'Activity ID',
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Visibility(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          errorMessageActivityId,
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    visible: ActivityIdDialogError,
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  validator: (activityPassword) {

                                    // if (activityPassword!.isEmpty ||
                                    //     activityPassword == null) {
                                    //   return "Password required";
                                    // } else {
                                    //   password = activityPassword;
                                    //   return null;
                                    // }

                                    if (activityPassword!.isEmpty ||
                                        activityPassword == null) {
                                      setState(() {
                                        errorMessageActivityPassword = "Password Required";
                                        PasswordDialogError = true;
                                      });
                                      return "";
                                    }else {
                                      setState(() {
                                        PasswordDialogError = false;
                                        password = activityPassword;
                                      });
                                      return null;
                                    }
                                  },
                                  obscureText: _isObscurePassword,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: Icon(_isObscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscurePassword =
                                          !_isObscurePassword;
                                        });
                                      },
                                    ),
                                    hintText: 'Activity Password',
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Visibility(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          errorMessageActivityPassword,
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    visible: PasswordDialogError,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState != null &&
                                              formKey.currentState!
                                                  .validate()) {
                                            activityList.clear();
                                            DatabaseReference
                                                databaseReference =
                                                FirebaseDatabase.instance
                                                    .reference();
                                            databaseReference
                                                .child("Activities")
                                                .once()
                                                .then((DatabaseEvent value) {
                                              if (value.snapshot
                                                  .child(id)
                                                  .exists) {
                                                String pass = value.snapshot
                                                    .child(id)
                                                    .child("password")
                                                    .value
                                                    .toString();
                                                if (widget.uid ==
                                                    value.snapshot
                                                        .child(id)
                                                        .child("manager")
                                                        .value
                                                        .toString()) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "You are the manager of this activity. Can't join as user");
                                                  return;
                                                } else if (password == pass) {
                                                  joinActivity(id.toString());
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActivityScreen(id,
                                                                widget.uid)),
                                                  );

                                                  //Move to next screen from here
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "Wrong Password");
                                                  return;
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "No such activity found.");
                                                return;
                                              }
                                            });
                                          } else
                                            return;
                                        },
                                        child: Text("Join")),
                                    SizedBox(width: 10),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(Icons.qr_code_scanner), onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScanScreen(widget.uid)),
                                          );
                                        },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      endDrawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          ListTile(
            title: const Text(
              'My Activities',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.calendar_view_month),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyActivitiesScreen(widget.uid, widget.name)));
            },
          ),
          ListTile(
            title: const Text(
              'Joined Activities',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.calendar_view_month),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          JoinedActivities(widget.uid, widget.name)));
            },
          ),
          ListTile(
            title: const Text(
              'Settings',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              'About Us',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.account_circle_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()));
            },
          ),
          ListTile(
            title: const Text(
              'Terms of Use',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.add_moderator),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TermsOfUseScreen()));
            },
          ),
          ListTile(
            title: const Text(
              'Contact Us',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.contact_mail),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()));
            },
          ),
          ListTile(
            title: const Text(
              'Log Out',
              textAlign: TextAlign.end,
            ),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => new CupertinoAlertDialog(
                  title: new Text("Are you Sure",
                      style: TextStyle(fontSize: 19, color: Colors.black)),
                  content: new Text("You want to Log out."),
                  actions: [
                    CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: new Text("Close")),
                    CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Log out Successfully.");
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: new Text("LOG OUT"))
                  ],
                ),
              );
            },
          ),
        ]),
      ),
    ));
  }

  joinActivity(String id) async {
    String currentTime = DateTime.now().toString();

    await databaseReference
        .child(id)
        .child("Members")
        .child(widget.uid)
        .child("Last Opened")
        .set(currentTime);
    Fluttertoast.showToast(msg: "Joined successfully");
  }
}
