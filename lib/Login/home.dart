// import 'package:appmap/Login/te1.dart';
// import 'package:appmap/Login/te2.dart';
// import 'package:appmap/Map/Navigationbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class hometest extends StatefulWidget {
//   final FirebaseUser users;
//
//   hometest(this.users, {Key key}) : super(key: key);
//
//   @override
//   _hometestState createState() => _hometestState();
// }
//
// class _hometestState extends State<hometest> {
//   @override
//   void initState() {
//     // _drawer();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Home ${widget.users.email}'),actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: (){
//           // _drawer();
//         })],
//         ),
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: Firestore.instance
//               .collection('users')
//               .document(widget.users.uid)
//               .snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (snapshot.hasData) {
//               return checkRole(snapshot.data);
//             }
//             return LinearProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
//
//   checkRole(DocumentSnapshot snapshot) {
//     if (snapshot.data == null) {
//       return Center(
//         child: Text('no data set in the userId document in firestore'),
//       );
//     }
//     if (snapshot.data['role'] == 'admin') {
//       return Text('${snapshot.data['name']}  ${snapshot.data['role']}');
//     } else {
//       return Text('${snapshot.data['name']}  ${snapshot.data['role']}');
//     }
//   }
//
//   // _drawer() async {
//   //   Firestore.instance
//   //       .collection('users')
//   //       .document(widget.users.uid)
//   //       .get()
//   //       .then((value) {
//   //       if (value.data['role'] == 'admin') {
//   //         print('admin');
//   //         Navigator.push(context, MaterialPageRoute(builder: (context) => te1()));
//   //       } else if (value.data['role'] == 'user') {
//   //         print('user');
//   //         Navigator.push(context, MaterialPageRoute(builder: (context) => te2()));
//   //       }
//   //   });
//   // }
// }
