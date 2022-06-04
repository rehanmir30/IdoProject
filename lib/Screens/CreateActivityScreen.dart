import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gumshoe/Models/ActivityModel.dart';

class CreateActivityScreen extends StatefulWidget {
  final String uid;

  const CreateActivityScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final formKey = GlobalKey<FormState>();
  var activityName, activityPassword, activityConfirmPassword;

  bool nameError = false;
  bool passwordError = false;
  bool confirmpasswordError = false;

  String errorMessageName = "";
  String errorMessagePassword = "";
  String errorMessageConfirmPassword = "";

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController c_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create New Activity'),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        validator: (name) {
                          if (name!.isEmpty || name == null) {
                            setState(() {
                              errorMessageName = "Name Required";
                              nameError = true;
                            });
                            return "";
                          } else {
                            setState(() {
                              nameError = false;
                            });
                            activityName = name;
                            return null;
                          }

                          //////////////////////

                          if (name!.isEmpty || name == null) {
                            return "Name required";
                          } else {
                            activityName = name;
                            return null;
                          }
                        },
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'Activity Name',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    //Error Continer
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Visibility(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              errorMessageName,
                              style: TextStyle(color: Colors.red),
                            )),
                        visible: nameError,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        validator: (password) {

                          if (password!.isEmpty || password == null) {
                            setState(() {
                              errorMessagePassword = "Password Required";
                              passwordError = true;
                            });
                            return "";
                          } else if (password.length < 6) {
                            setState(() {
                              errorMessagePassword =
                              "Password should be greater then 6 characters";
                              passwordError = true;
                            });
                            return "";
                          } else {
                            setState(() {
                              passwordError = false;
                            });
                            activityPassword = password;
                            return null;
                          }
                        },
                        obscureText: true,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'Activity Password',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    //Error Container
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Visibility(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              errorMessagePassword,
                              style: TextStyle(color: Colors.red),
                            )),
                        visible: passwordError,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        validator: (c_password) {
                          if (c_password!.isEmpty || c_password == null) {
                            setState(() {
                              errorMessageConfirmPassword =
                              "Confirm Password Required";
                              confirmpasswordError = true;
                            });
                            return "";
                          }else if (c_password != activityPassword) {
                            setState(() {
                              errorMessageConfirmPassword = "Passwords don't match";
                              confirmpasswordError = true;
                            });
                            return "";
                          } else {
                            setState(() {
                              confirmpasswordError = false;
                            });
                            activityConfirmPassword = c_password;
                            return null;
                          }

                        },
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'Confirm Activity Password',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    //Error Container

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Visibility(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              errorMessageConfirmPassword,
                              style: TextStyle(color: Colors.red),
                            )),
                        visible: confirmpasswordError,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFFFFFF),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState != null &&
                                      formKey.currentState!.validate()) {
                                    CreateActivityFun();
                                  } else
                                    return;
                                },
                                child: Text("Create Activity")),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void CreateActivityFun() async {
    Firebase.initializeApp();
    // String currentTime=DateTime.now().toString();
    int min = 10000; //min and max values act as your 6 digit range
    int max = 99999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);

    final databaseReference =
    FirebaseDatabase.instance.reference().child("Activities");
    databaseReference.child(rNum.toString()).set({
      'name': activityName,
      'password': activityPassword,
      'manager': widget.uid,
      'id': rNum
    }).asStream();
// ActivityModel activityModel=ActivityModel(name: activityName, manager: widget.uid, password: activityPassword, id: rNum.toString());
    Fluttertoast.showToast(
        msg: "Activity created successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}