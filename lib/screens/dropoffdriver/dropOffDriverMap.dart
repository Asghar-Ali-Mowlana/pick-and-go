import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:pickandgo/screens/dropoffdriver/dropoffdriverdroppackageonreceiver.dart';
import 'package:pickandgo/screens/dropoffdriver/dropoffrequests.dart';
import 'package:pickandgo/services/google_map_api.dart';

class DropOffDriverMap extends StatefulWidget {
  //const DropOffDriverMap({Key? key}) : super(key: key);

  String? id;
  String? operationalcenterid;
  bool? driveroccupied;
  DropOffDriverMap(
    this.id,
    this.operationalcenterid,
    this.driveroccupied,
  );

  @override
  State<DropOffDriverMap> createState() => _DropOffDriverMapState();
}

class _DropOffDriverMapState extends State<DropOffDriverMap> {
  BitmapDescriptor? icon;
  final loc.Location _location = loc.Location();

  late GoogleMapController _controller;

  bool _isLoading = true;

  Set<Marker> _markers = {};

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  void setPolylinesInMap(driverlat, driverlng, deslat, deslng) async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(driverlat, driverlng),
      PointLatLng(deslat, deslng),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.black,
        points: polylineCoordinates,
      ));
    });
  }

  StreamSubscription<loc.LocationData>? _locationSubscription;
  final loc.Location location = loc.Location();

  var driverLat;
  var driverLan;
  var packageLat;
  var packageLan;

  _getNearestPackageCord(deliveryDriverId) async {
    final loc.LocationData _locationResult = await _location.getLocation();
    var lat = _locationResult.latitude;
    var lan = _locationResult.longitude;
    driverLat = lat;
    driverLan = lan;
    double distanceInMeters;
    int shortestDistanceIndex;
    String packageId;
    List<String> packageIdList = <String>[];
    List<double> shortestDistance = <double>[];
    await FirebaseFirestore.instance
        .collection('package')
        .where('deliverydriverid', isEqualTo: deliveryDriverId)
        .where('packageDelivered', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                distanceInMeters = Geolocator.distanceBetween(
                    _locationResult.latitude!,
                    _locationResult.longitude!,
                    doc['dropofflatitude'],
                    doc['dropofflongitude']);
                shortestDistance.add(distanceInMeters);
                packageIdList.add(doc['packageid']);
              })
            });

    shortestDistanceIndex =
        shortestDistance.indexOf(shortestDistance.reduce(min));
    packageId = packageIdList[shortestDistanceIndex];

    await FirebaseFirestore.instance
        .collection('package')
        .doc(packageId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        packageLat = documentSnapshot['dropofflatitude'];
        packageLan = documentSnapshot['dropofflongitude'];
      } else {
        print("The package document does not exist");
      }
    });
  }

  _getAllMarkers(deliveryDriverId) async {
    await FirebaseFirestore.instance
        .collection('package')
        .where('deliverydriverid', isEqualTo: deliveryDriverId)
        .where('packageDelivered', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _markers.add(Marker(
                      markerId: MarkerId(doc['packageid']),
                      position: LatLng(
                          doc['dropofflatitude'], doc['dropofflongitude']),
                      infoWindow: InfoWindow(
                          title: doc['receiverName'],
                          snippet: doc['receiverContactNo'])));
                });
              })
            });
  }

  void _onMapCreated(GoogleMapController controller) {
    changeMapMode();
    setState(() {
      _controller = controller;
      setPolylinesInMap(driverLat, driverLan, packageLat, packageLan);
    });
    _goTocurrentPosition();
  }

  changeMapMode() {
    getJsonFile('assets/mapstyle.json').then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  Future<void> _goTocurrentPosition() async {
    final loc.LocationData _locationResult = await _location.getLocation();
    var lat = _locationResult.latitude;
    var lan = _locationResult.longitude;

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(lat!, lan!),
          icon: icon!,
          infoWindow: InfoWindow(title: "Driver", snippet: widget.id)));
    });
    await _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat!, lan!), 14.47));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIcons();
    _listenLocation();
    changeMapMode();
    location.changeSettings(
        interval: 2300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    _getAllMarkers(widget.id);
    _getNearestPackageCord(widget.id);
    polylinePoints = PolylinePoints();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

// Cargar imagen del Marker
  getIcons() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/lorrys.png', 150);
    setState(() {
      this.icon = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('package')
          .where('deliverydriverid', isEqualTo: widget.id)
          .where('packageDelivered', isEqualTo: false)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  FirebaseFirestore.instance
                      .collection('package')
                      .doc(doc['packageid'].toString())
                      .set({
                    'driverlatitude': currentlocation.latitude,
                    'driverlongitude': currentlocation.longitude,
                  }, SetOptions(merge: true));
                })
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = icon;
    return Scaffold(
      appBar: AppBar(
        title: Text("Package Position"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _stopListening();
            // Navigator.of(context).push(
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             PickupDriverPickupRequests(
            //               id: widget.id,
            //               driveroccupied: true,
            //               operationalcenterid: widget
            //                   .operationalcenterid,
            //
            //             )));
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DropoffDriverRequests(
                      id: widget.id!,
                      driveroccupied: true,
                      operationalcenterid: widget.operationalcenterid,
                    )));
          },
        ),
      ),
      body: (x == null || _isLoading == true)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(6.96551, 79.8675395), zoom: 14.47),
                  onMapCreated: _onMapCreated,
                ),
                /*Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 20.0,
                    onPressed: () {
                      _stopListening();
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             PickupDriverPickupRequests(
                      //               id: widget.id,
                      //               driveroccupied: true,
                      //               operationalcenterid: widget
                      //                   .operationalcenterid,
                      //
                      //             )));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DropoffDriverRequests(
                                id: widget.id!,
                                driveroccupied: true,
                                operationalcenterid: widget.operationalcenterid,
                              )));
                    },
                  ),
                ),*/
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        _stopListening();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DropPackagesDropOffDriver(
                                  widget.id,
                                  widget.operationalcenterid,
                                  widget.driveroccupied,
                                )));
                      },
                      child: Text("Drop Package")),
                ),
              ],
            ),
    );
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
      print("argh stop $_locationSubscription");
    });
  }
}
