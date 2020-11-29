import 'package:appmap/Case_news/casenews.dart';
import 'package:appmap/Map/Mapshowdatail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Case_notify/caseadd.dart';
import '../gettest.dart';

class MapsPage extends StatefulWidget {
  // final FirebaseUser user;
  //
  // MapsPage(this.user, {Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      onTap: () {},
      markerId: markerId,
      position:
          LatLng(specify['position'].latitude, specify['position'].longitude),
      infoWindow: InfoWindow(
        title: specify['name'],
        snippet: specify['level'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Mapshowdatail(
                casename: specify['name'],
                caselevel: specify['level'],
                casedetail: specify['detail'],
                caseimage:specify['urlimage'],
                casemap: specify['position'],
              ),
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
    Firestore.instance
        .collection('Caseinterested')
        .getDocuments()
        .then((myMockDoc) {
      if (myMockDoc.documents.isNotEmpty) {
        for (int i = 0; i < myMockDoc.documents.length; i++) {
          initMarker(
              myMockDoc.documents[i].data, myMockDoc.documents[i].documentID);
        }
      }
    });
  }

  // void signOut(BuildContext context) {
  //   _auth.signOut();
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //       ModalRoute.withName('/'));
  // }

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
            style: TextStyle(color: Colors.white),
          ),
        ),
        // drawer: _drawer(),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(16.71398776795827, 98.57380892911516),
                  zoom: 12.0),
              onMapCreated: (GoogleMapController controller) {
                controller = controller;
              },
            ),
          ],
        ),
      ),
    );
  }
}
