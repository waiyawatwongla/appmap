import 'dart:io';

import 'package:appmap/Case_manager/casemanager.dart';
import 'package:appmap/Profile/profilepage.dart';
import 'package:appmap/show/showattentive.dart';
import 'package:appmap/show/shownew.dart';
import 'package:appmap/user/searchbar.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Case_attentive/caseattentive.dart';
import '../Case_news/casenews.dart';
import '../Case_notify/caseadd.dart';
import '../Login/login.dart';
import 'Homeviewgoolemap.dart';

class Navigationbar extends StatefulWidget {
  final FirebaseUser user;

  Navigationbar(this.user);

  @override
  _NavigationbarState createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  int selectedpage = 0; //initial value

  List<StatefulWidget> _pageOptions = [
    MapsPage(),
    CloudFirestoreSearch(),
    casenews(),
    caseattentive(),
    // casemanager(),
  ]; // listing of all 3 pages index wise

  // final bgcolor = [Colors.green, Colors.teal, Colors.greenAccent];

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/'));
  }


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('แจ้งเตือน?',style: TextStyle(fontFamily: 'Kanit'),),
        content: Text('คุณต้องการออกจากแอปพลิเคชัน?',style: TextStyle(fontFamily: 'Kanit'),),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('ยกเลิก',style: TextStyle(fontFamily: 'Kanit'),),
          ),
          FlatButton(
            onPressed: () => exit(0),
            /*Navigator.of(context).pop(true)*/
            child: Text('ยืนยัน',style: TextStyle(fontFamily: 'Kanit'),),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(drawer: _drawer(),
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            title: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'images/logo4.png',
                  height: MediaQuery.of(context).size.height,
                  width: 60,
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  'Prevent violence',
                  style: TextStyle(fontFamily: 'Kanit'),
                ),


              ],
            ),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(
              //     Icons.search,
              //     color: Colors.white,
              //   ),
              // ),
              // IconButton(
              //     icon: Icon(
              //   Icons.account_circle,
              //   color: Colors.white,
              // ))
            ],
          ),
          body: _pageOptions[selectedpage],
          bottomNavigationBar: FancyBottomNavigation(
            inactiveIconColor: Colors.white,
            circleColor: Colors.white,
            textColor: Colors.white,
            barBackgroundColor: Colors.green[900],
            activeIconColor: Colors.green,
            tabs: [
              TabData(
                iconData: Icons.map,
                title: "แผนที่",
              ),
              TabData(
                iconData: Icons.search,
                title: "ค้นหา",
              ),
              TabData(
                iconData: Icons.new_releases,
                title: "ข่าวใหม่",
              ),
              TabData(
                iconData: Icons.favorite,
                title: "เคสที่สนใจ",
              ),
              // TabData(
              //   iconData: Icons.settings,
              //   title: "การจัดการ",
              // ),
            ],
            onTabChangedListener: (position) {
              setState(() {
                selectedpage = position;
              });
            },
          ),
        ),
      ),
    );

    // Center(
    //   child: _pageWidget.elementAt(_selectedIndex),
    // ),
    // // drawer: _drawer(),
    // bottomNavigationBar: Theme(
    //   data: Theme.of(context).copyWith(
    //       canvasColor: Colors.green[900],
    //       primaryColor: Colors.teal,
    //       textTheme: Theme.of(context)
    //           .textTheme
    //           .copyWith(caption: TextStyle(color: Colors.black))),
    //   child: BottomNavigationBar(
    //     items: <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.map),
    //         title: Text('แผนที่',style: TextStyle( fontFamily: 'Kanit'),),
    //       ),
    //       // BottomNavigationBarItem(
    //       //   icon: Icon(Icons.add),
    //       //   title: Text('แจ้งข่าว',style: TextStyle( fontFamily: 'Kanit')),
    //       // ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.new_releases),
    //         title: Text('ข่าวใหม่',style: TextStyle( fontFamily: 'Kanit')),
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.favorite),
    //         title: Text('เคสที่สนใจ',style: TextStyle( fontFamily: 'Kanit')),
    //       ),
    //     ],
    //     currentIndex: _selectedIndex,
    //     selectedItemColor: Colors.white,
    //     onTap: _onItemTapped,
    //   ),
    // ),
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 1,
            child: Stack(children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
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
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/logo4.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                      // height: MediaQuery.of(context).size.height * 0.3,
                      height: 160,
                    ),
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
              )
            ]),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.green[900],
            ),
            title: Text("จัดการเคส", style: TextStyle(fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => casemanager(user: widget.user,)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ),
            title: Text("เคสที่สนใจ", style: TextStyle(fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => shoowattentive()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.new_releases,
              color: Colors.yellow,
            ),
            title: Text("ข่าวใหม่เคส", style: TextStyle(fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => shownews()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.orange,
            ),
            title:
                Text("แจ้งความรุนแรง", style: TextStyle(fontFamily: 'Kanit')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => casadd(user: widget.user,)));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.account_box,
                color: Colors.teal,
              ),
              title: Text("โปรไฟล์", style: TextStyle(fontFamily: 'Kanit')),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profilepage(widget.user)));
              }),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text("ออกจากระบบ", style: TextStyle(fontFamily: 'Kanit')),
            onTap: () {
              signOut(context);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
