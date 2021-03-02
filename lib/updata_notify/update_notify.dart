import 'package:appmap/updata_notify/update_notifydetail.dart';
import 'package:appmap/updata_notify/update_notifyimage.dart';
import 'package:appmap/updata_notify/update_notifylevel.dart';
import 'package:appmap/updata_notify/update_notifymap.dart';
import 'package:appmap/updata_notify/update_notifyname.dart';
import 'package:appmap/update/update_detail.dart';
import 'package:appmap/update/update_image.dart';
import 'package:appmap/update/update_level.dart';
import 'package:appmap/update/update_map.dart';
import 'package:appmap/update/update_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class update_notify extends StatefulWidget {
  final DocumentSnapshot ds;

  update_notify({this.ds});

  @override
  _update_notify createState() => _update_notify();
}

class _update_notify extends State<update_notify> {
  String casedetail = "Please wait...detail";
  String caseimage = "Please wait.....";
  String caselevel = "Please wait.....";

  Set<Marker> mymarkers() {
    return <Marker>[localmarker()].toSet();
  }

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("CaseNotify")
        .document()
        .get()
        .then((value) {
    });
  }

  navigateToDetail2(DocumentSnapshot ds) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => update_notifydetail(
              ds: ds,
            )));
  }

  navigateToDetail3(DocumentSnapshot ds) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => update_notifyname(
              ds: ds,
            )));
  }

  navigateToDetail4(DocumentSnapshot ds) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => update_notifylevel(ds: ds,),
      ),
    );
  }

  navigateToDetail5(DocumentSnapshot ds) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => update_notifyimage(
              ds: ds,
            )));
  }

  navigateToDetail6(DocumentSnapshot ds) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => update_notifymap(
              ds: ds,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.ds.data['name'],
            style: TextStyle(fontSize: 18,fontFamily: 'Kanit'),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            buildSlider(),
            SizedBox(height: 20),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.ds.data['name'],
                            style: TextStyle(fontFamily: 'Kanit',
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                            onPressed: () => navigateToDetail3(widget.ds),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     Icon(
                //       Icons.call,
                //       size: 14,
                //       color: Colors.green,
                //     ),
                //     SizedBox(width: 3),
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       child: Text(
                //         '081234975319',
                //         style: TextStyle(fontFamily: 'Kanit',
                //           fontWeight: FontWeight.bold,
                //           fontSize: 13,
                //           color: Colors.blueGrey[300],
                //         ),
                //         maxLines: 1,
                //         textAlign: TextAlign.left,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      textlevel(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                        onPressed: () => navigateToDetail4(widget.ds),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "รายละเอียด",
                        style: TextStyle(fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                        onPressed: () => navigateToDetail2(widget.ds),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.ds.data['detail'],
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'ที่ตั้งแผนที่',
                        style: TextStyle(fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                        onPressed: () => navigateToDetail6(widget.ds),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 200,
                  width: 320,
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                widget.ds.data['position']['geopoint'].latitude,
                                widget
                                    .ds.data['position']['geopoint'].longitude),
                            zoom: 15.0,
                          ),
                          markers: mymarkers(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.green,
        //   child: Icon(
        //     Icons.call,
        //   ),
        //   onPressed: () {},
        // ),
      ),
    );
  }

  Widget textlevel() {
    if (widget.ds.data['level'] == 'ระดับความรุนแรง ปลอดภัย') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.ds.data['level']}',
            style: TextStyle(
              color: Colors.green,fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
          Icon(
            (Icons.mood),
            color: Colors.green,
          )
        ],
      );
    } else if (widget.ds.data['level'] == 'ระดับความรุนแรง น้อย') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.ds.data['level']}',
            style: TextStyle(
              color: Colors.yellow,fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
          Icon(
            (Icons.sentiment_neutral),
            color: Colors.yellow,
          )
        ],
      );
    } else if (widget.ds.data['level'] == 'ระดับความรุนแรง มาก') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.ds.data['level']}',
            style: TextStyle(
              color: Colors.orange,fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
          Icon(
            (Icons.sentiment_dissatisfied),
            color: Colors.orange,
          )
        ],
      );
    } else if (widget.ds.data['level'] == 'ระดับความรุนแรง มากที่สุด') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.ds.data['level']}',
            style: TextStyle(
              color: Colors.red,fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
          Icon(
            (Icons.mood_bad),
            color: Colors.red,
          )
        ],
      );
    }
  }

  buildSlider() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: widget.ds.data['urlimage'] == null
                      ? Image.asset(
                    'images/photo.png',
                    height: 250,
                    width: MediaQuery.of(context).size.width - 40.0,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    widget.ds.data['urlimage'],
                    height: 250,
                    width: MediaQuery.of(context).size.width - 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.red,
                        size: 50,
                      ),
                      onPressed: () => navigateToDetail5(widget.ds),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Marker localmarker() {
    return Marker(
      infoWindow: InfoWindow(
          title: widget.ds.data['casename'],
          snippet: "${widget.ds.data['level']}"),
      markerId: MarkerId('mylocal'),
      position: LatLng(widget.ds.data['position']['geopoint'].latitude,
          widget.ds.data['position']['geopoint'].longitude),
    );
  }
}
