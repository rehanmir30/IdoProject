import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../Models/ActivityModel.dart';
import 'ActivityScreen.dart';

class JoinedActivities extends StatefulWidget {
  final String uid,username;

  const JoinedActivities(this.uid,this.username, {Key? key}) : super(key: key);

  @override
  State<JoinedActivities> createState() => _JoinedActivitiesState();
}

class _JoinedActivitiesState extends State<JoinedActivities> {
  List<ActivityModel> allActivities = [];
  List<ActivityModel> myActivities = [];

  Future getAllActivities() async {
    final databaseReference =
    await FirebaseDatabase.instance.reference().child("Activities");
    await databaseReference.get().then((event) {
      allActivities.clear();
      for (final entity in event.children) {
        String name = entity.child("name").value.toString();
        String manager = entity.child("manager").value.toString();
        String id = entity.child("id").value.toString();
        String password = entity.child("password").value.toString();
        ActivityModel activitymodel = ActivityModel(
            name: name, manager: manager, password: password, id: id);
        allActivities.add(activitymodel);
      }
      print("all activities length: " + allActivities.length.toString());
      print("all activities length: " + allActivities.length.toString());
      myActivities = getJoinedActivities(allActivities);
    });
  }

  getJoinedActivities(List<ActivityModel> allActivities) {
    List<ActivityModel> myActivities = [];
    myActivities.clear();
    for (var activity in allActivities) {
      if (activity.manager == widget.uid) {
        myActivities.add(activity);
      }
    }
    return myActivities;
  }



  @override
  Widget build(BuildContext context) {
    return       Scaffold(
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
                  itemCount: myActivities.length,
                  itemBuilder: (context, index) {
                    var currentItem = myActivities[index];
                    if (myActivities.length < 1 ||
                        myActivities.length == null) {
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
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityScreen(myActivities[index].id,widget.uid)));
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
                                      child: Text("Members : 0",
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
                                            "\n\nActivity Name: " +
                                            currentItem.name +
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
            }));
  }
}
