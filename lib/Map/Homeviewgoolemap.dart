import 'package:appmap/Case_news/casenews.dart';
import 'package:appmap/Login/login.dart';
import 'package:appmap/Map/Mapshowdatail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Case_notify/caseadd.dart';
import '../gettest.dart';
import '../test.dart';

class MapsPage extends StatefulWidget {
  final FirebaseUser user;

  MapsPage(this.user, {Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleMapController controller;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};





  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      onTap: () {},
      markerId: markerId,
      position: LatLng(specify['position'].latitude,specify['position'].longitude),
      infoWindow: InfoWindow(
        title: specify['name'],
        snippet: specify['level'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Mapshowdatail(
                  namecase: specify['name'],
                  location: specify['position']),
            ),
          );
        },
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    Firestore.instance.collection('CaseNotify').getDocuments().then((myMockDoc) {
      if (myMockDoc.documents.isNotEmpty) {
        for (int i = 0; i < myMockDoc.documents.length; i++) {
          initMarker(
              myMockDoc.documents[i].data, myMockDoc.documents[i].documentID);
        }
      }
    });
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/'));
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[300],
            title: Text(
              'แผนที่แสดงเคสเฝ้าระวังความรุนแรง',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                  })
            ],
          ),
          drawer: _drawer(),
          body: GoogleMap(
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(16.71398776795827, 98.57380892911516),
                  zoom: 12.0),
              onMapCreated: (GoogleMapController controller) {
                controller = controller;
              })),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orangeAccent,
                          Colors.orangeAccent,
                          Colors.orange
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ]),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.orangeAccent,
            ),
            title: Text("จัดการเคส"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.orangeAccent,
            ),
            title: Text("เคสที่สนใจ"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => getlocation()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.new_releases,
              color: Colors.orangeAccent,
            ),
            title: Text("ข่าวใหม่เคส"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => casenews()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.orangeAccent,
            ),
            title: Text("แจ้งความรุนแรง"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => casadd()));
            },
          ),
          ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.orangeAccent,
              ),
              title: Text("โปรไฟล์"),
              onTap: () {}),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.orangeAccent,
            ),
            title: Text("ออกจากระบบ"),
            onTap: () {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
