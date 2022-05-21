import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'About Us',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Text(
                  "Some information related to the App",
                  style: TextStyle(fontSize: 16),
                )),
            Expanded(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/aboutUsbg.png"),
                              fit: BoxFit.fill)),
                      child: Column(children: [
                        Container(
                            margin: EdgeInsets.only(top: 70),
                            child: Text(
                              "Team Members",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xFFFFFFFF)),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(children: [
                                CircleAvatar(
                                  radius:30,
                                  backgroundImage: AssetImage(
                                      'assets/images/sampleImage1.jpg'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Tal\n (CEO)",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ])),
                              Expanded(
                                  child: Column(
                                children: [
                                  CircleAvatar(
                                    radius:30,
                                    backgroundImage: AssetImage(
                                        'assets/images/sampleImage2.jpg'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Ido\n(CTO)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: Color(0xFFFFFFFF)),
                                    ),
                                  ),
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  CircleAvatar(
                                    radius:30,
                                    backgroundImage: AssetImage(
                                        'assets/images/sampleImage3.jpg'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "John\n(COO)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: Color(0xFFFFFFFF)),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ]),
                    )))
          ],
        ),
      ),
    );
  }
}
