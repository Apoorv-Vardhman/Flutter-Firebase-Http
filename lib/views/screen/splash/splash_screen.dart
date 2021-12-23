import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_angela/app/app.dart';
import 'package:mvvm_angela/app/app_routes.dart';
import 'package:mvvm_angela/data/app_preferences.dart';
import 'package:mvvm_angela/views/resource/app_styles.dart';

class Splash extends StatefulWidget {
    @override
    _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    AppPreferences.getLoggedIn()? AppRoutes.navigateToHome(context)
        : AppRoutes.navigateToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Text(
                "Splash Screen",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2,
              )
            ],
          ),
      )
    );
  }
}
