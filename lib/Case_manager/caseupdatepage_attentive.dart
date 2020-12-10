import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:appmap/Case_manager/casemanagernotify.dart';
import 'package:appmap/Case_news/casenews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'casemanagerattentive.dart';

class MyUpdatePageattentive extends StatefulWidget {
  final DocumentSnapshot ds;

  MyUpdatePageattentive({this.ds});

  @override
  _MyUpdatePageattentive createState() => _MyUpdatePageattentive();
}

class _MyUpdatePageattentive extends State<MyUpdatePageattentive> {
  //Fleld
  var locationsget;
  var selectedCurrency, selectedType;
  File file;
  String name, detail, urlimage, level;
  TextEditingController _latitudeController, _longitudeController;
  Geoflutterfire geo;
  final _firestore = Firestore.instance;
  GoogleMapController mapController;
  String inputtaddr;


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

  //Method
  List<String> _accountType = <String>[
    'ระดับความรุนแรง ปลอดภัย',
    'ระดับความรุนแรง น้อย',
    'ระดับความรุนแรง มาก',
    'ระดับความรุนแรง มากที่สุด',
  ];

  addtolist() async {
    final query = inputtaddr;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    Firestore.instance.collection('CaseNotify').add({
      'latlng':
      GeoPoint(first.coordinates.latitude, first.coordinates.longitude)
    });
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
                labelText: 'lat', fillColor: Colors.white70,
                filled: true,labelStyle: TextStyle(color: Colors.orangeAccent),
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
                labelText: 'lng', fillColor: Colors.white70,
                filled: true,labelStyle: TextStyle(color: Colors.orangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
        ),
        MaterialButton(
          color: Colors.blue,
          onPressed: () {
            // final lat = double.parse(_latitudeController.text);
            // final lng = double.parse(_longitudeController.text);
            // _addPoint(lat, lng);
            getCurrentLocation();
          },
          child: const Text(
            'หาพิกัดตำแหน่ง',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastpositon = await Geolocator.getLastKnownPosition();
    print(locationsget);
    print(inputtaddr);
    setState(() {
      locationsget = "${position.latitude},${position.longitude}";
    });
  }

  Widget getlocation() {
    return FlatButton(
      child: Text('พิกัดตำแหน่ง = ${locationsget}',style: TextStyle(color: Colors.black),),
    );
  }

  Widget Mapadd() {
    return Container(
      height: 300,
      // ignore: unnecessary_brace_in_string_interps
      width: MediaQuery.of(context).size.width,
      child: Stack(children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(16.71398776795827, 98.57380892911516), zoom: 13.0),
          onMapCreated: _onMapCreated,
        ),
        Positioned(
          bottom: 50,
          left: 10,
          child: FlatButton(
              child: Icon(Icons.pin_drop),
              color: Colors.green,
              onPressed: () {}),
        ),
      ]),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

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

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showImage(),
              SizedBox(
                width: 20,
              ),
              showImage2(),
            ],
          ),
          showButton(),
          SizedBox(
            height: 20,
          ),
          Textname(),
          SizedBox(
            height: 10,
          ),
          Textdetail(),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[SizedBox(width: 40,),
              Radiobutton(),
            ],
          ),
          Row(
            children: <Widget>[SizedBox(width: 25,),
              getlocation(),
            ],
          ),SizedBox(height: 10,),
          // Mapadd(),
          addgeopoint(),SizedBox(height: 20,),
          Buttonuploadfirbase(),
        ],
      ),
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

  Widget Textname() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: TextField(
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
              print('คลิ๊กอัปโหลด');
              if (name == null ||
                  name.isEmpty ||
                  detail == null ||
                  detail.isEmpty ||
                  selectedType == null ) {
                showAlert('ล้มเหลว', 'กรุณากรอกทุกช่อง');
              } else if (file == null || _longitudeController == null || _latitudeController == null) {
                InsertvaluetofiresStrage2();
              }
              else {
                uploadPicturetofiresStrage();
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Text(
              'Upload to Data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showAlert(String title, String message) async {
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
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (value) => casemanagerattentive());
                    Navigator.of(context)
                        .pushAndRemoveUntil(route, (value) => false);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  Future<void> InsertvaluetofiresStrage3() async {
    _firestore
        .collection('Caseinterested')
        .document(widget.ds.documentID)
        .updateData({
      'name': name,
      'detail': detail,
      'level': selectedType,
      'urlimage': urlimage,
    }).then((_) {

    });
    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }


  Future<void> InsertvaluetofiresStrage2() async {
    _firestore
        .collection('Caseinterested')
        .document(widget.ds.documentID)
        .updateData({
      'name': name,
      'detail': detail,
      'level': selectedType,
    }).then((_) {

    });
    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  Future<void> uploadPicturetofiresStrage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
    firebaseStorage.ref().child('CaseImage/case$i.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlimage = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    InsertvaluetofiresStrage(double.parse(_latitudeController.text),
        double.parse(_longitudeController.text));

    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  Future<void> InsertvaluetofiresStrage(double lat, double lng) async {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('Caseinterested')
        .document(widget.ds.documentID)
        .updateData({
      'name': name,
      'detail': detail,
      'level': selectedType,
      'urlimage': urlimage,
      'position': geoFirePoint.data
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  // Future<void> InsertvaluetofiresStrage(double lat, double lng) async {
  //   GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
  //   _firestore.collection('CaseNotify').add({
  //     'name': name,
  //     'detail': detail,
  //     'urlimage': urlimage,
  //     'level': selectedType,
  //     'position': geoFirePoint.data
  //   }).then((_) {
  //     print('added ${geoFirePoint.hash} successfully');
  //   });
  // }

  void _addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('locations').add({
      'name': name,
      'detail': detail,
      'urlimage': urlimage,
      'level': selectedType,
      'position': geoFirePoint.data
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[200],
        appBar: AppBar(
          title: Text(
            'แก้ไขเคสความรุนแรง',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: <Widget>[
                showContent(),

              ],
            )),
      ),
    );
  }
}
