// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'hometest.dart';
//
// class MyLoginPage extends StatefulWidget {
//   MyLoginPage({Key key}) : super(key: key);
//
//   @override
//   _MyLoginPageState createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     checkAuth(context);
//   }
//
//   signIn() {
//     _auth
//         .signInWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim())
//         .then((user) {
//       print("signed in ${user.email}");
//       checkAuth(context); // add here
//     }).catchError((error) {
//       scaffoldKey.currentState.showSnackBar(SnackBar(
//         content: Text('รหัสผิดไอ่สาดดดด', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.red,
//       ));
//     });
//   }
//
//   Future checkAuth(BuildContext context) async {
//     FirebaseUser user = await _auth.currentUser();
//     if (user != null) {
//       print("Already singed-in with");
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => MyHomePage(user)));
//     }
//   }
//
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: scaffoldKey,
//         appBar: AppBar(
//           title: Text("My Firebase App", style: TextStyle(color: Colors.white)),
//         ),
//         body: Container(
//             color: Colors.green[50],
//             child: Center(
//               child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       gradient: LinearGradient(
//                           colors: [Colors.yellow[100], Colors.green[100]])),
//                   margin: EdgeInsets.all(32),
//                   padding: EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       buildTextFieldEmail(),
//                       buildTextFieldPassword(),
//                       InkWell(
//                           onTap: () {
//                             signIn();
//                           },
//                           child: buildButtonSignIn()),
//                     ],
//                   )),
//             )));
//   }
//
//   Container buildButtonSignIn() {
//     return Container(
//         constraints: BoxConstraints.expand(height: 50),
//         child: Text("Sign in",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18, color: Colors.white)),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16), color: Colors.green[200]),
//         margin: EdgeInsets.only(top: 16),
//         padding: EdgeInsets.all(12));
//   }
//
//   Container buildTextFieldEmail() {
//     return Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//             color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
//         child: TextField(
//             controller: emailController,
//             decoration: InputDecoration.collapsed(hintText: "Email"),
//             style: TextStyle(fontSize: 18)));
//   }
//
//   Container buildTextFieldPassword() {
//     return Container(
//         padding: EdgeInsets.all(12),
//         margin: EdgeInsets.only(top: 12),
//         decoration: BoxDecoration(
//             color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
//         child: TextField(
//             controller: passwordController,
//             obscureText: true,
//             decoration: InputDecoration.collapsed(hintText: "Password"),
//             style: TextStyle(fontSize: 18)));
//   }
// }
