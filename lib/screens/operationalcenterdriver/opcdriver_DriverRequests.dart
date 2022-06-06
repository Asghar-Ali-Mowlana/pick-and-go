import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/operationalcenterdriver/opcdriver_DriverPackagesDropped.dart';
import 'package:pickandgo/screens/operationalcenterdriver/widgets/navigationdrawerpickupdriver.dart';
import 'package:universal_io/io.dart' as u;

class OperationalCenterDriverRequests extends StatefulWidget {
  final String id;
  bool? driveroccupiedy;
  String? operationalcenterid;

  OperationalCenterDriverRequests({
    required this.id,
    required this.driveroccupiedy,
    required this.operationalcenterid,
  });
  //const OperationalCenterDriverRequests({Key? key}) : super(key: key);

  @override
  State<OperationalCenterDriverRequests> createState() =>
      _OperationalCenterDriverRequestsState();
}

class _OperationalCenterDriverRequestsState
    extends State<OperationalCenterDriverRequests> {
  late bool driveroccupied;

  bool _isLoading = true;

  _getDriverOccupuedStatus() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        driveroccupied = documentSnapshot['driveroccupied'];
      } else {
        print("The user document does not exist");
      }
    });
  }

  @override
  void initState() {
    //getCordFromAdd();
    super.initState();
    _getDriverOccupuedStatus();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _db = DatabaseHelper();
    return (u.Platform.operatingSystem == "android")
        ? Scaffold(
            drawer: NavigationDrawerWidget(
              id: widget.id,
              driveroccupied: widget.driveroccupiedy,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Op-Center Delivery'),
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.notifications_active, size: 28),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Drop at OPC Requests',
                          style: TextStyle(
                              fontSize: 21.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (_isLoading == true)
                      ? const Padding(
                          padding: const EdgeInsets.only(top: 350.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('uid', isEqualTo: widget.id)
                                .where('driveroccupied', isEqualTo: false)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    var x = [];
                                    x = snapshot.data?.docs[index]['packages']
                                        .toList();
                                    return (x.length != 0)
                                        ? Card(
                                            child: ListTile(
                                              title: Row(
                                                children: <Widget>[
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons
                                                        .card_giftcard_outlined),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      snapshot.data!
                                                          .docs[index]['uid']
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons
                                                        .keyboard_arrow_right),
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(widget.id)
                                                          .get()
                                                          .then((DocumentSnapshot
                                                              documentSnapshot) {
                                                        if (documentSnapshot
                                                            .exists) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget.id)
                                                              .set(
                                                                  {
                                                                "driveroccupied":
                                                                    true,
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          print(
                                                              "Driver document updated successfully");
                                                        } else {
                                                          print(
                                                              "The user document does not exist ");
                                                        }
                                                      });
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OperationalCenterDriverPackagesDropped(
                                                                    id: widget
                                                                        .id,
                                                                    driveroccupiedy:
                                                                        driveroccupied,
                                                                    operationalcenterid:
                                                                        widget
                                                                            .operationalcenterid,
                                                                  )));
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Center(child: Text("No Requests"));
                                  });
                            },
                          ),
                        )
                ],
              ),
            ),
          )
        : Scaffold(
            drawer: NavigationDrawerWidget(
              id: widget.id,
              driveroccupied: widget.driveroccupiedy,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Op-Center Delivery'),
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.notifications_active, size: 28),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Drop at OPC Requests',
                          style: TextStyle(
                              fontSize: 21.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (_isLoading == true)
                      ? const Padding(
                          padding: const EdgeInsets.only(top: 350.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('uid', isEqualTo: widget.id)
                                .where('driveroccupied', isEqualTo: false)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    var x = [];
                                    x = snapshot.data?.docs[index]['packages']
                                        .toList();
                                    return (x.length != 0)
                                        ? Card(
                                            child: ListTile(
                                              title: Row(
                                                children: <Widget>[
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons
                                                        .card_giftcard_outlined),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      snapshot.data!
                                                          .docs[index]['uid']
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons
                                                        .keyboard_arrow_right),
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(widget.id)
                                                          .get()
                                                          .then((DocumentSnapshot
                                                              documentSnapshot) {
                                                        if (documentSnapshot
                                                            .exists) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget.id)
                                                              .set(
                                                                  {
                                                                "driveroccupied":
                                                                    true,
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          print(
                                                              "Driver document updated successfully");
                                                        } else {
                                                          print(
                                                              "The user document does not exist ");
                                                        }
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Center(child: Text("No Requests"));
                                  });
                            },
                          ),
                        )
                ],
              ),
            ),
          );
  }
}
