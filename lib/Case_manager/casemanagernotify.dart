import 'package:appmap/Case_attentive/case_attentiveshowdetail.dart';
import 'package:appmap/Case_manager/caseupdatepage.dart';
import 'package:appmap/Case_news/caseshow.dart';
import 'package:appmap/Login/login.dart';
import 'package:appmap/updata_notify/update_notify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class casemanagernotify extends StatefulWidget {
  @override
  _casemanagernotify createState() => _casemanagernotify();
}

class _casemanagernotify extends State<casemanagernotify> {
  final db = Firestore.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyUpdatePage(
                  ds: ds,
                )));
  }

  navigateToDetail2(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => update_notify(
              ds: ds,
            )));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("จัดการแจ้งข่าว"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: Container(  decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal[900], Colors.green[800]])),
        child: StreamBuilder(
            stream: Firestore.instance.collection("CaseNotify").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text('"Loading...');
              }
              int length = snapshot.data.documents.length;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //two columns
                    mainAxisSpacing: 0.1, //space the card
                    childAspectRatio: 0.800, //space largo de cada card
                  ),
                  itemCount: length,
                  padding: EdgeInsets.all(2.0),
                  itemBuilder: (_, int index) {
                    final DocumentSnapshot doc = snapshot.data.documents[index];
                    testdata() {
                      if (doc.data['level'] == 'ระดับความรุนแรง ปลอดภัย') {
                        return Row(
                          children: <Widget>[
                            Text(
                              '${doc.data['level']}',
                              style: TextStyle(
                                color: Colors.green,fontFamily: 'Kanit',
                                fontSize: 10,
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
                                fontFamily: 'Kanit',
                                fontSize: 10,
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
                                  fontFamily: 'Kanit',
                                  fontSize: 10),
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
                                fontFamily: 'Kanit',
                                fontSize: 10,
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

                    return new Container(
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: (){},
                                  child: Container(
                                    child: doc.data['urlimage'] == null
                                        ? Image.asset('images/photo.png',
                                            fit: BoxFit.cover,
                                            width:
                                                MediaQuery.of(context).size.width)
                                        : Image.network(
                                            '${doc.data['urlimage']}',
                                            fit: BoxFit.cover,
                                            width:
                                                MediaQuery.of(context).size.width,
                                          ),
                                    width: 185,
                                    height: 120,
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  doc.data["name"],
                                  style: TextStyle(fontFamily: 'Kanit',
                                    color: Colors.blueAccent,
                                    fontSize: 19.0,
                                  ),
                                ),
                                subtitle: testdata(),
                              ),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  child: new Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          Firestore.instance
                                              .collection("CaseNotify")
                                              .document(doc.documentID)
                                              .delete()
                                              .catchError((e) {
                                            print(e);
                                          });
                                        }, //funciona
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => navigateToDetail2(doc),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    ));
  }
}
