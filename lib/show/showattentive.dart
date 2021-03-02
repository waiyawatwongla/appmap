import 'package:appmap/Case_attentive/case_attentiveshowdetail.dart';
import 'package:appmap/Login/login.dart';
import 'package:appmap/Splash_Screen/CustomShapeClipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class shoowattentive extends StatefulWidget {
  @override
  _shoowattentive createState() => _shoowattentive();
}

class _shoowattentive extends State<shoowattentive> {
  String name = "";

  Widget _widget(String searchText) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green[900])),
      elevation: 2,
      color: Colors.white,
      child: Text(
        searchText,
        style: TextStyle(fontFamily: 'kanit'),
      ),
      onPressed: () {
        setState(() {
          name = '${searchText}';
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
        appBar: AppBar(title: Text('เคสที่สนใจ',style: TextStyle(fontFamily: 'Kanit'),)),
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
                    Text('หมวดหมู่ :',style: TextStyle(fontSize: 15,fontFamily: 'Kanit',color: Colors.black45),),
                    _widget("แม่สอด"),

                    _widget("ท่าสายลวด"),

                    _widget("มหาวัน"),

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
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        color: Colors.black45),
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
                          .where('district', isEqualTo: name)
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
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Colors.green[900])),
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
                                                  fontSize: 20,
                                                  fontFamily: 'Kanit'),
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
      ),
      // ),
    );
  }
}
