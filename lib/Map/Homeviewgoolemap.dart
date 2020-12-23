import 'dart:async';

import 'package:appmap/Case_news/casenews.dart';
import 'package:appmap/Map/Mapshowdatail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Case_notify/caseadd.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      onTap: () {},
      markerId: markerId,
      position: LatLng(specify['position']['geopoint'].latitude,
          specify['position']['geopoint'].longitude),
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
                caseimage: specify['urlimage'],
                casemap: specify['position']['geopoint'],
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

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 16,
    )));
  }

  Future _goToThaSaiLuat() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(16.75057892058958, 98.49568894860992),
      ),
    );
  }

  Future _goToMaHawan() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(16.58216891247723, 98.62652162772027),
      ),
    );
  }

  Future _goToMaeSot() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(16.71398776795827, 98.57380892911516),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                _controller.complete(controller);
              },
            ),
            Positioned(
              left: 18,
              top: 18,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: _goToMaeSot,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    textColor: Colors.black,
                    child: Text("แม่สอด".toUpperCase(),
                        style: TextStyle(fontSize: 14,fontFamily: 'Kanit')),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: _goToMaHawan,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    textColor: Colors.black,
                    child: Text("มหาวัน".toUpperCase(),
                        style: TextStyle(fontSize: 14,fontFamily: 'Kanit')),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: _goToThaSaiLuat,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    textColor: Colors.black,
                    child: Text("ท่าสายลวด",
                        style: TextStyle(fontSize: 14,fontFamily: 'Kanit')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
