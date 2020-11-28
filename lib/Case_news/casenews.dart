import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("ข่าวใหม่"),
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
