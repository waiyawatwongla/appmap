import 'package:appmap/Case_attentive/caseattentive.dart';
import 'package:appmap/Map/Homeviewgoolemap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemPage extends StatefulWidget {
  final String casename;
  final String casedetail;
  final String caseimage;
  final String caselevel;
  final GeoPoint casemap;

  ItemPage({
    Key key,
    @required this.casename,
    @required this.casedetail,
    @required this.caseimage,
    @required this.caselevel,
    @required this.casemap,
  }) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String casedetail = "Please wait...detail";
  String caseimage = "Please wait.....";
  String caselevel = "Please wait.....";

  Set<Marker> mymarkers() {
    return <Marker>[localmarker()].toSet();
  }

  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("CaseNotify").document().get().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.casename,
            style: TextStyle(fontSize: 18),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.cloud_upload,
              ),
              onPressed: () {
                adddata();
              },
            ),
          ],
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
                      child: Text(
                        widget.casename,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.map,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.call,
                      size: 14,
                      color: Colors.green,
                    ),
                    SizedBox(width: 3),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '081234975319',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.blueGrey[300],
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: textlevel(),
                ),
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "รายละเอียด",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.casedetail,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 200,
                  width: 320,
                  child: Card(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            widget.casemap.latitude, widget.casemap.longitude),
                        zoom: 15.0,
                      ),
                      markers: mymarkers(),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.call,
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget textlevel() {
    if (widget.caselevel == 'ระดับความรุนแรง ปลอดภัย') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.caselevel}',
            style: TextStyle(
              color: Colors.green,
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
    } else if (widget.caselevel == 'ระดับความรุนแรง น้อย') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.caselevel}',
            style: TextStyle(
              color: Colors.yellow,
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
    } else if (widget.caselevel == 'ระดับความรุนแรง มาก') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.caselevel}',
            style: TextStyle(
              color: Colors.orange,
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
    } else if (widget.caselevel == 'ระดับความรุนแรง มากที่สุด') {
      return Row(
        children: <Widget>[
          Text(
            '${widget.caselevel}',
            style: TextStyle(
              color: Colors.red,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: widget.caseimage == null
                  ? Image.asset(
                      'images/photo.png',
                      height: 250,
                      width: MediaQuery.of(context).size.width - 40.0,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.caseimage,
                      height: 250,
                      width: MediaQuery.of(context).size.width - 40.0,
                      fit: BoxFit.cover,
                    ),
            ),
          );
        },
      ),
    );
  }

  Marker localmarker() {
    return Marker(
      infoWindow:
          InfoWindow(title: widget.casename, snippet: "${widget.caselevel}"),
      markerId: MarkerId('mylocal'),
      position: LatLng(widget.casemap.latitude, widget.casemap.longitude),
    );
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
                        MaterialPageRoute(builder: (value) => caseattentive());
                    Navigator.of(context)
                        .pushAndRemoveUntil(route, (value) => false);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  adddata() async {
    Firestore firestore = Firestore.instance;

    firestore.collection('Caseinterested').add({
      'name': widget.casename,
      'detail': widget.casedetail,
      'urlimage': widget.caseimage,
      'level': widget.caselevel,
      'position': widget.casemap
    }).then((_) {
      showAlertSucusses('การอัปโหลด', 'สำเร็จ');
    });
  }
}
