import 'package:appmap/Case_manager/casemanagernotify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'casemanagerattentive.dart';

class casemanager extends StatefulWidget {
  @override
  _casemanagerState createState() => _casemanagerState();
}

class _casemanagerState extends State<casemanager> {
  int test1;
  int test2;

  @override
  void initState() {
    get();
    get2();
    test1;
    test2;
    super.initState();
  }

  Widget casenotifytext() {
    return StreamBuilder(
        stream: Firestore.instance.collection("CaseNotify").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text("Loading . . . "),
                ],
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => casemanagernotify()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/warning.png',
                      width: 42,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'จำนวนเคสที่แจ้ง',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${snapshot.data.documents.length}',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  get() async {
    Firestore.instance.collection('CaseNotify').getDocuments().then((value) {
      return test2 = value.documents.length;
    });
  }

  get2() async {
    Firestore.instance
        .collection('Caseinterested')
        .getDocuments()
        .then((value) {
      return test1 = value.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.print),
                onPressed: () {
                  // getnotifydata();
                })
          ],
        ),
        backgroundColor: Colors.orange[200],
        body: StreamBuilder(
          stream: Firestore.instance.collection("Caseinterested").snapshots(),
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
              return GridView.count(
                primary: false,
                padding: EdgeInsets.all(30),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                children: <Widget>[
                  casenotifytext(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => casemanagerattentive()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/heart.png',
                            width: 42,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'จำนวนเคสที่สนใจ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${snapshot.data.documents.length}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/magnifying-glass.png',
                            width: 42,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'ค้นหาเคส',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Text(
                          //   '${test1 + test2}',
                          //   style: GoogleFonts.openSans(
                          //       textStyle: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600)),
                          // )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/man.png',
                            width: 42,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'โปรไฟล์',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Text(
                          //   '${test1 + test2}',
                          //   style: GoogleFonts.openSans(
                          //       textStyle: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600)),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
