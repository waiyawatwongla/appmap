
import 'package:appmap/Login/login.dart';
import 'package:appmap/user/addcase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: _drawer(),
        appBar: AppBar( automaticallyImplyLeading: true,
          backgroundColor: Colors.white10,
        ),
        backgroundColor: Colors.orangeAccent,
        body: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('CaseNotify').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map((doc) {
                        testdata() {
                          if (doc.data['level'] == 'ระดับความรุนแรง ปลอดภัย') {
                            return Row(
                              children: <Widget>[
                                Text(
                                  '${doc.data['level']}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
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
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
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
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
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
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orangeAccent,
                          Colors.orangeAccent,
                          Colors.orange
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ]),
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.orangeAccent,
            ),
            title: Text("แจ้งความรุนแรง"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => addcase(user: widget.user)));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.orangeAccent,
              ),
              title: Text("โปรไฟล์"),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
              }),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.orangeAccent,
            ),
            title: Text("ออกจากระบบ"),
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
