import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/Former/screens/LoginFormer.dart';
import 'package:formagil_app_admin/screens/Former/screens/ManageCourse.dart';
import 'package:formagil_app_admin/screens/HomeScreen.dart';
import 'package:formagil_app_admin/screens/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'ManageFormer.dart';


class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<User> _listener;

  @override
  void initState() {

    super.initState();
    Timer(
      Duration(seconds: 2),() {
      _listener = FirebaseAuth.instance
          .authStateChanges()
          .listen((User user) {
        if (user == null) {
          if(user?.email != 'ala122@gmail.com'){
            Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(LoginFormer.id, (Route<dynamic> route) => false);
          }
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) =>
          //     LoginScreen())
          // );
        } else {
          if(user?.email != 'ala122@gmail.com'){
            Navigator.of(context).pushNamedAndRemoveUntil(ManageCourse.id, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(FormerScreen.id, (Route<dynamic> route) => false);
          }
            // Navigator.pushReplacement(context,
            //   MaterialPageRoute(builder: (context) {
            //        return FormerScreen();
            //   })
            // );
         }
      }
      );
    });
  }
  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
