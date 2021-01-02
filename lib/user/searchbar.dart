import 'package:appmap/Case_attentive/case_attentiveshowdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  TextEditingController _addname;
  String searchString;

  @override
  void initState() {
    super.initState();
    _addname = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //         child: TextField(
          //       controller: _addname,
          //     )),
          //     RaisedButton(
          //       onPressed: () {
          //         adddata(_addname.text);
          //       },
          //       child: Text('adddata'),
          //     )
          //   ],
          // ),
          Expanded(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    side: BorderSide(color: Colors.green[900])),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'ค้นหา...'),
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchString == null || searchString.trim() == " ")
                      ? Firestore.instance
                          .collection('Caseinterested')
                          .snapshots()
                      : Firestore.instance
                          .collection('Caseinterested')
                          .where('searchindex', arrayContains: searchString)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('error  ${snapshot.hasError}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        return ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => caseattentiveshow(
                                      casename: document["name"],
                                      casedetail: document["detail"],
                                      caseimage: document["urlimage"],
                                      caselevel: document["level"],
                                      casemap: document["position"]["geopoint"],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      document['name'],
                                      style: TextStyle(fontFamily: 'Kanit'),
                                    ),
                                    Divider()
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  void adddata(String name) {
    List<String> split = name.split(" ");
    List<String> indexlist = [];

    for (int i = 0; i < split.length; i++) {
      for (int y = 1; y < split[i].length + 1; y++) {
        indexlist.add(split[i].substring(0, y).toLowerCase());
      }
    }
    print(indexlist);

    Firestore.instance
        .collection('item')
        .document()
        .setData(({'name': name, 'searchindex': indexlist}));
  }

  void initiateSearch(String val) {
    setState(() {
      searchString = val.toLowerCase().trim();
    });
  }
}
