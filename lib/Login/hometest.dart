// import 'package:appmap/Login/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'logintest.dart';
//
// class MyHomePage extends StatefulWidget {
//   final FirebaseUser user;
//
//   MyHomePage(this.user, {Key key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   initState() {
//     super.initState();
//   }
//
//   void signOut(BuildContext context) {
//     _auth.signOut();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//         ModalRoute.withName('/'));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("My Firebase App", style: TextStyle(color: Colors.white)),  actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.exit_to_app),
//               color: Colors.white,
//               onPressed: () {
//                 signOut(context);
//               })
//         ],
//         ),
//         body: Container(
//             child: Center(
//                 child:
//                 Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
//                   Text("Hello", style: TextStyle(fontSize: 26)),
//                   Text(widget.user.email, style: TextStyle(fontSize: 16)),
//                 ]))));
//   }
// }
//
