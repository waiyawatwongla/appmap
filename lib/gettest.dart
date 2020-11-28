
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class getlocation extends StatefulWidget {
  @override
  _getlocationState createState() => _getlocationState();
}

class _getlocationState extends State<getlocation> {
  TextEditingController _latitudeController, _longitudeController;
  Geoflutterfire geo;
  final _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);

  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('hello'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100,
                  child: TextField(
                    controller: _latitudeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: 'lat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _longitudeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'lng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    final lat = double.parse(_latitudeController.text);
                    final lng = double.parse(_longitudeController.text);
                    _addPoint(lat, lng);
                  },
                  child: const Text(
                    'ADD',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ));
  }
  void _addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('locations')
        .add({'name': 'random name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

}
