import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profileuser extends StatefulWidget {
  final FirebaseUser user;

  profileuser(this.user);

  @override
  _profileuser createState() => _profileuser();
}

class _profileuser extends State<profileuser> {
  File file;
  String urlimage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'โปรไฟล์',
            style: TextStyle(fontFamily: 'Kanit'),
          ),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(widget.user.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.hasError}');
            } else if (snapshot.hasData) {
              return profileView(snapshot.data);
              // return Center(
              //   child: Column(
              //     children: <Widget>[
              //
              // SizedBox(
              //   height: 50,
              // ),
              // Card(
              //   elevation: 5,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   // child: Container(
              //   //   width: MediaQuery.of(context).size.width / 1.3,
              //   //   decoration: BoxDecoration(
              //   //     gradient: LinearGradient(
              //   //       colors: [
              //   //         Colors.green[900],
              //   //         Colors.green,
              //   //       ],
              //   //     ),
              //   //   ),
              //   //   height: 100,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Text(
              //           'email = ${widget.user.email}',
              //           style: TextStyle(fontFamily: 'Kanit'),
              //         ),
              //         Text('name = ${snapshot.data['name']}',
              //             style: TextStyle(fontFamily: 'Kanit')),
              //         Text('call = ${snapshot.data['call']}',
              //             style: TextStyle(fontFamily: 'Kanit')),
              //         Text('สถานะ = ${snapshot.data['role']}',
              //             style: TextStyle(fontFamily: 'Kanit')),
              //       ],
              //     ),
              //   ),
              //   // ),
              // ),
              //     ],
              //   ),
              // );
            }
            return LinearProgressIndicator();
          },
        ),
      ),
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
  Future<void> uploadPicturetofiresStrage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
    firebaseStorage.ref().child('userimage/userimage$i.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlimage = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    InsertvaluetofiresStrage2();

    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  Future<void> InsertvaluetofiresStrage2() async {
    Firestore.instance.collection('users').document(widget.user.uid).updateData({
      'userimage': urlimage,
    }).then((_) {
    });
    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  Future<void> showAlertSucusses(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,style: TextStyle(fontFamily: 'Kanit',)),
            content: Text(message,style: TextStyle(fontFamily: 'Kanit',)),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(fontFamily: 'Kanit',)))
            ],
          );
        });
  }

  Widget profileView(DocumentSnapshot snapshot) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: file == null
                      ? Image.network(
                    '${snapshot.data['userimage']}',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    file,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      icon: Icon(Icons.add_photo_alternate),
                      onPressed: () {
                        chooseImage(ImageSource.gallery);
                      },
                    ),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ))
            ],
          ),
        ),
        Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.teal[900],
                        Colors.green[400],
                      ])),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 4),
                    child: Container(
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'ชื่อ: ${snapshot.data['name']}',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Kanit'),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                    child: Container(
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'อีเมล์: ${widget.user.email}',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Kanit'),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.fromLTRB(20, 5, 20, 4),
                    child: Container(
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'สภานะ: ${snapshot.data['role']}',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Kanit'),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                    child: Container(
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'เบอร์โทร: ${snapshot.data['call']}',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Kanit'),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(onTap: (){
                        uploadPicturetofiresStrage();
                      },
                        child: Container(
                          height: 70,
                          width: 100,
                          child: Align(
                            child: Text(
                              'บันทึกรูป',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontFamily: 'Kanit'),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

}
