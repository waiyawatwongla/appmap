

import 'package:appmap/Case_manager/casemanagernotify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class update_notifydetail extends StatefulWidget {
  final DocumentSnapshot ds;

  update_notifydetail({this.ds});

  @override
  _update_notifydetail createState() => _update_notifydetail();
}

class _update_notifydetail extends State<update_notifydetail> {
  String name, detail, urlimage, level;
  final _firestore = Firestore.instance;

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
                Textdetail(),
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

  Widget Textdetail() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: TextField(
        maxLines: 5,
        onChanged: (value) {
          detail = value.trim();
        },
        decoration: InputDecoration(
            icon: Icon(
              Icons.dvr,
              color: Colors.black,
            ),
            labelText: 'สาเหตุ',
            hintText: '${widget.ds.data['detail']}',
            fillColor: Colors.white70,
            filled: true,
            labelStyle: TextStyle(color: Colors.orangeAccent)),
      ),
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
              InsertvaluetofiresStrage3();
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

  Future<void> InsertvaluetofiresStrage3() async {
    _firestore
        .collection('CaseNotify')
        .document(widget.ds.documentID)
        .updateData({
      'detail': detail,
    }).then((_) {});
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
                    MaterialPageRoute(builder: (value) => casemanagernotify());
                    Navigator.of(context)
                        .pushAndRemoveUntil(route, (value) => false);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
