import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import '../../../services/google_map_api.dart';

class DropOffDriverMap extends StatefulWidget {
  const DropOffDriverMap({Key? key}) : super(key: key);

  @override
  State<DropOffDriverMap> createState() => _DropOffDriverMapState();
}

class _DropOffDriverMapState extends State<DropOffDriverMap> {
  final loc.Location _location = loc.Location();

  late GoogleMapController _controller;

  bool _isLoading = true;

  Set<Marker> _markers = {};

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  String dropOffDriverId = "r81JnyGKgkaq3AyxciwbwUfMLJ23";

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
        color: Colors.blueAccent,
        points: polylineCoordinates,
      ));
    });
  }

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
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          infoWindow: InfoWindow(title: "Driver", snippet: dropOffDriverId)));
    });
    await _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat!, lan!), 14.47));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeMapMode();
    _getAllMarkers(dropOffDriverId);
    _getNearestPackageCord(dropOffDriverId);
    polylinePoints = PolylinePoints();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Package Position"),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.arrow_forward_ios_outlined),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                  target: LatLng(6.96551, 79.8675395), zoom: 14.47),
              onMapCreated: _onMapCreated,
            ),
    );
  }
}
