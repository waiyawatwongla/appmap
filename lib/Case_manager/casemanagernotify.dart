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

  String name = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "จัดการเคสที่แจ้งข่าว",
            style: TextStyle(
              fontFamily: 'Kanit',
            ),
          ),
          actions: <Widget>[
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    side: BorderSide(color: Colors.green[900])),
                child:
                TextField(
                  decoration: InputDecoration( border: InputBorder.none,
                      prefixIcon: Icon(Icons.search), hintText: 'ค้นหาชื่อเคสที่แจ้งข่าว'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 3),
                  child: Text(
                    "ค้นหา : $name",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        color: Colors.black45),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: (name != "" && name != null )
                        ? Firestore.instance
                        .collection('CaseNotify')
                        .where('name', isEqualTo: name)
                        .snapshots()
                        : Firestore.instance
                        .collection('CaseNotify')
                    // .where('name', isGreaterThanOrEqualTo: names)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState == ConnectionState.waiting)
                          ? Center(child: CircularProgressIndicator())
                          : GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //two columns
                            mainAxisSpacing: 0.1, //space the card
                            childAspectRatio:
                            0.800, //space largo de cada card
                          ),
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (_, int index) {
                            DocumentSnapshot doc = snapshot.data.documents[snapshot.data.documents.length - 1 -index];
                            testdata() {
                              if (doc.data['level'] ==
                                  'ระดับความรุนแรง ปลอดภัย') {
                                return Row(
                                  children: <Widget>[
                                    Text(
                                      '${doc.data['level']}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: 'Kanit',
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
                            return Container(
                              child: Card(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            child: doc.data['urlimage'] ==
                                                null
                                                ? Image.asset(
                                                'images/photo.png',
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width)
                                                : Image.network(
                                              '${doc.data['urlimage']}',
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width,
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
                                          style: TextStyle(
                                            fontFamily: 'Kanit',
                                            color: Colors.blueAccent,
                                            fontSize: 19.0,
                                          ),
                                        ),
                                        subtitle: testdata(),
                                      ),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                      .collection(
                                                      "CaseNotify")
                                                      .document(
                                                      doc.documentID)
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
                                                onPressed: () =>
                                                    navigateToDetail2(doc),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
