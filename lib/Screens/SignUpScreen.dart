import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gumshoe/External%20Widgets/Loading.dart';
import 'package:gumshoe/Screens/HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var Email, Password, Name, C_Password, longi, lati, Phone;
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController c_password = TextEditingController();
  TextEditingController phone_number = TextEditingController();
  bool viewVisible = false;
  bool _isObscurePassword = true;
  bool _isObscureConPassword = true;

  bool nameError = false;
  bool emailError = false;
  bool passwordError = false;
  bool confirmpasswordError = false;
  bool phonenumberError = false;

  String errorMessageName = "";
  String errorMessageEmail = "";
  String errorMessagePassword = "";
  String errorMessageConfirmPassword = "";
  String errorMessagePhoneNumber = "";

  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    getPosition();
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
          Container(
              child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 400,
                    height: 200,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
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
                          Name = name;
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Name',
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
                            errorMessageName,
                            style: TextStyle(color: Colors.red),
                          )),
                      visible: nameError,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (email) {
                        if (email!.isEmpty || email == null) {
                          setState(() {
                            errorMessageEmail = "Email Required";
                            emailError = true;
                          });
                          return "";
                        } else if (!emailValid.hasMatch(email)) {
                          setState(() {
                            errorMessageEmail = "Email format not correct";
                            emailError = true;
                          });
                          return "";
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
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Visibility(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            errorMessageEmail,
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
                          Password = password;
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
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                        ),
                        hintText: 'Password',
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
                            errorMessagePassword,
                            style: TextStyle(color: Colors.red),
                          )),
                      visible: passwordError,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: TextFormField(
                      validator: (confirm_password) {
                        if (confirm_password!.isEmpty ||
                            confirm_password == null) {
                          setState(() {
                            errorMessageConfirmPassword =
                                "Confirm Password Required";
                            confirmpasswordError = true;
                          });
                          return "";
                        } else if (confirm_password.length < 6) {
                          setState(() {
                            errorMessageConfirmPassword =
                                "Password should be greater then 6 characters";
                            confirmpasswordError = true;
                          });
                          return "";
                        }else if (confirm_password!=Password) {
                          setState(() {
                            errorMessageConfirmPassword =
                            "Passwords don't match";
                            confirmpasswordError = true;
                          });
                          return "";
                        } else {
                          setState(() {
                            confirmpasswordError = false;
                          });
                          C_Password = confirm_password;
                          return null;
                        }
                      },
                      obscureText: _isObscureConPassword,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(_isObscureConPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscureConPassword = !_isObscureConPassword;
                            });
                          },
                        ),
                        hintText: 'Confirm Password',
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
                            errorMessageConfirmPassword,
                            style: TextStyle(color: Colors.red),
                          )),
                      visible: confirmpasswordError,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: TextFormField(
                      validator: (phone_number) {
                        if (phone_number!.isEmpty || phone_number == null) {
                          setState(() {
                            errorMessagePhoneNumber = "Phone Required";
                            phonenumberError = true;
                          });
                          return "";
                        } else {
                          setState(() {
                            phonenumberError = false;
                          });
                          Phone = phone_number;
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
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
                            errorMessagePhoneNumber,
                            style: TextStyle(color: Colors.red),
                          )),
                      visible: phonenumberError,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(170.0, 90.0),
                              minimumSize: const Size(170.0, 60.0),
                              primary: Color(0xFF002d56),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              if (formkey.currentState != null &&
                                  formkey.currentState!.validate()) {
                                SignUpFunc(Name, Email, Password, Phone);
                              } else
                                return;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('REGISTER'),
                                Icon(
                                  Icons.content_paste_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    height: 2,
                    decoration: BoxDecoration(color: Colors.black26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login now!',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          Positioned.fill(
              child: Visibility(
            visible: viewVisible,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Align(alignment: Alignment.center, child: LoadingWidget()),
            ),
          )),
        ],
      ),
    ));
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

  Future<void> SignUpFunc(
      String name, String email, String password, String phone) async {
    showWidget();
    String errorMessage = "";
    await Firebase.initializeApp();
    String currentTime = DateTime.now().toString();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      getPosition();
      final databaseReference =
          FirebaseDatabase.instance.reference().child("Users");
      var userid = userCredential.user!.uid;
      await databaseReference.child(userid).child("Name").set(name);
      await databaseReference.child(userid).child("Email").set(email);
      await databaseReference.child(userid).child("Phone").set(phone);
      await databaseReference
          .child(userid)
          .child("Created at")
          .set(currentTime);
      await databaseReference.child(userid).child("Longitude").set(longi);
      await databaseReference.child(userid).child("Latitude").set(lati);
      hideWidget();
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HomeScreen(userid, name),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          hideWidget();
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_WRONG_PASSWORD":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Password doesn't match requirements",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_USER_DISABLED":
          hideWidget();
          Fluttertoast.showToast(
              msg:
                  "Provided email has been disabled. Contact support for more.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Too many requests. Try again later",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Error operation not allowed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "email-already-in-use":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Email already in use",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        default:
          print(error);
          errorMessage = "An undefined Error happened.";
          hideWidget();
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
      }
    }
  }
}
