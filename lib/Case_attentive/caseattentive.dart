import 'package:appmap/Case_attentive/case_attentiveshowdetail.dart';
import 'package:appmap/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class caseattentive extends StatefulWidget {
  @override
  _caseattentiveState createState() => _caseattentiveState();
}

class _caseattentiveState extends State<caseattentive> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.orange[200],
        appBar: AppBar( automaticallyImplyLeading: false,
          title: Text(
            "เคสที่สนใจ",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginPage()));
                })
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Caseinterested').snapshots(),
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

                        return InkWell(onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => caseattentiveshow(
                                casename:
                                doc.data["name"],
                                casedetail:
                                doc.data["detail"],
                                caseimage: doc.data["urlimage"],
                                caselevel:
                                doc.data["level"],
                                casemap: doc.data["position"]["geopoint"],
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
                                        'images/camera.png',
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
}
