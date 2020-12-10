import 'package:appmap/Case_manager/casemanager.dart';
import 'package:appmap/Profile/testupdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Case_attentive/caseattentive.dart';
import '../Case_news/casenews.dart';
import '../Case_notify/caseadd.dart';
import '../Login/login.dart';
import 'Homeviewgoolemap.dart';

class Navigationbar extends StatefulWidget {
  final FirebaseUser user;

  Navigationbar(this.user, {Key key}) : super(key: key);

  @override
  _NavigationbarState createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user;
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    MapsPage(),
    casadd(),
    casenews(),
    caseattentive(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _pageWidget.elementAt(_selectedIndex),
        ),
        drawer: _drawer(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.orangeAccent[200],
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.black))),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('แผนที่'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('แจ้งข่าว'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.new_releases),
                title: Text('ข่าวใหม่'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                title: Text('เคสที่สนใจ'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orangeAccent,
                          Colors.orangeAccent,
                          Colors.orange
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ]),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.orangeAccent,
            ),
            title: Text("จัดการเคส"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => casemanager()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.orangeAccent,
            ),
            title: Text("เคสที่สนใจ"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => caseattentive()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.new_releases,
              color: Colors.orangeAccent,
            ),
            title: Text("ข่าวใหม่เคส"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => casenews()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.orangeAccent,
            ),
            title: Text("แจ้งความรุนแรง"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => casadd()));
            },
          ),
          ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.orangeAccent,
              ),
              title: Text("โปรไฟล์"),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
              }),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.orangeAccent,
            ),
            title: Text("ออกจากระบบ"),
            onTap: () {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
