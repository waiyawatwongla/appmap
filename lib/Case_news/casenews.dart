
import 'package:appmap/Splash_Screen/CustomShapeClipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'caseshow.dart';

class casenews extends StatefulWidget {
  @override
  _casenewsState createState() => _casenewsState();
}

class _casenewsState extends State<casenews> {
  @override
  void initState() {
    super.initState();
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.green[900],
        //   title: Text(
        //     "ข่าวใหม่",
        //     style: TextStyle(color: Colors.white, fontFamily: 'Kanit'),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //         icon: Icon(Icons.home),
        //         color: Colors.white,
        //         onPressed: () {
        //           // Navigator.push(context,
        //           //     MaterialPageRoute(builder: (context) => MapsPage()));
        //         })
        //   ],
        // ),
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       colors: [Colors.teal[900], Colors.green[800]]),
          // ),
          child: Stack(
            children: <Widget>[
              clipShape(),
              ListView(
                padding: EdgeInsets.all(15),
                children: <Widget>[
                  Text(
                    'เคสการแจ้งทั้งหมด',
                    style: TextStyle(
                        fontFamily: 'Kanit', color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('CaseNotify')
                          .snapshots(),
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
                                } else if (doc.data['level'] ==
                                    'ระดับความรุนแรง น้อย') {
                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        '${doc.data['level']}',
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
                                } else if (doc.data['level'] ==
                                    'ระดับความรุนแรง มาก') {
                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        '${doc.data['level']}',
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
                                } else if (doc.data['level'] ==
                                    'ระดับความรุนแรง มากที่สุด') {
                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        '${doc.data['level']}',
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
                                      builder: (context) => ItemPage(
                                        casename: doc.data["name"],
                                        casedetail: doc.data["detail"],
                                        caseimage: doc.data["urlimage"],
                                        caselevel: doc.data["level"],
                                        casearea: doc.data['district'],
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                                    fontFamily: 'Kanit',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget searchbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: TextField(
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.blueGrey[300],
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: "E.g: New York, United States",
          prefixIcon: Icon(
            Icons.location_on,
            color: Colors.blueGrey[300],
          ),
          hintStyle: TextStyle(
            fontSize: 15.0,
            color: Colors.blueGrey[300],
          ),
        ),
        maxLines: 1,
      ),
    );
  }
// Widget newscase(){
//   return Container(
//     height: 250.0,
//     width: 140.0,
//     child: Column(
//       children: <Widget>[
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Image.network(
//             "${snapshot.data.documents[index].data['urlimage']}",
//             height: 178.0,
//             width: 140.0,
//             fit: BoxFit.cover,
//           ),
//         ),
//         SizedBox(height: 7.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "${snapshot.data.documents[index].data['name']}",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 15.0,
//             ),
//             maxLines: 2,
//             textAlign: TextAlign.left,
//           ),
//         ),
//         SizedBox(height: 3.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "${snapshot.data.documents[index].data['level']}",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 13.0,
//               color: Colors.blueGrey[300],
//             ),
//             maxLines: 1,
//             textAlign: TextAlign.left,
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
