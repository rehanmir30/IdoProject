import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gumshoe/Screens/ForgotPasswordScreen.dart';
import 'package:gumshoe/Screens/HomeScreen.dart';
import 'package:gumshoe/Screens/SignUpScreen.dart';
import 'package:gumshoe/Screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../External Widgets/Loading.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  var Email, Password;
  var longi, lati;
  bool viewVisible = false;
  bool emailError = false;
  bool passwordError = false;
  bool isSwitch=false;
  var loading = false;
  String errorMessage = "";

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isObscurePassword = true;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String emailHintMessageEng="Email";
  String passwordHintMessageEng="Password";
  String forgotPasswordMessageEng="Forgot Password?";
  String LoginText="Login";
  String SwitchLanguage="Switch Language";
  String Or="Or";
  String ContinueWith="Continue with";
  String newHere="New Here?";
  String becomeMember="Become a member now!";
  String emailErrorMessage="Email Required";
  String passwordErrorMessage="Password Required";
String Language="English";

  @override
  void initState() {
    requestMultiplePermissions();
    getPosition();
    checkSharedPrefs();
  }

  checkSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final int? counter = prefs.getInt('counter');
    final String? Lang = prefs.getString('Language');
    if(Lang=="English"){
      setState(() {
        isSwitch=false;
      });
    }else{
      setState(() {
        isSwitch=false;
      });
    }
    if (counter != 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    } else {
      await prefs.setInt('counter', 1);
      return;
    }
  }

  getPosition() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    longi = position.longitude;
    lati = position.latitude;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png"),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        validator: (email) {
                          if (email!.isEmpty || email == null) {
                            setState(() {
                              errorMessage = emailErrorMessage;
                              emailError = true;
                            });
                            return " ";
                          } else if (!emailValid.hasMatch(email)) {
                            setState(() {
                              errorMessage = "Email formate not correct";
                              emailError = true;
                            });
                            return " ";
                          } else {
                            setState(() {
                              emailError = false;
                            });
                            Email = email;
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: emailHintMessageEng,
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Visibility(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              emailErrorMessage,
                              style: TextStyle(color: Colors.red),
                            )),
                        visible: emailError,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: TextFormField(
                        validator: (password) {
                          if (password!.isEmpty || password == null) {
                            setState(() {
                              passwordError = true;
                            });
                            return " ";
                          } else {
                            setState(() {
                              passwordError = false;
                            });
                            Password = password;
                            return null;
                          }
                        },
                        obscureText: _isObscurePassword,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(_isObscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscurePassword = !_isObscurePassword;
                              });
                            },
                          ),
                          hintText: passwordHintMessageEng,
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Visibility(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              passwordErrorMessage,
                              style: TextStyle(color: Colors.red),
                            )),
                        visible: passwordError,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: Text(
                            forgotPasswordMessageEng,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: Row(
                        children: [
                          RaisedButton(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              color: Color(0xFF002d56),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                              onPressed: () {
                                if (formkey.currentState != null &&
                                    formkey.currentState!.validate()) {
                                  SignInFunc(Email, Password);
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LoginText,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(SwitchLanguage),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          width: 20,
                          height: 20,
                          child: Image.asset("assets/images/uk.png"),
                        )),
                        Expanded(child: Container(
                          child:Switch(
                           value: isSwitch,
                            onChanged: (val)async{
                             setState(() {
                               isSwitch=val;
                             });
                             if(val==true){

                               setState(() {
                                 emailHintMessageEng="אימייל";
                                 passwordHintMessageEng="סיסמה";
                                 forgotPasswordMessageEng="שכחת את הסיסמ?";
                                 LoginText="התחברות";
                                 SwitchLanguage="החלף שפה";
                                 Or="אוֹ";
                                 ContinueWith="להמשיך עם";
                                 newHere="חדש פה?";
                                 becomeMember="הפוך לחבר עכשיו!";
                                 emailErrorMessage="מייל(דרוש";
                                 passwordErrorMessage="סיסמה נדרשת";
                               });
                               final prefs = await SharedPreferences.getInstance();
                               await prefs.setString('Language', 'Israel');
                             }else{
                               final prefs = await SharedPreferences.getInstance();
                               await prefs.setString('Language', 'English');
                               emailHintMessageEng="Email";
                               passwordHintMessageEng="Password";
                               forgotPasswordMessageEng="Forgot Password?";
                               LoginText="LOG IN";
                               SwitchLanguage="Switch Language";
                               Or="Or";
                               ContinueWith="Continue with";
                               newHere="New Here?";
                               becomeMember="Become a member now!";
                               emailErrorMessage="Email Required";
                               passwordErrorMessage="Password Required";
                             }
                            },
                          )
                          ,
                        )),
                        Expanded(
                            child: Container(
                          width: 20,
                          height: 20,
                          child: Image.asset("assets/images/israel.png"),
                        )),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(Or,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      ContinueWith,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            child: IconButton(
                              onPressed: () {
                                LoginWithGoogle();
                              },
                              icon: Image.asset("assets/images/googleicon.png"),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            child: IconButton(
                              onPressed: () {
                                // fbLogin();
                              },
                              icon:
                                  Image.asset("assets/images/facebookicon.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          newHere,
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          child: Text(
                            becomeMember,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
                child: Visibility(
              visible: viewVisible,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child:
                    Align(alignment: Alignment.center, child: LoadingWidget()),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future LoginWithGoogle() async {
    showWidget();
    await Firebase.initializeApp();
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    FirebaseAuth _auth = await FirebaseAuth.instance;
    String currentTime = DateTime.now().toString();
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      var authResult = await _auth.signInWithCredential(credential);
      // print(authResult.user!.uid);
      await getPosition();

      final databaseReference =
          await FirebaseDatabase.instance.reference().child("Users");
      await databaseReference.once().then((value) {
        databaseReference
            .child(authResult.user!.uid)
            .child("Email")
            .set(authResult.user!.email);
        databaseReference
            .child(authResult.user!.uid)
            .child("Phone")
            .set(authResult.user!.phoneNumber);
        databaseReference
            .child(authResult.user!.uid)
            .child("Name")
            .set(authResult.user!.displayName);
        databaseReference
            .child(authResult.user!.uid)
            .child("Created at")
            .set(currentTime);
        databaseReference
            .child(authResult.user!.uid)
            .child("Longitude")
            .set(longi);
        databaseReference
            .child(authResult.user!.uid)
            .child("Latitude")
            .set(lati);
        hideWidget();
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomeScreen(
                authResult.user!.uid, authResult.user!.displayName ?? ""),
          ),
          (route) => false,
        );
      });
    } catch (e) {
      hideWidget();
      print('Error signing in $e');
    }
  }

  Future SignInFunc(email, password) async {
    await Firebase.initializeApp();
    showWidget();
    FirebaseAuth _auth = await FirebaseAuth.instance;
    final databaseReference =
        await FirebaseDatabase.instance.reference().child("Users");
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      getPosition();
      await databaseReference.once().then((value) {
        if (value.snapshot.hasChild(user!.uid)) {
          String name =
              value.snapshot.child(user!.uid).child("Name").value.toString();

          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => HomeScreen(user!.uid, name),
            ),
            (route) => false,
          );
        }
      });
      databaseReference.child(user!.uid).child("Longitude").set(longi);
      databaseReference.child(user!.uid).child("Latitude").set(lati);
      hideWidget();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        hideWidget();
        Fluttertoast.showToast(
            msg: "No user found for this email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        hideWidget();
        Fluttertoast.showToast(
            msg: "Wrong password provided for this user.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
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

void requestMultiplePermissions() async {
  var status = await Permission.location.status;
  if (status.isGranted) {
    print("Granted: ");
  } else if (status.isDenied) {
    if (await Permission.location.request().isGranted) {
      print("Grants");
    }
  }
}
