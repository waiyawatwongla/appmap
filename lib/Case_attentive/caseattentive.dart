import 'package:appmap/Case_attentive/case_attentiveshowdetail.dart';
import 'package:appmap/Login/login.dart';
import 'package:appmap/Splash_Screen/CustomShapeClipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class caseattentive extends StatefulWidget {
  @override
  _caseattentiveState createState() => _caseattentiveState();
}

class _caseattentiveState extends State<caseattentive> {
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
          name = 'ระดับความรุนแรง ${searchText}';
        });
      },
    );
  }

  double _height;
  double _width;

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green[900],
                    Colors.green,
                  ],
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
    return SafeArea(
      child: Scaffold(
        body: Card(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.white.withOpacity(0.7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _widget("ปลอดภัย"),
                    _widget("น้อย"),
                    _widget("มาก"),
                    _widget("มากที่สุด"),
                  ],
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
                    style: TextStyle(fontSize: 15,fontFamily: 'Kanit',color: Colors.black45),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 3),
                  child: Text(
                    "เคสที่สนใจ",
                    style: TextStyle(fontSize: 22, fontFamily: 'Kanit'),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (name != "" && name != null)
                      ? Firestore.instance
                          .collection('Caseinterested')
                          .where('level', isEqualTo: name)
                          .snapshots()
                      : Firestore.instance
                          .collection("Caseinterested")
                          .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data = snapshot.data.documents[index];
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
                                        builder: (context) => caseattentiveshow(
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
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green[900])),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
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
                          );
                  },
                ),
              )
            ],
          ),
        ),
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.green[900],
        //   title: Text(
        //     "เคสที่สนใจ",
        //     style: TextStyle(color: Colors.white,fontFamily: 'Kanit'),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //         icon: Icon(Icons.home),
        //         color: Colors.white,
        //         onPressed: () {
        //           // Navigator.push(context,
        //           //     MaterialPageRoute(builder: (context) => LoginPage()));
        //         })
        //   ],
        // ),
        // body: Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment.topRight,
        //           end: Alignment.bottomLeft,
        //           colors: [Colors.teal[900], Colors.green[800]])),
        //   child: ListView(
        //     padding: EdgeInsets.all(15),
        //     children: <Widget>[
        //       Text(
        //         'เคสที่สนใจ',
        //         style: TextStyle(
        //             fontFamily: 'Kanit', color: Colors.white, fontSize: 20),
        //       ),
        //       SizedBox(
        //         height: 5,
        //       ),
        //       Row(
        //         children: <Widget>[
        //           _widget("ปลอภัย"),
        //           _widget("น้อย"),
        //           _widget("มาก"),
        //           _widget("มากที่สุด")
        //         ],
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 15, top: 3),
        //         child: Text(
        //           "Seach for: $name",
        //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 5,
        //       ),
        // StreamBuilder<QuerySnapshot>(
        //     stream: Firestore.instance
        //         .collection('Caseinterested')
        //         .snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return Column(
        //           children: snapshot.data.documents.map((doc) {
        //             testdata() {
        //               if (doc.data['level'] ==
        //                   'ระดับความรุนแรง ปลอดภัย') {
        //                 return Row(
        //                   children: <Widget>[
        //                     Text(
        //                       '${doc.data['level']}',
        //                       style: TextStyle(
        //                         color: Colors.green,
        //                         fontFamily: 'Kanit',
        //                         fontSize: 12,
        //                       ),
        //                       maxLines: 1,
        //                       textAlign: TextAlign.left,
        //                     ),
        //                     Icon(
        //                       (Icons.mood),
        //                       color: Colors.green,
        //                     )
        //                   ],
        //                 );
        //               } else if (doc.data['level'] ==
        //                   'ระดับความรุนแรง น้อย') {
        //                 return Row(
        //                   children: <Widget>[
        //                     Text(
        //                       '${doc.data['level']}',
        //                       style: TextStyle(
        //                         color: Colors.yellow,
        //                         fontFamily: 'Kanit',
        //                         fontSize: 12,
        //                       ),
        //                       maxLines: 1,
        //                       textAlign: TextAlign.left,
        //                     ),
        //                     Icon(
        //                       (Icons.sentiment_neutral),
        //                       color: Colors.yellow,
        //                     )
        //                   ],
        //                 );
        //               } else if (doc.data['level'] ==
        //                   'ระดับความรุนแรง มาก') {
        //                 return Row(
        //                   children: <Widget>[
        //                     Text(
        //                       '${doc.data['level']}',
        //                       style: TextStyle(
        //                           color: Colors.orange,
        //                           fontFamily: 'Kanit',
        //                           fontSize: 12),
        //                       maxLines: 1,
        //                       textAlign: TextAlign.left,
        //                     ),
        //                     Icon(
        //                       (Icons.sentiment_dissatisfied),
        //                       color: Colors.orange,
        //                     )
        //                   ],
        //                 );
        //               } else if (doc.data['level'] ==
        //                   'ระดับความรุนแรง มากที่สุด') {
        //                 return Row(
        //                   children: <Widget>[
        //                     Text(
        //                       '${doc.data['level']}',
        //                       style: TextStyle(
        //                         color: Colors.red,
        //                         fontFamily: 'Kanit',
        //                         fontSize: 12,
        //                       ),
        //                       maxLines: 1,
        //                       textAlign: TextAlign.left,
        //                     ),
        //                     Icon(
        //                       (Icons.mood_bad),
        //                       color: Colors.red,
        //                     )
        //                   ],
        //                 );
        //               }
        //             }
        //
        //             return InkWell(
        //               onTap: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => caseattentiveshow(
        //                       casename: doc.data["name"],
        //                       casedetail: doc.data["detail"],
        //                       caseimage: doc.data["urlimage"],
        //                       caselevel: doc.data["level"],
        //                       casemap: doc.data["position"]["geopoint"],
        //                     ),
        //                   ),
        //                 );
        //               },
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     horizontal: 5.0, vertical: 0.0),
        //                 child: Card(
        //                   color: Colors.white,
        //                   child: Container(
        //                     decoration: BoxDecoration(
        //                       border: Border.all(color: Colors.grey),
        //                       borderRadius: BorderRadius.circular(5.0),
        //                     ),
        //                     child: Row(
        //                       children: <Widget>[
        //                         ClipRRect(
        //                           borderRadius: BorderRadius.circular(5),
        //                           child: doc.data['urlimage'] == null
        //                               ? Image.asset(
        //                                   'images/camera.png',
        //                                   height: 70.0,
        //                                   width: 70.0,
        //                                   fit: BoxFit.cover,
        //                                 )
        //                               : Image.network(
        //                                   '${doc.data['urlimage']}',
        //                                   height: 70.0,
        //                                   width: 70.0,
        //                                   fit: BoxFit.cover,
        //                                 ),
        //                         ),
        //                         SizedBox(
        //                           width: 20,
        //                         ),
        //                         Container(
        //                           width: 180,
        //                           child: Column(
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             children: <Widget>[
        //                               Text(
        //                                 '${doc.data['name']}',
        //                                 style: TextStyle(
        //                                   fontFamily: 'Kanit',
        //                                   fontSize: 15.0,
        //                                 ),
        //                               ),
        //                               testdata(),
        //                             ],
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             );
        //           }).toList(),
        //         );
        //       } else {
        //         return SizedBox();
        //       }
        //     //     }),
        //   ],
        // ),
      ),
      // ),
    );
  }
}
