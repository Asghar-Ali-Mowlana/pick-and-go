import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickandgo/screens/pickupdriver/pickuprequests.dart';
import 'package:pickandgo/services/google_map_api.dart';


class MyMap extends StatefulWidget {
  final String packageid;
  LatLng pickupdestination;


  final String id;
  final String? operationalcenterid;
  final bool? driveroccupied;
  String? cusid;
  String? vehicletype;

  MyMap(
      this.packageid,
      this.pickupdestination,
      this.id,

      this.operationalcenterid,
      this.driveroccupied,
      this.cusid,
      this.vehicletype);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  BitmapDescriptor? icon;

  LocationData? currentLocation;

  Set<Polyline> _polylines = Set<Polyline>();

  Set<Polyline> _packagedroppedpolylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;

  double? operationalcenterlat;
  double? operationalcenterlong;

  String? cusname;
  String? cusnumber;

  StreamSubscription<loc.LocationData>? _locationSubscription;

  changeMapMode() {
    getJsonFile('assets/mapstyle.json').then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  getyo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((driver) {
      FirebaseFirestore.instance
          .collection('operationalcenter')
          .doc(driver.data()!['operationalcenterid'])
          .get()
          .then((value) {
        operationalcenterlat = value.data()!['latitude'] == null
            ? 0.0
            : value.data()!['latitude'].toDouble();
        operationalcenterlong = value.data()!['longitude'] == null
            ? 0.0
            : value.data()!['longitude'].toDouble();
      });
    });
  }

  getcusdetailsl() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.cusid)
        .get()
        .then((value) {
      cusname = value.data()!['name'].toString();
      cusnumber = value.data()!['mobile'].toString();
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
          .doc(widget.packageid)
          .set({
        'driverlatitude': currentlocation.latitude,
        'driverlongitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });

    // _locationSubscription = location.onLocationChanged.listen((clocation) {
    //   currentLocation = clocation;
    //
    // });
  }

  void setPolylinesInMap() async {
    //var xy = currentLocation;

    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      PointLatLng(widget.pickupdestination.latitude,
          widget.pickupdestination.longitude),
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
    print("woky ${result.points}");
    if (currentLocation == null) {
      print("sucks man");
    } else {
      print("oi man");
    }
  }

  void showLocationPins() {
    setPolylinesInMap();
    //setPackageDroppedPolylinesInMap();
  }

  void showPickedUpLocationPins() {
    setPackageDroppedPolylinesInMap();
  }

  void setPackageDroppedPolylinesInMap() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      PointLatLng(operationalcenterlat!, operationalcenterlong!),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _packagedroppedpolylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.black,
        points: polylineCoordinates,
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

// Cargar imagen del Marker
  getIcons() async {
    if (widget.vehicletype == "Lorry") {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/lorrys.png', 150);
      setState(() {
        this.icon = BitmapDescriptor.fromBytes(markerIcon);
      });
    }
    if (widget.vehicletype == "Bike") {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/bike.png', 150);
      setState(() {
        this.icon = BitmapDescriptor.fromBytes(markerIcon);
      });
    } else {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/lorrys.png', 150);
      setState(() {
        this.icon = BitmapDescriptor.fromBytes(markerIcon);
      });
    }
  }

  late StreamSubscription<LocationData> subscription;

  bool _isLoading = true;

  @override
  void initState() {
    getcusdetailsl();
    changeMapMode();
    getyo();
    setPolylinesInMap();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    //_requestPermission();
    location.changeSettings(
        interval: 2300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    _listenLocation();
    polylinePoints = PolylinePoints();
    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
    });

    getIcons();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var x = icon;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            body: (x == null || _isLoading == true)
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('package')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (_added) {
                        mymap(snapshot);
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return (snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)['packagePickedUp'] !=
                              true)
                          ? Stack(
                              children: <Widget>[
                                GoogleMap(
                                  mapType: MapType.normal,
                                  polylines: _polylines,
                                  myLocationButtonEnabled: true,
                                  compassEnabled: true,
                                  markers: {
                                    Marker(
                                        //rotation:-45,
                                        position: LatLng(
                                          snapshot.data!.docs.singleWhere(
                                                  (element) =>
                                                      element.id ==
                                                      widget.packageid)[
                                              'driverlatitude'],
                                          snapshot.data!.docs.singleWhere(
                                                  (element) =>
                                                      element.id ==
                                                      widget.packageid)[
                                              'driverlongitude'],
                                        ),
                                        markerId: MarkerId('id'),
                                        icon: x),
                                    Marker(
                                      position: LatLng(
                                        widget.pickupdestination.latitude,
                                        widget.pickupdestination.longitude,
                                      ),
                                      markerId: MarkerId('idd'),
                                    ),
                                  },
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        snapshot.data!.docs.singleWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget.packageid)[
                                            'driverlatitude'],
                                        snapshot.data!.docs.singleWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget.packageid)[
                                            'driverlongitude'],
                                      ),
                                      zoom: 14.47),
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    changeMapMode();

                                    _controller = controller;
                                    _added = true;
                                    showLocationPins();
                                    setState(() {});
                                  },
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    iconSize: 20.0,
                                    onPressed: () {
                                      _stopListening();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PickupDriverPickupRequests(
                                                    id: widget.id,
                                                    driveroccupied: true,
                                                    operationalcenterid: widget
                                                        .operationalcenterid,

                                                  )));
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MaterialButton(
                                      color: Colors.black,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        _stopListening();
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         MyApp()));
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyMap(
                                                        widget.packageid,
                                                        widget.pickupdestination,
                                                        widget.id,

                                                        widget.operationalcenterid,
                                                        widget.driveroccupied,
                                                        widget.cusid,
                                                        widget.vehicletype)));
                                        FirebaseFirestore.instance
                                            .collection('package')
                                            .doc(widget.packageid)
                                            //update method
                                            .update({
                                          //add the user id inside the favourites array
                                          "packagePickedUp": true
                                        });
                                      },
                                      child: Text("Picked up")),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 28.0),
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(Icons.expand_more),
                                            iconSize: 40.0,
                                            onPressed: () {
                                              //_stopListening();
                                              showModalBottomSheet<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height: 200,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .account_circle_sharp),
                                                                  iconSize:
                                                                      30.0,
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                Text(
                                                                    "${cusname}"),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .phone),
                                                                  iconSize:
                                                                      30.0,
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                Text(
                                                                    "${cusnumber}"),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .location_on),
                                                                  iconSize:
                                                                      30.0,
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                Text(
                                                                    "${snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)['pickupAddress'].toString()}"),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                        Text(
                                          "More",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)['packagePickedUp'] == true &&
                                      snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)[
                                              'packageDroppedOperationalCenter'] ==
                                          false &&
                                      operationalcenterlong == null ||
                                  snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)['packagePickedUp'] == true &&
                                      snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)[
                                              'packageDroppedOperationalCenter'] ==
                                          false &&
                                      operationalcenterlat == null)
                              ? Center(
                                  child: CircularProgressIndicator(
                                  value: 0.8,
                                ))
                              : (snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)['packagePickedUp'] == true &&
                                      snapshot.data!.docs.singleWhere(
                                              (element) => element.id == widget.packageid)['packageDroppedOperationalCenter'] ==
                                          false &&
                                      operationalcenterlong != null &&
                                      operationalcenterlat != null)
                                  ? Stack(
                                      children: <Widget>[
                                        GoogleMap(
                                          mapType: MapType.normal,
                                          polylines: _packagedroppedpolylines,
                                          myLocationButtonEnabled: true,
                                          compassEnabled: true,
                                          markers: {
                                            Marker(
                                                //rotation:-45,
                                                position: LatLng(
                                                  snapshot.data!.docs.singleWhere(
                                                          (element) =>
                                                              element.id ==
                                                              widget.packageid)[
                                                      'driverlatitude'],
                                                  snapshot.data!.docs.singleWhere(
                                                          (element) =>
                                                              element.id ==
                                                              widget.packageid)[
                                                      'driverlongitude'],
                                                ),
                                                markerId: MarkerId('id'),
                                                icon: x),
                                            Marker(
                                              position: LatLng(
                                                operationalcenterlat!,
                                                operationalcenterlong!,
                                              ),
                                              markerId: MarkerId('idd'),
                                            ),
                                          },
                                          initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                snapshot.data!.docs.singleWhere(
                                                        (element) =>
                                                            element.id ==
                                                            widget.packageid)[
                                                    'driverlatitude'],
                                                snapshot.data!.docs.singleWhere(
                                                        (element) =>
                                                            element.id ==
                                                            widget.packageid)[
                                                    'driverlongitude'],
                                              ),
                                              zoom: 14.47),
                                          onMapCreated: (GoogleMapController
                                              controller) async {
                                            changeMapMode();

                                            _controller = controller;
                                            _added = true;
                                            showPickedUpLocationPins();
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_back_ios),
                                            iconSize: 20.0,
                                            onPressed: () {
                                              _stopListening();
                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         MyApp()));
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PickupDriverPickupRequests(

                                                            id: widget.id,
                                                            driveroccupied: true,
                                                            operationalcenterid: widget
                                                                .operationalcenterid,

                                                            //     id: id,
                                                          )));
                                            },
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: MaterialButton(
                                              color: Colors.black,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                //_stopListening();
                                                // Navigator.of(context).push(MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         MyApp()));
                                                FirebaseFirestore.instance
                                                    .collection('package')
                                                    .doc(widget.packageid)
                                                    //update method
                                                    .update({
                                                  //add the user id inside the favourites array
                                                  "packageDroppedOperationalCenter":
                                                      true,
                                                });

                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(widget.id)
                                                    //update method
                                                    .update({
                                                  //add the user id inside the favourites array
                                                  "driveroccupied": false,
                                                  "packageid": "",
                                                });

                                                _stopListening();

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PickupDriverPickupRequests(

                                                              id: widget.id,
                                                              driveroccupied: true,
                                                              operationalcenterid: widget
                                                                  .operationalcenterid,

                                                              //     id: id,
                                                            )));

                                                print("Package dropped at operational center, Package ID: ${widget.packageid}");
                                                print("Package dropped at operational center, Operational Center ID: ${widget.operationalcenterid}");
                                              },
                                              child: Text("Package Dropped")),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 28.0),
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(
                                                    icon:
                                                        Icon(Icons.expand_more),
                                                    iconSize: 40.0,
                                                    onPressed: () {
                                                      _stopListening();
                                                      showModalBottomSheet<
                                                          void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            height: 200,
                                                            color: Colors.white,
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                          icon:
                                                                              Icon(Icons.account_circle_sharp),
                                                                          iconSize:
                                                                              30.0,
                                                                          onPressed:
                                                                              () {},
                                                                        ),
                                                                        Text(
                                                                            "${cusname}"),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                          icon:
                                                                              Icon(Icons.phone),
                                                                          iconSize:
                                                                              30.0,
                                                                          onPressed:
                                                                              () {},
                                                                        ),
                                                                        Text(
                                                                            "${cusnumber}"),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                          icon:
                                                                              Icon(Icons.location_on),
                                                                          iconSize:
                                                                              30.0,
                                                                          onPressed:
                                                                              () {},
                                                                        ),
                                                                        Text(
                                                                            "${snapshot.data!.docs.singleWhere((element) => element.id == widget.packageid)['pickupAddress'].toString()}"),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                Text(
                                                  "More",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Text("Error"),
                                    );
                    },
                  )),
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere((element) =>
                  element.id == widget.packageid)['driverlatitude'],
              snapshot.data!.docs.singleWhere((element) =>
                  element.id == widget.packageid)['driverlongitude'],
            ),
            zoom: 14.47)));
  }

  _stopListening() {
    _locationSubscription?.cancel();
    subscription.cancel();
    setState(() {
      _locationSubscription = null;
      print("argh stop $_locationSubscription");
    });
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

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
