import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:appmap/Case_news/casenews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class addcase extends StatefulWidget {
  final FirebaseUser user;

  addcase({this.user});

  @override
  _addcase createState() => _addcase();
}

class _addcase extends State<addcase> {
  //Fleld
  var locationsget;
  var selectedCurrency, selectedType,tumbon;
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


  List<String> _tumbon = <String>[
    'แม่สอด',
    'ท่าสายลวด',
    'มหาวัน',
  ];


  Widget Radiobutton_tumbon() {
    return DropdownButton(
      items: _tumbon
          .map((value) => DropdownMenuItem(
        child: Text(value,style: TextStyle(fontFamily: 'Kanit'),),
        value: value,
      ))
          .toList(),
      onChanged: (selectedtubonType) {
        print('$selectedtubonType');
        setState(() {
          tumbon = selectedtubonType;
        });
      },
      value: tumbon,
      isExpanded: false,
      hint: Text(
        'เลือกเขตพื้นที่',
        style: TextStyle(color: Colors.white,fontFamily: 'Kanit'),
      ),
    );
  }

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
                labelText: 'ละติจูด',
                fillColor: Colors.white70,
                filled: true,
                labelStyle: TextStyle(color: Colors.teal,fontFamily: 'Kanit',),
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
                labelText: 'ลองจิจูด',
                fillColor: Colors.white70,
                filled: true,
                labelStyle: TextStyle(color: Colors.teal, fontFamily: 'Kanit',),
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
            style: TextStyle(color: Colors.white, fontFamily: 'Kanit',),
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
      child: Text(
        'พิกัดตำแหน่ง = ${locationsget}',
        style: TextStyle(color: Colors.white,fontFamily: 'Kanit',),
      ),
    );
  }

  Widget Mapadd() {
    return Container(
      height: 300,
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
      value: selectedType,
      isExpanded: false,
      hint: Text(
        'เลือกระดับความรุนแรง',
        style: TextStyle(color: Colors.white, fontFamily: 'Kanit',),
      ),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showImage(),
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
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              Radiobutton(),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              Radiobutton_tumbon(),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 25,
              ),
              getlocation(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Mapadd(),
          addgeopoint(),
          SizedBox(
            height: 10,
          ),
          Buttonuploadfirbase(),
        ],
      ),
    );
  }

  Widget showImage() {
    return Container(
      color: Colors.cyan,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
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
        color: Colors.white,
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
        color: Colors.white,
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
              color: Colors.white,
            ),
            labelText: 'ชื่อเคส',
            fillColor: Colors.white70,
            filled: true,
            labelStyle: TextStyle(color: Colors.teal, fontFamily: 'Kanit',)),
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
              color: Colors.white,
            ),
            labelText: 'สาเหตุ',
            fillColor: Colors.white70,
            filled: true,
            labelStyle: TextStyle(color: Colors.teal, fontFamily: 'Kanit',)),
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
              if (file == null) {
                InsertvaluetofiresStrage2(
                    double.parse(_latitudeController.text),
                    double.parse(_longitudeController.text));
              } else if (name == null ||
                  name.isEmpty ||
                  detail == null ||
                  detail.isEmpty ||
                  selectedType == null ||
                  _longitudeController == null ||
                  _latitudeController == null) {
                showAlert('ล้มเหลว', 'กรุณากรอกทุกช่อง');
              } else {
                //upload to firesbase
                uploadPicturetofiresStrage();
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Text(
              'Upload to Data',
              style: TextStyle(color: Colors.white, fontFamily: 'Kanit',),
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
            title: Text(title,style: TextStyle(fontFamily: 'Kanit',),),
            content: Text(message,style: TextStyle(fontFamily: 'Kanit',),),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(fontFamily: 'Kanit',),))
            ],
          );
        });
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

  Future<void> InsertvaluetofiresStrage2(double lat, double lng) async {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('CaseNotify').add({
      'name': name,
      'detail': detail,
      'urlimage': urlimage,
      'level': selectedType,
      'position': geoFirePoint.data,
      'notifyby': widget.user.email,
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
    showAlertSucusses('การอัปโหลด', 'สำเร็จ');
  }

  Future<void> InsertvaluetofiresStrage(double lat, double lng) async {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('CaseNotify').add({
      'name': name,
      'detail': detail,
      'urlimage': urlimage,
      'level': selectedType,
      'position': geoFirePoint.data,
      'district': tumbon,
      'notifyby': widget.user.email,
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  void _addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    String geoFirePoint2 = '${geoFirePoint.toString()}';
    _firestore.collection('locations').add({
      'name': name,
      'detail': detail,
      'urlimage': urlimage,
      'level': selectedType,
      'district': tumbon,
      'position': geoFirePoint.data
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'เพิ่มเคสความรุนแรง',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.teal[900], Colors.green[800]])),
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
