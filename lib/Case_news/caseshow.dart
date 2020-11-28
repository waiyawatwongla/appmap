import 'package:appmap/Case_news/casenews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget {
  final String casename;
  final String casedetail;
  final String caseimage;
  final String caselevel;

  ItemPage(
      {Key key,
      @required this.casename,
      @required this.casedetail,
      @required this.caseimage,@required this.caselevel,})
      : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String casedetail = "Please wait...detail";
  String caseimage = "Please wait.....";
  String caselevel = "Please wait.....";
  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("CaseNotify").document().get().then((value) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.casename}'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '${widget.casename}',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.casedetail,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.caselevel,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.network(
                    widget.caseimage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
