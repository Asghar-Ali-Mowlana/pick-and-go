import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/dropoffdriver/widgets/navigationdrawerdriverdropofff.dart';
import 'package:universal_io/io.dart' as u;

import 'dropOffDriverMap.dart';

class DropoffDriverRequests extends StatefulWidget {
  final String id;
  bool? driveroccupied;
  String? operationalcenterid;

  DropoffDriverRequests({
    required this.id,
    this.operationalcenterid,
    this.driveroccupied,
  });

  @override
  _DropoffDriverRequestsState createState() => _DropoffDriverRequestsState();
}

class _DropoffDriverRequestsState extends State<DropoffDriverRequests> {
  bool _isLoading = true;

  bool? occupiedornot;

  getyo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((value) {
      occupiedornot = value.data()!['driveroccupied'];
    });
  }

  @override
  void initState() {
    //getCordFromAdd();
    getyo();
    _requestPermission();
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
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
              driveroccupied: widget.driveroccupied,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Dropoff Delivery'),
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
                          'Drop-Off Requests',
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
                      : (occupiedornot == false)
                          ? Expanded(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .where('uid', isEqualTo: widget.id)
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
                                        x = snapshot
                                            .data?.docs[index]['packages']
                                            .toList();

                                        //print(lala);
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
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['uid']
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons
                                                            .keyboard_arrow_right),
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'package')
                                                              .where(
                                                                  'deliverydriverid',
                                                                  isEqualTo:
                                                                      widget.id)
                                                              .where(
                                                                  'packageDelivered',
                                                                  isEqualTo:
                                                                      false)
                                                              .where(
                                                                  'packageLeftOperationalCenter',
                                                                  isEqualTo:
                                                                      false)
                                                              .get()
                                                              .then((QuerySnapshot
                                                                      querySnapshot) =>
                                                                  {
                                                                    querySnapshot
                                                                        .docs
                                                                        .forEach(
                                                                            (doc) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'package')
                                                                          .doc(doc['packageid']
                                                                              .toString())
                                                                          .set({
                                                                        "packageLeftOperationalCenter":
                                                                            true,
                                                                        //add the ingredient inside the ingredients array
                                                                      }, SetOptions(merge: true));

                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(widget
                                                                              .id)
                                                                          //update method
                                                                          .update({
                                                                        //add the user id inside the favourites array
                                                                        "driveroccupied":
                                                                            true
                                                                      });
                                                                    })
                                                                  });
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DropOffDriverMap(
                                                                      widget.id,
                                                                      widget
                                                                          .operationalcenterid,
                                                                      widget
                                                                          .driveroccupied)));
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Text("No Requests");
                                      });
                                },
                              ),
                            )
                          : (occupiedornot == true)
                              ? Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: MaterialButton(
                                        color: Colors.black,
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DropOffDriverMap(
                                                          widget.id,
                                                          widget
                                                              .operationalcenterid,
                                                          widget
                                                              .driveroccupied)));
                                        },
                                        child: Text("Ongoing")),
                                  ),
                                )
                              : Text("${occupiedornot}"),
                ],
              ),
            ),
          )
        : Scaffold(
            drawer: NavigationDrawerWidget(
              id: widget.id,
              driveroccupied: widget.driveroccupied,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Dropoff Delivery'),
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
                          'Drop-Off Requests',
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
                      : (occupiedornot == false)
                          ? Expanded(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .where('uid', isEqualTo: widget.id)
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
                                        x = snapshot
                                            .data?.docs[index]['packages']
                                            .toList();

                                        //print(lala);
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
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['uid']
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons
                                                            .keyboard_arrow_right),
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'package')
                                                              .where(
                                                                  'deliverydriverid',
                                                                  isEqualTo:
                                                                      widget.id)
                                                              .where(
                                                                  'packageDelivered',
                                                                  isEqualTo:
                                                                      false)
                                                              .where(
                                                                  'packageLeftOperationalCenter',
                                                                  isEqualTo:
                                                                      false)
                                                              .get()
                                                              .then((QuerySnapshot
                                                                      querySnapshot) =>
                                                                  {
                                                                    querySnapshot
                                                                        .docs
                                                                        .forEach(
                                                                            (doc) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'package')
                                                                          .doc(doc['packageid']
                                                                              .toString())
                                                                          .set({
                                                                        "packageLeftOperationalCenter":
                                                                            true,
                                                                        //add the ingredient inside the ingredients array
                                                                      }, SetOptions(merge: true));

                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(widget
                                                                              .id)
                                                                          //update method
                                                                          .update({
                                                                        //add the user id inside the favourites array
                                                                        "driveroccupied":
                                                                            true
                                                                      });
                                                                    })
                                                                  });
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DropOffDriverMap(
                                                                      widget.id,
                                                                      widget
                                                                          .operationalcenterid,
                                                                      widget
                                                                          .driveroccupied)));
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Text("No Requests");
                                      });
                                },
                              ),
                            )
                          : (occupiedornot == true)
                              ? Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: MaterialButton(
                                        color: Colors.black,
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DropOffDriverMap(
                                                          widget.id,
                                                          widget
                                                              .operationalcenterid,
                                                          widget
                                                              .driveroccupied)));
                                        },
                                        child: Text("Ongoing")),
                                  ),
                                )
                              : Text("${occupiedornot}"),
                ],
              ),
            ),
          );
  }

  // _getLocation() async {
  //   try {
  //     final loc.LocationData _locationResult = await location.getLocation();
  //     await FirebaseFirestore.instance.collection('location').doc('user1').set({
  //       'latitude': _locationResult.latitude,
  //       'longitude': _locationResult.longitude,
  //       'name': 'john'
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
