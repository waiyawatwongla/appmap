import 'package:appmap/Case_attentive/caseattentive.dart';
import 'package:appmap/Map/Homeviewgoolemap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemPage extends StatefulWidget {
  final String casename;
  final String casedetail;
  final String caseimage;
  final String caselevel;
  final String casearea;
  final GeoPoint casemap;

  ItemPage({
    Key key,
    @required this.casename,
    @required this.casedetail,
    @required this.caseimage,
    @required this.caselevel,
    @required this.casearea,
    @required this.casemap,
  }) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String casedetail = "Please wait...detail";
  String caseimage = "Please wait.....";
  String caselevel = "Please wait.....";
  Geoflutterfire geo;
  Set<Marker> mymarkers() {
    return <Marker>[localmarker()].toSet();
  }

  @override
  void initState() {
    super.initState();
    geo = Geoflutterfire();
    Firestore.instance.collection("CaseNotify").document().get().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(   backgroundColor: Colors.green[900],
          title: Text(
            widget.casename,
            style: TextStyle(fontSize: 18,    fontFamily: 'Kanit',),
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
                        style: TextStyle(    fontFamily: 'Kanit',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
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
                //         style: TextStyle(    fontFamily: 'Kanit',
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
                  child: textlevel(),
                ),
                SizedBox(height: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "รายละเอียด",
                    style: TextStyle(    fontFamily: 'Kanit',
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
                    style: TextStyle(    fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "แผนที่ตั้ง",
                    style: TextStyle(    fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),SizedBox(height: 20,),
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
              color: Colors.green,    fontFamily: 'Kanit',
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
              color: Colors.yellow,    fontFamily: 'Kanit',
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
              color: Colors.orange,    fontFamily: 'Kanit',
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
              color: Colors.red,    fontFamily: 'Kanit',
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
            title: Text(title,style: TextStyle(    fontFamily: 'Kanit',)),
            content: Text(message,style: TextStyle(    fontFamily: 'Kanit',)),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                   Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(    fontFamily: 'Kanit',),))
            ],
          );
        });
  }

  adddata() async {
    List<String> indexlist = [];
    for (int i = 0; i < widget.casename.length; i++) {
      for (int y = 1; y < widget.casename[i].length + 1; y++) {
        indexlist.add(widget.casename[i].substring(0, y).toLowerCase());
      }
    }
    print(indexlist);

    Firestore firestore = Firestore.instance;
    GeoFirePoint geoFirePoint = geo.point(latitude: widget.casemap.latitude, longitude: widget.casemap.longitude);
    firestore.collection('Caseinterested').add({
      'name': widget.casename,
      'detail': widget.casedetail,
      'urlimage': widget.caseimage,
      'level': widget.caselevel,
      'district': widget.casearea,
      'position': geoFirePoint.data,
      'searchindex' : indexlist,
    }).then((_) {
      showAlertSucusses('การอัปโหลด', 'สำเร็จ');
    });
  }

  void adddatas(String name) {
    List<String> split = name.split(" ");
    List<String> indexlist = [];

    for (int i = 0; i < split.length; i++) {
      for (int y = 1; y < split[i].length + 1; y++) {
        indexlist.add(split[i].substring(0, y).toLowerCase());
      }
    }
    print(indexlist);

    Firestore.instance
        .collection('item')
        .document()
        .setData(({'name': name, 'searchindex': indexlist}));
  }


}
