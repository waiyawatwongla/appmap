
import 'file:///D:/Flutter/appmap/lib/Splash_Screen/splash_screen.dart';
import 'package:appmap/Login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Splash_Screen/Splash_AnimatedScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green[900]),
      routes: <String, WidgetBuilder>{
        MAIN_UI: (BuildContext context) => LoginPage(),
        SPLASH_SCREEN: (BuildContext context) => AnimatedSplashScreen(),
      },
      initialRoute: SPLASH_SCREEN,
    );
  }
}

