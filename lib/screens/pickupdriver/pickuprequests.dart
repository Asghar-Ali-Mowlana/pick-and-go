import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/pickupdriver/pickupdrivermaptracking.dart';
import 'package:pickandgo/screens/pickupdriver/widgets/navigationdrawerpickupdriver.dart';
import 'package:universal_io/io.dart' as u;

import '(web)pickupdriver_showrequestdetails.dart';


class PickupDriverPickupRequests extends StatefulWidget {
  final String id;

  bool? driveroccupied;
  String? operationalcenterid;

  PickupDriverPickupRequests({
    required this.id,
    required this.operationalcenterid,
    required this.driveroccupied,
  });

  @override
  _PickupDriverPickupRequestsState createState() =>
      _PickupDriverPickupRequestsState();
}

class _PickupDriverPickupRequestsState
    extends State<PickupDriverPickupRequests> {
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

  bool _isLoading = true;

  @override
  void initState() {
    //getCordFromAdd();
    super.initState();
    getyo();
    //_stopListening();
    _requestPermission();
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
              driveroccupied: occupiedornot,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Pickup Delivery'),
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
                      children: const [
                        Icon(
                          Icons.notifications_active,
                          color: Colors.black87,
                          size: 28,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          'Pickup Requests',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (_isLoading == true)
                      ? const Padding(
                          padding: EdgeInsets.only(top: 350.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (occupiedornot == false)
                          ? Expanded(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('package')
                                    .where('pickupreqaccepted',
                                        isEqualTo: false)
                                    .where('operationalcenterid',
                                        isEqualTo: widget.operationalcenterid)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        //print(lala);
                                        return Card(
                                          child: ListTile(
                                            title: Row(
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.local_shipping),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['packageid']
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Wrap(
                                              children: [
                                                Text(
                                                    "${snapshot.data!.docs[index]['pickupAddress'].toString()}"),
                                              ],
                                            ),
                                            trailing: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: MaterialButton(
                                                color: Colors.green,
                                                textColor: Colors.white,
                                                child: Text("Confirm"),
                                                onPressed: () async {
                                                  var cusid = snapshot.data!
                                                      .docs[index]['userid']
                                                      .toString();
                                                  FirebaseFirestore.instance
                                                      .collection('package')
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['packageid'])
                                                      //update method
                                                      .update({
                                                    "pickupdriverid": widget.id,
                                                    //add the user id inside the favourites array
                                                    "pickupreqaccepted": true
                                                  });

                                                  print("Pickup request confirmed, driver id:${widget.id}");
                                                  print("Pickup request confirmed for package id:${snapshot
                                                      .data!
                                                      .docs[index]
                                                  ['packageid']
                                                      .toString()}");

                                                  FirebaseFirestore
                                                      firebaseFirestore =
                                                      FirebaseFirestore
                                                          .instance;

                                                  await firebaseFirestore
                                                      .collection("users")
                                                      .doc(widget.id)
                                                      //insert to firebase database
                                                      .update({
                                                    "packageid": snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['packageid']
                                                        .toString(),
                                                    "driveroccupied": true,
                                                  });
                                                  var y = snapshot.data!
                                                                  .docs[index][
                                                              'pickuplatitude'] ==
                                                          null
                                                      ? 0.0
                                                      : snapshot
                                                          .data!
                                                          .docs[index]
                                                              ['pickuplatitude']
                                                          .toDouble();
                                                  var z = snapshot.data!
                                                                  .docs[index][
                                                              'pickuplongitude'] ==
                                                          null
                                                      ? 0.0
                                                      : snapshot
                                                          .data!
                                                          .docs[index][
                                                              'pickuplongitude']
                                                          .toDouble();

                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => MyMap(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              LatLng(y, z),
                                                              widget.id,
                                                              widget
                                                                  .operationalcenterid,
                                                              occupiedornot,
                                                              cusid,
                                                              snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'Vehicle Type']
                                                                  .toString())));
                                                },
                                              ),
                                            ),
                                          ),
                                        );
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
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.id)
                                              .get()
                                              .then((driver) {
                                            FirebaseFirestore.instance
                                                .collection('package')
                                                .doc(
                                                    driver.data()!['packageid'])
                                                .get()
                                                .then((value) {
                                              var cusidd = value
                                                  .data()!['userid']
                                                  .toString();
                                              var y = value.data()![
                                                          'pickuplatitude'] ==
                                                      null
                                                  ? 0.0
                                                  : value
                                                      .data()!['pickuplatitude']
                                                      .toDouble();
                                              var z = value.data()![
                                                          'pickuplongitude'] ==
                                                      null
                                                  ? 0.0
                                                  : value
                                                      .data()![
                                                          'pickuplongitude']
                                                      .toDouble();

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => MyMap(
                                                          value.data()![
                                                              'packageid'],
                                                          LatLng(y, z),
                                                          widget.id,
                                                          widget
                                                              .operationalcenterid,
                                                          occupiedornot,
                                                          cusidd,
                                                          value.data()![
                                                              'Vehicle Type'])));
                                            });
                                          });
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
              driveroccupied: occupiedornot,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Pickup Delivery'),
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
                      children: const [
                        Icon(
                          Icons.notifications_active,
                          color: Colors.black87,
                          size: 28,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          'Pickup Requests',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (_isLoading == true)
                      ? const Padding(
                          padding: EdgeInsets.only(top: 350.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (occupiedornot == false)
                          ? Expanded(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('package')
                                    .where('pickupreqaccepted',
                                        isEqualTo: false)
                                    .where('operationalcenterid',
                                        isEqualTo: widget.operationalcenterid)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        //print(lala);
                                        return Card(
                                          child: ListTile(
                                            title: Row(
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.local_shipping),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['packageid']
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Wrap(
                                              children: [
                                                Text(
                                                    "${snapshot.data!.docs[index]['pickupAddress'].toString()}"),
                                              ],
                                            ),
                                            trailing: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: MaterialButton(
                                                color: Colors.green,
                                                textColor: Colors.white,
                                                child: Text("Confirm"),
                                                onPressed: () async {
                                                  var cusid = snapshot.data!
                                                      .docs[index]['userid']
                                                      .toString();
                                                  FirebaseFirestore.instance
                                                      .collection('package')
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['packageid'])
                                                      //update method
                                                      .update({
                                                    "pickupdriverid": widget.id,
                                                    //add the user id inside the favourites array
                                                    "pickupreqaccepted": true
                                                  });

                                                  FirebaseFirestore
                                                      firebaseFirestore =
                                                      FirebaseFirestore
                                                          .instance;

                                                  await firebaseFirestore
                                                      .collection("users")
                                                      .doc(widget.id)
                                                      //insert to firebase database
                                                      .update({
                                                    "packageid": snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['packageid']
                                                        .toString(),
                                                    "driveroccupied": true,
                                                  });
                                                  var y = snapshot.data!
                                                                  .docs[index][
                                                              'pickuplatitude'] ==
                                                          null
                                                      ? 0.0
                                                      : snapshot
                                                          .data!
                                                          .docs[index]
                                                              ['pickuplatitude']
                                                          .toDouble();
                                                  var z = snapshot.data!
                                                                  .docs[index][
                                                              'pickuplongitude'] ==
                                                          null
                                                      ? 0.0
                                                      : snapshot
                                                          .data!
                                                          .docs[index][
                                                              'pickuplongitude']
                                                          .toDouble();

                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => WebShowRequestDetails(
                                                              widget.id,
                                                              widget.operationalcenterid!,
                                                              snapshot
                                                                  .data!
                                                                  .docs[index][
                                                              'packageid']


                                                          )));
                                                },
                                              ),
                                            ),
                                          ),
                                        );
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
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.id)
                                              .get()
                                              .then((driver) {
                                            FirebaseFirestore.instance
                                                .collection('package')
                                                .doc(
                                                    driver.data()!['packageid'])
                                                .get()
                                                .then((value) {
                                              var cusidd = value
                                                  .data()!['userid']
                                                  .toString();
                                              var y = value.data()![
                                                          'pickuplatitude'] ==
                                                      null
                                                  ? 0.0
                                                  : value
                                                      .data()!['pickuplatitude']
                                                      .toDouble();
                                              var z = value.data()![
                                                          'pickuplongitude'] ==
                                                      null
                                                  ? 0.0
                                                  : value
                                                      .data()![
                                                          'pickuplongitude']
                                                      .toDouble();

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => WebShowRequestDetails(
                                                          widget.id,
                                                          widget.operationalcenterid!,
                                                          value
                                                              .data()![
                                                          'packageid']


                                                      )));
                                            });
                                          });
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
