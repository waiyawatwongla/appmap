
import 'package:appmap/Case_manager/casemanagernotify.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class update_notifylevel extends StatefulWidget {
  final DocumentSnapshot ds;

  update_notifylevel({this.ds});

  @override
  _update_notifylevel createState() => _update_notifylevel();
}

class _update_notifylevel extends State<update_notifylevel> {
  String name, detail, urlimage, level,selectedType;
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
                Radiobutton(),
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

  List<String> _accountType = <String>[
    'ระดับความรุนแรง ปลอดภัย',
    'ระดับความรุนแรง น้อย',
    'ระดับความรุนแรง มาก',
    'ระดับความรุนแรง มากที่สุด',
  ];


  Widget Radiobutton() {
    return DropdownButton(
      items: _accountType
          .map((value) => DropdownMenuItem(
        child: Text(value),
        value: value,
      ))
          .toList(),
      onChanged: (selectedAccountType) {
        print('$selectedAccountType');
        setState(() {
          selectedType = selectedAccountType;
        });
      },
      icon: Icon(Icons.clear_all,color: Colors.black,),
      value: selectedType,
      isExpanded: false,
      hint: Text(
        'เลือกระดับความรุนแรง',
        style: TextStyle(
          color: Colors.black,
        ),
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
      'level': selectedType,
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
