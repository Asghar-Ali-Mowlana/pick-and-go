import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase/firebase.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

import '../../../services/google_map_api.dart';
//import 'package:pickandgo/screens/CustomerDriverTrack.dart';
//import 'package:universal_html/html.dart';
//import '../google_map_api.dart';

class CustomerWaitForDriver extends StatefulWidget {
  final packageid;
  CustomerWaitForDriver(this.packageid);

  //const CustomerWaitForDriver(doc, {Key? key}) : super(key: key);

  @override
  State<CustomerWaitForDriver> createState() =>
      _CustomerWaitForDriverState(packageid);
}

class _CustomerWaitForDriverState extends State<CustomerWaitForDriver> {
  final packageid;
  _CustomerWaitForDriverState(this.packageid);

  final loc.Location _location = loc.Location();

  late GoogleMapController _controller;
  late GoogleMapController _newController;

  bool _added = false;
  //bool _newAdded = false;
  bool _isLoading = true;

  Set<Marker> _markers = {};
  Set<Marker> _newMarkers = {};

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  Set<Polyline> _newPolylines = Set<Polyline>();
  List<LatLng> newPolylineCordinates = [];
  late PolylinePoints newPolylinePoints;

  late BitmapDescriptor mapMarker;

  loc.LocationData? currentLocation;

  late double operationalCenterLat;
  late double operationalCenterLan;

  /*void _onMapCreated(GoogleMapController controller) {
    GoogleMapController _controller;
    _controller = controller;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }*/

  changeMapMode() {
    getJsonFile('assets/mapstyle.json').then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

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

  void setNewPolylinesInMap(driverlat, driverlng, deslat, deslng) async {
    var result = await newPolylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(driverlat, driverlng),
      PointLatLng(deslat, deslng),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        newPolylineCordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _newPolylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blueAccent,
        points: newPolylineCordinates,
      ));
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

  void setCustomMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/logo.png', 150);
    //final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon), markerId: (1));
    // var icon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 2.5, size: Size(30,30)),
    //     "assets/circle.png");
    setState(() {
      this.mapMarker = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  _getOperationalCenterCord() async {
    late String packageOperationalCenterId;

    await FirebaseFirestore.instance
        .collection('package')
        .doc(packageid)
        .get()
        .then((DocumentSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        packageOperationalCenterId = dataSnapshot['operationalcenterid'];
      } else {
        print("Package Document Does Not Exist");
      }
    });

    await FirebaseFirestore.instance
        .collection('operationalcenter')
        .doc(packageOperationalCenterId)
        .get()
        .then((DocumentSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        operationalCenterLat = dataSnapshot['latitude'];
        operationalCenterLan = dataSnapshot['longitude'];
      } else {
        print("Operational Center Document Does Not Exist");
      }
    });

    print("The latitude of the nearest operational center: ");
    print(operationalCenterLat);
    print("The longitude of nearest operational center: ");
    print(operationalCenterLan);
  }

  String driverName = "";
  String driverContactNumber = "";
  double packageCost = 0.00;

  _getPackageData() async {
    late String driverId;
    late bool packageAccepted;
    await FirebaseFirestore.instance
        .collection('package')
        .doc(packageid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot['packageLeftOperationalCenter'] == false) {
          driverId = documentSnapshot['pickupdriverid'];
        } else {
          driverId = documentSnapshot['deliverydriverid'];
        }
        packageAccepted = documentSnapshot['pickupreqaccepted'];
        packageCost = documentSnapshot['totalCost'];
      } else {
        print('Package Document Does Not Exist');
      }
    });
    if (packageAccepted == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          driverName = documentSnapshot['name'];
          driverContactNumber = documentSnapshot['mobile'];
        } else {
          print('Package Document Does Not Exist');
        }
      });
    } else {
      print("Package Not Yet Accepted");
    }
  }

  Set<Marker> _dropOffMarkers = {};

  Set<Polyline> _dropOffPolylines = Set<Polyline>();
  List<LatLng> dropOffPolylineCoordinates = [];
  late PolylinePoints dropOffPolylinePoints;

  void setDropOffPolylinesInMap(driverlat, driverlng, deslat, deslng) async {
    var result = await dropOffPolylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(driverlat, driverlng),
      PointLatLng(deslat, deslng),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        dropOffPolylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _dropOffPolylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blueAccent,
        points: dropOffPolylineCoordinates,
      ));
    });
  }

  var dropOffDriverLat;
  var dropOffDriverLan;
  var dropOffPackageLat;
  var dropOffPackageLan;

  _getNearestPackageCord() async {
    final loc.LocationData _locationResult = await _location.getLocation();
    var lat = _locationResult.latitude;
    var lan = _locationResult.longitude;
    //dropOffDriverLat = lat;
    //dropOffDriverLan = lan;
    double distanceInMeters;
    int shortestDistanceIndex;
    String packageId;
    late String dropOffDeliveryDriverId;
    List<String> packageIdList = <String>[];
    List<double> shortestDistance = <double>[];

    await FirebaseFirestore.instance
        .collection('package')
        .doc(packageid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        dropOffDeliveryDriverId = documentSnapshot['deliverydriverid'];
      } else {
        print("The package document does not exist");
      }
    });

    await FirebaseFirestore.instance
        .collection('package')
        .where('deliverydriverid', isEqualTo: dropOffDeliveryDriverId)
        .where('packageDelivered', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                distanceInMeters = Geolocator.distanceBetween(
                    doc['driverlatitude'],
                    doc['driverlongitude'],
                    doc['dropofflatitude'],
                    doc['dropofflongitude']);
                shortestDistance.add(distanceInMeters);
                packageIdList.add(doc['packageid']);
              })
            });

    shortestDistanceIndex =
        shortestDistance.indexOf(shortestDistance.reduce(min));
    print(shortestDistance);
    print("The shortest distance is");
    print(shortestDistance.reduce(min));
    packageId = packageIdList[shortestDistanceIndex];

    await FirebaseFirestore.instance
        .collection('package')
        .doc(packageId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        dropOffDriverLat = documentSnapshot['driverlatitude'];
        dropOffDriverLan = documentSnapshot['driverlongitude'];
        dropOffPackageLat = documentSnapshot['dropofflatitude'];
        dropOffPackageLan = documentSnapshot['dropofflongitude'];
      } else {
        print("The package document does not exist");
      }
    });
  }

  _getAllMarkers() async {
    late String dropOffDeliveryDriverId;
    await FirebaseFirestore.instance
        .collection('package')
        .doc(packageid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        dropOffDeliveryDriverId = documentSnapshot['deliverydriverid'];
      } else {
        print("The package document does not exist");
      }
    });

    await FirebaseFirestore.instance
        .collection('package')
        .where('deliverydriverid', isEqualTo: dropOffDeliveryDriverId)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _dropOffMarkers.add(Marker(
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

  void _dropOffOnMapCreated(GoogleMapController controller) {
    changeMapMode();
    setState(() {
      _controller = controller;
      _added = true;
      setDropOffPolylinesInMap(dropOffDriverLat, dropOffDriverLan,
          dropOffPackageLat, dropOffPackageLan);

      _dropOffMarkers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(dropOffDriverLat, dropOffDriverLan),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          infoWindow: InfoWindow(title: "Driver")));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    _location.changeSettings(
        interval: 300, accuracy: loc.LocationAccuracy.high);
    _location.enableBackgroundMode(enable: true);
    setCustomMarker();
    polylinePoints = PolylinePoints();
    newPolylinePoints = PolylinePoints();
    dropOffPolylinePoints = PolylinePoints();
    _getAllMarkers();
    _getNearestPackageCord();
    _getOperationalCenterCord();
    changeMapMode();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    _getPackageData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final User? user = FirebaseAuth.instance.currentUser;

    //DocumentReference documentReference =
    //  FirebaseFirestore.instance.collection('package').doc(packageid);
    //documentReference.get().then((dataSnapshot) {
    //print(dataSnapshot['pickupreqaccepted']);
    //print(dataSnapshot['weight']);
    //});

    //DocumentReference listenDocumentReference =
    //  FirebaseFirestore.instance.collection('package').doc(packageid);
    //listenDocumentReference.snapshots().listen((querySnapshot) {})

    return Scaffold(
      appBar: AppBar(
        title: Text("Connecting To Driver"),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_getPackageData();
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(48.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(Icons.account_circle_outlined),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Text("${driverName}"),
                            )
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone_android_outlined),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 0.0, 0.0, 0.0),
                                child: Text("${driverContactNumber}"),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.attach_money_outlined),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Text("LKR ${packageCost}"),
                            )
                          ],
                        ),
                        //const Text('Modal BottomSheet'),
                        //ElevatedButton(
                        //child: const Text('Close BottomSheet'),
                        //onPressed: () => Navigator.pop(context),
                        //)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.arrow_circle_up),
        backgroundColor: Colors.black,
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('package')
            .doc(packageid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (_added) {
            mymap(snapshot);
          }
          /*if (_newAdded) {
            myNewMap(snapshot);
          }*/
          if (!snapshot.hasData) {
            return Text("loading");
          }
          var userDocument = snapshot.data;
          if (userDocument!['pickupreqaccepted'] == false &&
              userDocument['packagePickedUp'] == false &&
              userDocument['packageDroppedOperationalCenter'] == false &&
              userDocument['packageLeftOperationalCenter'] == false &&
              userDocument['packageDelivered'] == false) {
            return Center(child: CircularProgressIndicator());
          } else if (userDocument['pickupreqaccepted'] == true &&
              userDocument['packagePickedUp'] == false &&
              userDocument['packageDroppedOperationalCenter'] == false &&
              userDocument['packageLeftOperationalCenter'] == false &&
              userDocument['packageDelivered'] == false) {
            return GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                  target: LatLng(userDocument['pickuplatitude'],
                      userDocument['pickuplongitude']),
                  zoom: 14.47),
              onMapCreated: (GoogleMapController controller) async {
                changeMapMode();
                setState(() {
                  _controller = controller;
                  _added = true;
                  _markers.add(Marker(
                      markerId: MarkerId('id-1'),
                      position: LatLng(userDocument['driverlatitude'],
                          userDocument['driverlongitude']),
                      infoWindow: InfoWindow(title: 'Driver'),
                      icon: mapMarker));
                  _markers.add(Marker(
                      markerId: MarkerId('id-2'),
                      position: LatLng(userDocument['pickuplatitude'],
                          userDocument['pickuplongitude']),
                      infoWindow: InfoWindow(title: 'Destination'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen)));
                  setPolylinesInMap(
                      userDocument['driverlatitude'],
                      userDocument['driverlongitude'],
                      userDocument['pickuplatitude'],
                      userDocument['pickuplongitude']);
                });
              },
            );

            /*Container(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(6.96566, 79.86731), zoom: 15),
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    myLocationButtonEnabled: true,
                  )
                ],
              ),
            );*/
            /*Center(
              child: Container(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerDriverTrack()));
                  },
                  child: Text("Track"),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ),
            );*/
          } else if (userDocument['pickupreqaccepted'] == true &&
              userDocument['packagePickedUp'] == true &&
              userDocument['packageDroppedOperationalCenter'] == false &&
              userDocument['packageLeftOperationalCenter'] == false &&
              userDocument['packageDelivered'] == false) {
            /*DocumentReference documentReference = FirebaseFirestore.instance
                .collection('operationalcenter')
                .doc(userDocument['operationalcenterid']);
            documentReference.get().then((dataSnapshot) {
              print(dataSnapshot['name']);
              print(dataSnapshot['operationalcenterid']);
              print(dataSnapshot['latitude']);
              print(dataSnapshot['longitude']);
            });*/

            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.normal,
                    markers: _newMarkers,
                    polylines: _newPolylines,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(userDocument['pickuplatitude'],
                            userDocument['pickuplongitude']),
                        zoom: 14.47),
                    onMapCreated: (GoogleMapController controller) async {
                      changeMapMode();
                      _controller = controller;
                      _added = true;
                      _newMarkers.add(Marker(
                          markerId: MarkerId('id-3'),
                          position: LatLng(userDocument['driverlatitude'],
                              userDocument['driverlongitude']),
                          infoWindow: InfoWindow(title: 'Driver'),
                          icon: mapMarker));
                      _newMarkers.add(Marker(
                          markerId: MarkerId('id-4'),
                          position: LatLng(
                              operationalCenterLat, operationalCenterLan),
                          infoWindow: InfoWindow(title: 'Operational Center'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen)));
                      setNewPolylinesInMap(
                          userDocument['driverlatitude'],
                          userDocument['driverlongitude'],
                          operationalCenterLat,
                          operationalCenterLan);
                    },
                  );
            /*Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Package Picked Up"),
                      Text("${operationalCenterLat}"),
                      Text("${operationalCenterLan}")
                    ],
                  ));*/
          } else if (userDocument['pickupreqaccepted'] == true &&
              userDocument['packagePickedUp'] == true &&
              userDocument['packageDroppedOperationalCenter'] == true &&
              userDocument['packageLeftOperationalCenter'] == false &&
              userDocument['packageDelivered'] == false) {
            return Center(child: Text("Package Dropped At Operational Center"));
          } else if (userDocument['pickupreqaccepted'] == true &&
              userDocument['packagePickedUp'] == true &&
              userDocument['packageDroppedOperationalCenter'] == true &&
              userDocument['packageLeftOperationalCenter'] == true &&
              userDocument['packageDelivered'] == false) {
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.normal,
                    markers: _dropOffMarkers,
                    polylines: _dropOffPolylines,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(userDocument['dropofflatitude'],
                            userDocument['dropofflongitude'])),
                    onMapCreated: _dropOffOnMapCreated,
                  );
          } else {
            return Center(child: Text("Package Delivered"));
          }
          //return Text(userDocument['weight']);
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<DocumentSnapshot> snapshot) async {
    await _controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(snapshot.data!['driverlatitude'],
            snapshot.data!['driverlongitude']),
        14.47));
  }

  /*Future<void> myNewMap(AsyncSnapshot<DocumentSnapshot> snapshot) async {
    await _controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(snapshot.data!['driverlatitude'],
            snapshot.data!['driverlongitude']),
        14.47));
  }*/

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
