import 'dart:io';
import 'dart:math';

import 'package:appmap/Case_manager/casemanagerattentive.dart';
import 'package:appmap/Case_manager/casemanagernotify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class update_notifyimage extends StatefulWidget {
  final DocumentSnapshot ds;

  update_notifyimage({this.ds});

  @override
  _update_notifyimage createState() => _update_notifyimage();
}

class _update_notifyimage extends State<update_notifyimage> {
  String name, detail, urlimage, level;
  final _firestore = Firestore.instance;
  File file;

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
                Row(children: <Widget>[
                  showImage(),
                  SizedBox(
                    width: 20,
                  ),
                  showImage2(),
                ]),showButton(),
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

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        camaraButton(),
        SizedBox(
          width: 10,
        ),
        galleryButton(),
      ],
    );
  }

  Widget camaraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 45,
        color: Colors.grey,
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
      },
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      // ignore: deprecated_member_use
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 45,
        color: Colors.grey,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget showImage() {
    return Container(
        color: Colors.cyan,
        width: 165,
        height: 150,
        child: file == null
            ? Image.network(
          '${widget.ds.data['urlimage']}',
          fit: BoxFit.cover,
        )
            : Image.network(
          '${widget.ds.data['urlimage']}',
          fit: BoxFit.cover,
        ));
  }

  Widget showImage2() {
    return Container(
      color: Colors.cyan,
      width: 165,
      height: 150,
      child: file == null
          ? Image.asset(
        'images/photo.png',
        fit: BoxFit.cover,
      )
          : Image.file(
        file,
        fit: BoxFit.cover,
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
              uploadPicturetofiresStrage();
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

  Future<void> uploadPicturetofiresStrage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
    firebaseStorage.ref().child('CaseImage/case$i.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlimage = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    InsertvaluetofiresStrage3();


  }


  Future<void> InsertvaluetofiresStrage3() async {
    _firestore
        .collection('CaseNotify')
        .document(widget.ds.documentID)
        .updateData({
      'urlimage': urlimage,
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
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
