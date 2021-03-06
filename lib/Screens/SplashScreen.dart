import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gumshoe/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset("assets/images/logo.png"),
        splashIconSize: 500,
        nextScreen: LoginScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white);

  }

  @override
  void initState() {

  }
}
