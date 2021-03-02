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
            title: Text(
              'แจ้งเตือน?',
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            content: Text(
              'คุณต้องการออกจากแอปพลิเคชัน?',
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(fontFamily: 'Kanit'),
                ),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(fontFamily: 'Kanit'),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  String name = "";

  Widget _widget(String searchText) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green[900])),
      elevation: 2,
      color: Colors.white,
      child: Text(searchText,style: TextStyle(fontFamily: 'kanit'),),
      onPressed: () {
        setState(() {
          name = '${searchText}';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          drawer: _drawer(),
          appBar: AppBar(title: Text('การแจ้งความรุนแรงทั้งหมด',style:TextStyle(fontFamily: 'Kanit',)),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.green[900],
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.teal[900], Colors.green[800]])),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('หมวดหมู่ :',style: TextStyle(fontSize: 15,fontFamily: 'Kanit',color: Colors.white),),
                        _widget("แม่สอด"),

                        _widget("ท่าสายลวด"),

                        _widget("มหาวัน"),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "ค้นหา : $name",
                            style: TextStyle(fontSize: 15,fontFamily: 'Kanit',color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "เคสที่แจ้งทั้งหมด",
                            style: TextStyle(fontSize: 22, fontFamily: 'Kanit',color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: (name != "" && name != null)
                            ? Firestore.instance
                            .collection('CaseNotify')
                            .where('district', isEqualTo: name)
                            .snapshots()
                            : Firestore.instance
                            .collection("CaseNotify")
                            .snapshots(),
                        builder: (context, snapshot) {
                          return (snapshot.connectionState == ConnectionState.waiting)
                              ? Center(child: CircularProgressIndicator())
                              : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(alignment: Alignment.topCenter,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data = snapshot.data.documents[snapshot.data.documents.length - 1 -index];
                                  testdata() {
                                    if (data['level'] ==
                                        'ระดับความรุนแรง ปลอดภัย') {
                                      return Row(
                                        children: <Widget>[
                                          Text(
                                            '${data['level']}',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontFamily: 'Kanit',
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
                                    } else if (data['level'] ==
                                        'ระดับความรุนแรง น้อย') {
                                      return Row(
                                        children: <Widget>[
                                          Text(
                                            '${data['level']}',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontFamily: 'Kanit',
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
                                    } else if (data['level'] ==
                                        'ระดับความรุนแรง มาก') {
                                      return Row(
                                        children: <Widget>[
                                          Text(
                                            '${data['level']}',
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontFamily: 'Kanit',
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
                                    } else if (data['level'] ==
                                        'ระดับความรุนแรง มากที่สุด') {
                                      return Row(
                                        children: <Widget>[
                                          Text(
                                            '${data['level']}',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Kanit',
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
                                            casename: data["name"],
                                            casedetail: data["detail"],
                                            caseimage: data["urlimage"],
                                            caselevel: data["level"],
                                            casemap: data["position"]["geopoint"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(color: Colors.green[900])),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                              child: data['urlimage'] == null
                                                  ? Image.asset(
                                                'images/photo.png',
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              )
                                                  : Image.network(
                                                data['urlimage'],
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                data['name'],
                                                style: TextStyle(
                                                    fontSize: 20,fontFamily: 'Kanit'
                                                ),
                                              ),
                                              testdata()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/logo4.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                      // height: MediaQuery.of(context).size.height * 0.3,
                      height: 160,
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
          // ListTile(
          //   leading: Icon(
          //     Icons.add,
          //     color: Colors.orange,
          //   ),
          //   title: Text(
          //     "test",
          //     style: TextStyle(fontFamily: 'Kanit'),
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => testlazyload()));
          //   },
          // ),
          // Divider(),
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
                    context,
                    MaterialPageRoute(
                        builder: (context) => profileuser(widget.user)));
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
