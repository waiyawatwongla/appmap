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
              canvasColor: Colors.green[900],
              primaryColor: Colors.teal,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.black))),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('แผนที่',style: TextStyle( fontFamily: 'Kanit'),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('แจ้งข่าว',style: TextStyle( fontFamily: 'Kanit')),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.new_releases),
                title: Text('ข่าวใหม่',style: TextStyle( fontFamily: 'Kanit')),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                title: Text('เคสที่สนใจ',style: TextStyle( fontFamily: 'Kanit')),
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
            opacity: 1,
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green[900],
                          Colors.green,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset(
                    'images/logo2.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'เข้าสู่ระบบโดย :',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit'),
                        ),
                        Text(
                          widget.user.email,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ]),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.green[900],
            ),
            title: Text("จัดการเคส",style: TextStyle( fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => casemanager()));
            },
          ),Divider(),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ),
            title: Text("เคสที่สนใจ",style: TextStyle( fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => caseattentive()));
            },
          ),Divider(),
          ListTile(
            leading: Icon(
              Icons.new_releases,
              color: Colors.yellow,
            ),
            title: Text("ข่าวใหม่เคส",style: TextStyle( fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => casenews()));
            },
          ),Divider(),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.orange,
            ),
            title: Text("แจ้งความรุนแรง",style: TextStyle( fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => casadd()));
            },
          ),Divider(),
          ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.teal,
              ),
              title: Text("โปรไฟล์",style: TextStyle( fontFamily: 'Kanit')),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
              }),Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text("ออกจากระบบ",style: TextStyle( fontFamily: 'Kanit')),
            onTap: () {
              signOut(context);
            },
          ),Divider(),
        ],
      ),
    );
  }
}
