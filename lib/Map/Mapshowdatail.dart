import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Mapshowdatail extends StatefulWidget {
  final String namecase;
  var location;
  final String t3;

  Mapshowdatail({Key key, @required this.namecase, @required this.location, @required this.t3})
      : super(key: key);

  @override
  _Mapshowdatail createState() => _Mapshowdatail();
}

class _Mapshowdatail extends State<Mapshowdatail> {
  String t1 = "Please wait...";
  double t22;

  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("markers").document().get().then((value) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.namecase}',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
