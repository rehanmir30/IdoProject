import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'ActivityScreen.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }
//
// class _ScanScreenState extends State<ScanScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


class ScanScreen extends StatefulWidget {
  final String userId;

  const ScanScreen(this.userId, {Key? key}) : super(key: key);

  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  final databaseReference =
  FirebaseDatabase.instance.reference().child("Activities");

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),

        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      controller.stopCamera();
      DatabaseReference
      databaseReference =
      FirebaseDatabase.instance
          .reference();
      databaseReference
          .child("Activities")
          .once()
          .then((DatabaseEvent value) {
        if (value.snapshot
            .child(result!.code.toString())
            .exists) {
          if (widget.userId ==
              value.snapshot
                  .child(result!.code.toString())
                  .child("manager")
                  .value
                  .toString()) {
            Fluttertoast.showToast(
                msg:
                "You are the manager of this activity. Can't join as user");
            return;
          } else{
            joinActivity(result!.code.toString());
            //Move to next screen from here
          }
        } else {
          Fluttertoast.showToast(
              msg:
              "No such activity found.");
          Navigator.pop(context);
          return;
        }
      });



    });

  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  joinActivity(String id) async {
    String currentTime = DateTime.now().toString();

    await databaseReference
        .child(id)
        .child("Members")
        .child(widget.userId)
        .child("Last Opened")
        .set(currentTime);
    Fluttertoast.showToast(msg: "Joined successfully");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ActivityScreen(result!.code.toString(),
                  widget.userId)),
    );
  }

}