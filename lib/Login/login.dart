import 'package:appmap/Map/Navigationbar.dart';
import 'package:appmap/Splash_Screen/CustomShapeClipper.dart';
import 'package:appmap/user/hompageuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  void initState() {
    super.initState();
  }

  signIn() {
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((user) {
      print("signed in ${user.email}");
      Check(user); // add here
    }).catchError((error) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('รหัสผิด กรุณากรอกใหม่',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  // Future checkAuth(BuildContext context) async {
  //   FirebaseUser user = await _auth.currentUser();
  //   if (user != null) {
  //     print("Already singed-in with");
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => Navigationbar(user)));
  //     // context, MaterialPageRoute(builder: (context) => MapSample(user)));
  //   }
  // }

  Check(FirebaseUser user) async {
    FirebaseUser user = await _auth.currentUser();
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((value) {
      if (value.data['role'] == 'admin') {
        print('admin');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Navigationbar(user)));
      } else if (value.data['role'] == 'user') {
        print('user');
        Navigator.push(context, MaterialPageRoute(builder: (context) => homepageuser(user)));
      }
    });
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                   Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  double _height;
  double _width;

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: signIn,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.deepOrange,
                  Colors.orangeAccent,
                ])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Image.asset(
          'images/logo.png',
          width: 150,
          height: 100,
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 18,
              fontWeight: FontWeight.w400),
        ),
        TextField(
          controller: emailController,
        ),
        SizedBox(
          height: 30,
        ),
        Text('Password',
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 18,
                fontWeight: FontWeight.w400)),
        TextField(controller: passwordController,obscureText: true,),
      ],
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
              height: _height / 1.2,
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              clipShape(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// String _email, _password;
//
// @override
// void initState() {
//   super.initState();
// }
// @override
// Widget build(BuildContext context) {
//   return  SafeArea(
//     child: Scaffold(
//       appBar: AppBar(),
//       body: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 validator: (input) {
//                   if(input.isEmpty){
//                     return 'Provide an email';
//                   }
//                 },
//                 decoration: InputDecoration(
//                     labelText: 'Email'
//                 ),
//                 onSaved: (input) => _email = input,
//               ),
//               TextFormField(
//                 validator: (input) {
//                   if(input.length < 6){
//                     return 'Longer password please';
//                   }
//                 },
//                 decoration: InputDecoration(
//                     labelText: 'Password'
//                 ),
//                 onSaved: (input) => _password = input,
//                 obscureText: true,
//               ),
//               RaisedButton(
//                 onPressed: signIn,
//                 child: Text('Sign in'),
//               ),
//             ],
//           )
//       ),
//     ),
//   );
// }
//
// void signIn() async {
//   if(_formKey.currentState.validate()){
//     _formKey.currentState.save();
//     try{
//       FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => hometest( user)));
//       setState(() {
//         Check(user);
//       });
//     }catch(e){
//       print(e.message);
//     }
//   }
// }
//
// Check(FirebaseUser user)async{
//   Firestore.instance
//       .collection('users')
//       .document(user.uid)
//       .get()
//       .then((value) {
//     if (value.data['role'] == 'admin') {
//       print('admin');
//       Navigator.push(context, MaterialPageRoute(builder: (context) => Navigationbar(user)));
//     } else if (value.data['role'] == 'user') {
//       print('user');
//       Navigator.push(context, MaterialPageRoute(builder: (context) => te2()));
//     }
//   });
// }
}
