import 'package:appmap/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent[200],
          title: Text(
            "ข่าวใหม่",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                })
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection("CaseNotify").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text("Loading . . . "),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemPage(
                                  casename: snapshot
                                      .data.documents[index].data["name"],
                                  casedetail: snapshot
                                      .data.documents[index].data["detail"],
                                  caseimage: snapshot
                                      .data.documents[index].data["urlimage"],
                                  caselevel: snapshot
                                      .data.documents[index].data["level"],
                                  casemap: snapshot.data.documents[index]
                                      .data["position"]["geopoint"],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                    '${snapshot.data.documents[index].data['name']}'),
                                subtitle: Text(
                                    '${snapshot.data.documents[index].data["level"]}'),
                                leading: Image.network(
                                  '${snapshot.data.documents[index].data['urlimage']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
