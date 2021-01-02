import 'dart:io';

import 'package:appmap/Login/login.dart';
import 'package:appmap/user/addcase.dart';
import 'package:appmap/user/profileuser.dart';
import 'package:appmap/user/searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detailcase.dart';

class homepageuser extends StatefulWidget {
  final FirebaseUser user;

  homepageuser(this.user, {Key key}) : super(key: key);

  @override
  _homepageuserState createState() => _homepageuserState();
}

class _homepageuserState extends State<homepageuser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('แจ้งเตือน?',style: TextStyle(fontFamily: 'Kanit'),),
        content: Text('คุณต้องการออกจากแอปพลิเคชัน?',style: TextStyle(fontFamily: 'Kanit'),),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('ยกเลิก',style: TextStyle(fontFamily: 'Kanit'),),
          ),
          FlatButton(
            onPressed: () => exit(0),
            /*Navigator.of(context).pop(true)*/
            child: Text('ยืนยัน',style: TextStyle(fontFamily: 'Kanit'),),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          drawer: _drawer(),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.green[900],
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.teal[900], Colors.green[800]])),
            child: ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CloudFirestoreSearch()));
                    },
                      child: Text(
                        'เคสการแจ้งทั้งหมด',
                        style: TextStyle(
                            fontFamily: 'Kanit', color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('CaseNotify').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.documents.map((doc) {
                            testdata() {
                              if (doc.data['level'] ==
                                  'ระดับความรุนแรง ปลอดภัย') {
                                return Row(
                                  children: <Widget>[
                                    Text(
                                      '${doc.data['level']}',
                                      style: TextStyle(
                                        color: Colors.green,fontFamily: 'Kanit',
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    Icon(
                                      (Icons.mood),
                                      color: Colors.green,
                                    )
                                  ],
                                );
                              } else if (doc.data['level'] ==
                                  'ระดับความรุนแรง น้อย') {
                                return Row(
                                  children: <Widget>[
                                    Text(
                                      '${doc.data['level']}',
                                      style: TextStyle(
                                        color: Colors.yellow,fontFamily: 'Kanit',
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    Icon(
                                      (Icons.sentiment_neutral),
                                      color: Colors.yellow,
                                    )
                                  ],
                                );
                              } else if (doc.data['level'] ==
                                  'ระดับความรุนแรง มาก') {
                                return Row(
                                  children: <Widget>[
                                    Text(
                                      '${doc.data['level']}',
                                      style: TextStyle(
                                          color: Colors.orange,fontFamily: 'Kanit',
                                          fontSize: 12),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    Icon(
                                      (Icons.sentiment_dissatisfied),
                                      color: Colors.orange,
                                    )
                                  ],
                                );
                              } else if (doc.data['level'] ==
                                  'ระดับความรุนแรง มากที่สุด') {
                                return Row(
                                  children: <Widget>[
                                    Text(
                                      '${doc.data['level']}',
                                      style: TextStyle(
                                        color: Colors.red,fontFamily: 'Kanit',
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    Icon(
                                      (Icons.mood_bad),
                                      color: Colors.red,
                                    )
                                  ],
                                );
                              }
                            }

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => detailcase(
                                      casename: doc.data["name"],
                                      casedetail: doc.data["detail"],
                                      caseimage: doc.data["urlimage"],
                                      caselevel: doc.data["level"],
                                      caseby: doc.data['notifyby'],
                                      casearea : doc.data['district'],
                                      date: doc.data['date'],
                                      casemap: doc.data["position"]['geopoint'],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 0.0),
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: doc.data['urlimage'] == null
                                              ? Image.asset(
                                                  'images/photo.png',
                                                  height: 70.0,
                                                  width: 70.0,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  '${doc.data['urlimage']}',
                                                  height: 70.0,
                                                  width: 70.0,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${doc.data['name']}',
                                                style: TextStyle(fontFamily: 'Kanit',
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              testdata(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ],
            ),
          ),        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => addcase(user: widget.user)));
          },
        ),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 1,
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green[900],
                          Colors.green,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/logo2.png',
                      width: MediaQuery.of(context).size.width * 0.3,
                      // height: MediaQuery.of(context).size.height * 0.3,
                      height: 150,
                    ),
                    Text(
                      'เข้าสู่ระบบโดย :',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit'),
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit'),
                    ),

                  ],
                ),
              )
            ]),
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.orange,
            ),
            title: Text(
              "แจ้งความรุนแรง",
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => addcase(user: widget.user)));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.teal,
              ),
              title: Text(
                "โปรไฟล์",
                style: TextStyle(fontFamily: 'Kanit'),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => profileuser(widget.user)));
              }),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              "ออกจากระบบ",
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            onTap: () {
              signOut(context);
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/'));
  }
}
