import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gumshoe/External%20Widgets/Loading.dart';
import 'package:gumshoe/Models/UserModel.dart';

class EditActivityScreen extends StatefulWidget {
  final String activityId, activityName, activityPassword;

  const EditActivityScreen(
      this.activityId, this.activityName, this.activityPassword,
      {Key? key})
      : super(key: key);

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  String newActivityName = "";
  String newActivityPassword = "";
  final formKey = GlobalKey<FormState>();
  List<String> memberIds = [];
  List<UserModel> members = [];
  bool viewVisible = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    showWidget();
    getActivityDetails();
  }

  getActivityDetails() async {
    final databaseReference = await FirebaseDatabase.instance
        .reference()
        .child("Activities")
        .child(widget.activityId)
        .child("Members");
    memberIds.clear();
    await databaseReference.once().then((value) {
      for (var member in value.snapshot.children) {
        memberIds.add(member.key.toString());
      }
    });
    // getMemberDetails();
    hideWidget();
  }

  Future getMemberDetails() async {
    final databaseReferance =
        FirebaseDatabase.instance.reference().child("Users");
    members.clear();
    for (int i = 0; i < memberIds.length; i++) {
      String name = "";
      await databaseReferance
          .child(memberIds[i])
          .child("Name")
          .once()
          .then((value) {
        name = value.snapshot.value.toString();
      });
      UserModel user = UserModel(name: name, id: memberIds[i]);
      members.add(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit " + widget.activityName),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            validator: (nameController) {
                              if (nameController!.isEmpty ||
                                  nameController == null) {
                                return "Name required";
                              } else {
                                newActivityName = nameController;
                                return null;
                              }
                            },
                            initialValue: widget.activityName,
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
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            validator: (passwordController) {
                              if (passwordController!.isEmpty ||
                                  passwordController == null) {
                                return "Password required";
                              } else {
                                newActivityPassword = passwordController;
                                return null;
                              }
                            },
                            initialValue: widget.activityPassword,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: Text(
                              ': Members ',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: FutureBuilder(
                            future: getMemberDetails(),
                            builder: (context, projectSnap) {
                              if (projectSnap.connectionState ==
                                      ConnectionState.none &&
                                  projectSnap.hasData == null) {
                                //print('project snapshot data is: ${projectSnap.data}');
                                return Container(
                                  margin: EdgeInsets.only(top: 12),
                                  child: Text('You have no active activities'),
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: members.length,
                                  itemBuilder: (context, int index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons
                                                .remove_circle_outline_rounded),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext
                                                        context) =>
                                                    new CupertinoAlertDialog(
                                                  title: new Text(
                                                      "Are you Sure",
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color: Colors.black)),
                                                  content: new Text(
                                                      "You want to remove this member?"),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            new Text("Close")),
                                                    CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () async {
                                                          await FirebaseDatabase
                                                              .instance
                                                              .reference()
                                                              .child(
                                                                  "Activities")
                                                              .child(widget
                                                                  .activityId)
                                                              .child("Members")
                                                              .child(
                                                                  members[index]
                                                                      .id)
                                                              .remove();
                                                          setState(() {
                                                            members.removeAt(
                                                                index);
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: new Text("Yes"))
                                                  ],
                                                ),
                                              );
                                            }),
                                        Text(members[index].name)
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            children: [
                              // Expanded(
                              //   child: ElevatedButton(
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       style: ElevatedButton.styleFrom(
                              //         primary: Color(0xFFFFFFFF),
                              //       ),
                              //       child: Text(
                              //         'Cancel',
                              //         style: TextStyle(color: Colors.black),
                              //       )),
                              // ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState != null &&
                                          formKey.currentState!.validate()) {
                                        UpdateActivityData();
                                      } else
                                        return;
                                    },
                                    child: Text("Update Changes")),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Positioned.fill(
              child: Visibility(
            visible: viewVisible,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Align(alignment: Alignment.center, child: LoadingWidget()),
            ),
          ))
        ],
      ),
    );
  }

  UpdateActivityData()async{
    final database= await FirebaseDatabase.instance.reference().child("Activities").child(widget.activityId);

    database.child("name").set(newActivityName);
    database.child("password").set(newActivityPassword);

    Fluttertoast.showToast(msg: "Changes saved successfully");
    Navigator.pop(context);


  }

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }
}
