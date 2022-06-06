//import 'dart:async';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:uuid/uuid.dart';

class MakeACall extends StatefulWidget {
  const MakeACall({Key? key}) : super(key: key);

  @override
  State<MakeACall> createState() => _MakeACallState();
}

class _MakeACallState extends State<MakeACall> {
  final loc.Location _location = loc.Location();
  Geolocator geolocator = Geolocator();

  bool _isLoading = true;

  var operationalCenterName;
  var telephoneNumber;

  _getLocation() async {
    double distanceInMeters;
    List<double> operationalCenterDistance = <double>[];
    List<String> operationalCenterIdList = <String>[];
    String operationalCenterId;
    int shortestDistanceIndex;

    var uuid = Uuid();
    var packageID = uuid.v4();
    final User? user = FirebaseAuth.instance.currentUser;
    final loc.LocationData _locationResult = await _location.getLocation();

    await FirebaseFirestore.instance
        .collection('operationalcenter')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc["name"]);
                print(doc["operationalcenterid"]);
                //print(doc["latitude"]);
                //print(doc["longitude"]);
                distanceInMeters = Geolocator.distanceBetween(
                    _locationResult.latitude!,
                    _locationResult.longitude!,
                    doc["latitude"],
                    doc["longitude"]);
                print(distanceInMeters);
                operationalCenterDistance.add(distanceInMeters);
                operationalCenterIdList.add(doc["operationalcenterid"]);
              })
            });

    shortestDistanceIndex = operationalCenterDistance
        .indexOf(operationalCenterDistance.reduce(min));

    operationalCenterId = operationalCenterIdList[shortestDistanceIndex];

    await FirebaseFirestore.instance
        .collection('operationalcenter')
        .doc(operationalCenterId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        operationalCenterName = documentSnapshot['name'];
        telephoneNumber = documentSnapshot['contactNumber'];
      } else {}
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Make A Call"),
          backgroundColor: Colors.black,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Make a call",
                          style: TextStyle(fontSize: 40),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                            "Call to the nearest operational center to book a request",
                            style: TextStyle(fontSize: 17)),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text("Center Name - ${operationalCenterName}",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Center Contact Number - ${telephoneNumber}",
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        launch('tel://$telephoneNumber');
                      },
                      child: Text("Call"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 48, vertical: 12),
                          textStyle: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ));
  }
}
