//
// import 'package:appmap/components/show_notification.dart';
// import 'package:appmap/services/add_item_service.dart';
// import 'package:appmap/services/logger_service.dart';
// import 'package:flutter/material.dart';
// class casenotify extends StatefulWidget {
//   casenotify({Key key}) : super(key: key);
//
//   @override
//   _casenotify createState() => _casenotify();
// }
//
// class _casenotify extends State<casenotify> {
//   final pdname = TextEditingController();
//   final pddes = TextEditingController();
//   final pddesdate = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("แจ้งข่าวสารความรุนแรง"),
//           backgroundColor: Colors.orange,
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       children: <Widget>[
//                         TextField(
//                           decoration: InputDecoration(labelText: "Case Name"),
//                           controller: pdname,
//                         ),
//                         Padding(padding: const EdgeInsets.all(10)),
//                         TextField(
//                           decoration:
//                           InputDecoration(labelText: "Case Description"),
//                           controller: pddes,
//                         ),
//                         Padding(padding: const EdgeInsets.all(10)),
//                         TextField(
//                           decoration:
//                           InputDecoration(labelText: "Case test"),
//                           controller: pddesdate,
//                         ),
//                         Padding(padding: const EdgeInsets.all(10)),
//                         RaisedButton(
//                           child: Text("เพิ่มข้อมูล"),
//                           onPressed: () {
//                             if (pdname.text == "" || pddes.text == "" || pddesdate.text == "") {
//                               showMessageBox(context, "Error",
//                                   "Please enter name and description before adding it to firebase",
//                                   actions: [dismissButton(context)]);
//                               logger.e("pdname or pddes can't be null");
//                             } else {
//                               addItem(
//                                   context,
//                                   {"name": pdname.text, "description": pddes.text, "date": pddesdate.text},
//                                   pdname.text);
//                               pdname.text = "";
//                               pddes.text = "";
//                               pddesdate.text = "";
//                             }
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
