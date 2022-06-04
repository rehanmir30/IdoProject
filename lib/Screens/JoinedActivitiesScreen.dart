import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../External Widgets/Loading.dart';
import '../Models/ActivityModel.dart';
import 'ActivityScreen.dart';

class JoinedActivities extends StatefulWidget {
  final String uid, username;

  const JoinedActivities(this.uid, this.username, {Key? key}) : super(key: key);

  @override
  State<JoinedActivities> createState() => _JoinedActivitiesState();
}

class _JoinedActivitiesState extends State<JoinedActivities> {
  List<ActivityModel> allActivities = [];
  List<ActivityModel> myActivities = [];
  List<String> joindedActivityId = [];
  List<String> ActivtiyId = [];
  List<String> MatchedActivtiyId = [];
  List<ActivityModel> ActivtiyDetail = [];
  List<int> NumberOfMembers = [];
  var test = FirebaseDatabase.instance.reference().child("Activities");

  bool viewVisible = false;

  Future getAllActivities() async {
    // final databaseReference =
    // await FirebaseDatabase.instance.reference().child("Activities");
    await test.once().then((value) {
      allActivities.clear();
      ActivtiyId.clear();
      MatchedActivtiyId.clear();
      for (var id in value.snapshot.children) {
        ActivtiyId.add(id.key.toString());
      }
    });
    print(ActivtiyId.length);

    for (int i = 0; i < ActivtiyId.length; i++) {
      await test.child(ActivtiyId[i]).once().then((value) {
        if (value.snapshot.child("Members").exists) {
          for (var mem in value.snapshot.child("Members").children) {
            if (widget.uid == mem.key.toString()) {
              MatchedActivtiyId.add(ActivtiyId[i]);
            }
          }
        }
      });
    }

    await getJoinedActivityDetail();
    await getMembersLength();
  }

  getMembersLength() async {
    int count = 0;
    NumberOfMembers.clear();
    for (int i = 0; i < MatchedActivtiyId.length; i++) {
      await test.child(MatchedActivtiyId[i]).once().then((value) {
        if (value.snapshot.child("Members").exists) {
          count = value.snapshot.child("Members").children.length;
          NumberOfMembers.add(count);
        } else {
          NumberOfMembers.add(0);
        }
      });
    }
  }

  getJoinedActivityDetail() async {
    ActivtiyDetail.clear();
    for (int i = 0; i < MatchedActivtiyId.length; i++) {
      String Name, Manager, pass;
      await test.child(MatchedActivtiyId[i]).once().then((value) {
        Name = value.snapshot.child("name").value.toString();
        Manager = value.snapshot.child("manager").value.toString();
        pass = value.snapshot.child("password").value.toString();

        ActivityModel activityModel = ActivityModel(
            name: Name,
            manager: Manager,
            password: pass,
            id: MatchedActivtiyId[i]);
        ActivtiyDetail.add(activityModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joined Activities'),
      ),
      body: FutureBuilder(
          future: getAllActivities(),
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null) {
              //print('project snapshot data is: ${projectSnap.data}');
              return Container(
                margin: EdgeInsets.only(top: 12),
                child: Text('You have no active activities'),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: ActivtiyDetail.length,
                itemBuilder: (context, index) {
                  var currentItem = ActivtiyDetail[index];
                  if (ActivtiyDetail.length < 1 ||
                      ActivtiyDetail.length == null) {
                    return Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Text('You have no active activities'),
                    );
                  } else
                    return Container(
                      width: double.infinity,
                      height: 170,
                      padding: new EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivityScreen(
                                      ActivtiyDetail[index].id, widget.uid)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          child: Column(
                            children: [
                              ListTile(
                                title: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(currentItem.name,
                                          style: TextStyle(fontSize: 24.0)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.location_city, size: 40),
                                    ],
                                  ),
                                ),
                                subtitle: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "Members : " +
                                                NumberOfMembers[index]
                                                    .toString() ??
                                            "0",
                                        style: TextStyle(fontSize: 15.0)),
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      Share.share("Activity Created By: " +
                                          widget.username +
                                          "\n\nActivity id: " +
                                          currentItem.id +
                                          "\nActivity pass: " +
                                          currentItem.password);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                },
              );
            }
          }),
    );
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
