import 'dart:async';

import 'file:///D:/Flutter/appmap/lib/Splash_Screen/splash_screen.dart';
import 'package:appmap/Splash_Screen/CustomShapeClipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(MAIN_UI);
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  double _height;
  double _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            clipShape(),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //  // Padding(padding: EdgeInsets.only(bottom: 30.0),child: Image.asset('images/logo.png',height: 25.0,fit: BoxFit.scaleDown,))
            //   ],
            // ),SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  width: animation.value * 200,
                  height: animation.value * 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 1.45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.orange, Colors.orangeAccent],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
