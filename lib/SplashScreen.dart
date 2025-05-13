import 'package:edu_ott_indimuse/Api.dart';
import 'package:edu_ott_indimuse/BottomTabBar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    try {
      var data = await Api().fetchSettingsAndMovies();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomTabBar()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
          ),
          Center(
            child: SizedBox(
              child: Image.asset(
                "assets/lottie/logoanimation.gif",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
