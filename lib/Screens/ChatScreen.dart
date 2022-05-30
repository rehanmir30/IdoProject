import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../External Widgets/messages.dart';

class ChatScreen extends StatefulWidget {
  final activityId,userId;
  const ChatScreen(this.activityId,this.userId,{Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String activityName="";
  String userName="";

  final TextEditingController message = new TextEditingController();
  final fs = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activityName),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              child: messages(
                email: "email",
                userId:widget.userId,
                activityId:widget.activityId
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[100],
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.purple),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.purple),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs.collection(widget.activityId).doc().set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'userid': widget.userId,
                        'username':userName
                      });
                      message.clear();
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  @override
  void initState() {
    getActivityDetails();
    getUserDetail();
  }
  Future getUserDetail() async{

    final databaseReferance3=await FirebaseDatabase.instance.reference().child("Users").child(widget.userId);
    await databaseReferance3.child("Name").once().then((value) {
      userName=value.snapshot.value.toString();
    });


  }
  void getActivityDetails() async{
    final databaseReferance=await FirebaseDatabase.instance.reference().child("Activities").child(widget.activityId);

    await databaseReferance.child("name").once().then((value) {
      setState(() {
        activityName=value.snapshot.value.toString();
      });
    });
  }
}

