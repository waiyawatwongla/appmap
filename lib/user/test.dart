import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";

  Widget _widget(String searchText) {
    return RaisedButton(
      elevation: 2,
      color: Colors.green,
      child: Text(searchText),
      onPressed: () {
        setState(() {
          name = searchText;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            Container(
              height: 50,
              color: Colors.white.withOpacity(0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _widget("แม่สอด"),
                  _widget("มหาวัน"),
                  _widget("ท่าสายลวด"),
                  _widget("อื่นๆ")
                ],
              ),
            ),
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 3),
                child: Text(
                  "Seach for: $name",
                  style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (name != "" && name != null)
                    ? Firestore.instance
                        .collection('items').where('name', isGreaterThanOrEqualTo: name)
                        .snapshots()
                    : Firestore.instance.collection("items").snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data =
                                snapshot.data.documents[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Image.network(
                                    data['imageUrl'],
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        data['District'],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
