import 'package:appmap/Case_manager/casemanagerattentive.dart';
import 'package:appmap/Case_manager/casemanagernotify.dart';
import 'package:appmap/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class update_notifyname extends StatefulWidget {
  final DocumentSnapshot ds;

  update_notifyname({this.ds});

  @override
  _update_notifyname createState() => _update_notifyname();
}

class _update_notifyname extends State<update_notifyname> {
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
                Textname(),
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

  Widget Textname() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: TextField(
        maxLength: 20,
        onChanged: (String string) {
          name = string.trim();
        },
        decoration: InputDecoration(
            icon: Icon(
              Icons.account_box,
              color: Colors.black,
            ),
            labelText: 'ชื่อเคส',
            hintText: '${widget.ds.data['name']}',
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
      'name': name,
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
