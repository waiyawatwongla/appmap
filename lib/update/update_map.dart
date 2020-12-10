import 'package:appmap/Case_manager/casemanagerattentive.dart';
import 'package:appmap/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class update_map extends StatefulWidget {
  final DocumentSnapshot ds;

  update_map({this.ds});

  @override
  _update_map createState() => _update_map();
}

class _update_map extends State<update_map> {
  String name, detail, urlimage, level;
  final _firestore = Firestore.instance;
  Geoflutterfire geo;
  TextEditingController _latitudeController, _longitudeController;

  @override
  void initState() {
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    geo = Geoflutterfire();
    super.initState();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: <Widget>[
                addgeopoint(),
                SizedBox(
                  height: 20,
                ),
                Buttonuploadfirbase(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addgeopoint() {
    return Row(
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
                fillColor: Colors.white70,
                filled: true,
                labelStyle: TextStyle(color: Colors.orangeAccent),
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
                fillColor: Colors.white70,
                filled: true,
                labelStyle: TextStyle(color: Colors.orangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
        ),
      ],
    );
  }

  Widget Buttonuploadfirbase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: Colors.orange,
            onPressed: () {
              InsertvaluetofiresStrage(double.parse(_latitudeController.text),
                  double.parse(_longitudeController.text));
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Text(
              'Update to Data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> InsertvaluetofiresStrage(double lat, double lng) async {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('Caseinterested')
        .document(widget.ds.documentID)
        .updateData({'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  Future<void> showAlertSucusses(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    MaterialPageRoute route =
                        MaterialPageRoute(builder: (value) => casemanagerattentive());
                    Navigator.of(context)
                        .pushAndRemoveUntil(route, (value) => false);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
