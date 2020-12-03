import 'package:appmap/Case_manager/caseupdatepage.dart';
import 'package:appmap/Login/login.dart';
import 'package:appmap/Profile/testupdate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class casemanagernotify extends StatefulWidget {
  @override
  _casemanagernotify createState() => _casemanagernotify();
}

class _casemanagernotify extends State<casemanagernotify> {
  final db = Firestore.instance;
  var selectedCurrency, selectedType;

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      value: selectedType,
      isExpanded: false,
      hint: Text(
        'เลือกระดับความรุนแรง',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }

  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyUpdatePage(
                  ds: ds,
                )));
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('colrecipes').document(doc.documentID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.orangeAccent[100],
      appBar: AppBar(
        title: Text("จัดการแจ้งข่าว"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("CaseNotify").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('"Loading...');
            }
            int length = snapshot.data.documents.length;
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //two columns
                  mainAxisSpacing: 0.1, //space the card
                  childAspectRatio: 0.800, //space largo de cada card
                ),
                itemCount: length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (_, int index) {
                  final DocumentSnapshot doc = snapshot.data.documents[index];
                  return new Container(
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () => navigateToDetail(doc),
                                child: Container(
                                  child: doc.data['urlimage'] == null
                                      ? Image.asset('images/photo.png',
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width)
                                      : Image.network(
                                          '${doc.data['urlimage']}',
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                  width: 185,
                                  height: 120,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                doc.data["name"],
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 19.0,
                                ),
                              ),
                              subtitle: Text(
                                doc.data["detail"],
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 12.0),
                              ),
                              onTap: () => navigateToDetail(doc),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: new Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection("CaseNotify")
                                            .document(doc.documentID)
                                            .delete()
                                            .catchError((e) {
                                          print(e);
                                        });
                                      }, //funciona
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    ));
  }
}
