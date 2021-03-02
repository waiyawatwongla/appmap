
import 'package:appmap/Case_news/caseshow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class shownews extends StatefulWidget {
  @override
  _shownews createState() => _shownews();
}

class _shownews extends State<shownews> {
  @override
  void initState() {
    super.initState();
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
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(appBar: AppBar(title: Text('ข่าวเคสใหม่',style: TextStyle(fontFamily: 'Kanit'),),),
        body: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('หมวดหมู่ :',style: TextStyle(fontSize: 15,fontFamily: 'Kanit',color: Colors.black45),),
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
                          style: TextStyle(fontSize: 15,fontFamily: 'Kanit',color: Colors.black45),
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
                          style: TextStyle(fontSize: 22, fontFamily: 'Kanit',color: Colors.black),
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
                                        builder: (context) => ItemPage(
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
