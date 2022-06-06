//import 'dart:async';

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickandgo/screens/user/sendpackage/customerPackagesList.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';

class ConfirmReceiverLocation extends StatefulWidget {
  final senderName;
  final senderEmail;
  final senderAddress;
  final senderPostalCode;
  final senderContactNo;
  final pickUpLatitude;
  final pickUpLongitude;
  final String packageDes;
  final String packageVehicleType;
  final double packageLength;
  final double packageHeight;
  final double packageWidth;
  final double packageWeight;
  ConfirmReceiverLocation(
      this.senderName,
      this.senderEmail,
      this.senderAddress,
      this.senderPostalCode,
      this.senderContactNo,
      this.pickUpLatitude,
      this.pickUpLongitude,
      this.packageDes,
      this.packageVehicleType,
      this.packageLength,
      this.packageHeight,
      this.packageWidth,
      this.packageWeight);
  //const ConfirmReceiverLocation({Key? key}) : super(key: key);

  @override
  State<ConfirmReceiverLocation> createState() =>
      _ConfirmReceiverLocationState();
}

class _ConfirmReceiverLocationState extends State<ConfirmReceiverLocation> {
  final loc.Location _location = loc.Location();
  Geolocator geolocator = Geolocator();

  late GoogleMapController _controller;

  var _addressController = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_addressController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyAipdvUyHCRoCoAh_WGiwEy7CY0rEXFFtw";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    changeMapMode();
    setState(() {
      _controller = controller;
      //_goToNewAddress(_locationResult.latitude, _locationResult.longitude);
    });
    _goTocurrentPosition();
  }

  /*_compareLocation() async {
    double distanceInMeters;
    List<double> operationalCenterDistance = <double>[];
    List<String> operationalCenterIdList = <String>[];
    String operationalCenterId;
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
    //print("The distance between the nearest operational center: ");
    //print(operationalCenterDistance
    //  .indexOf(operationalCenterDistance.reduce(min)));
    print("The nearest operational center ID: ");
    int shortestDistanceIndex = operationalCenterDistance
        .indexOf(operationalCenterDistance.reduce(min));
    print(operationalCenterIdList[shortestDistanceIndex]);
  }*/
  double totalCost = 0.0;

  var receiverLat;
  var receiverLan;

  late String pickUpAddress;

  _getTotalCost(pickUpLat, pickUpLan) async {
    double distanceCostPerKM;

    if (widget.packageVehicleType == "Bike") {
      distanceCostPerKM = 20;
    } else {
      distanceCostPerKM = 40;
    }

    double sizeOfThePackageInInches =
        widget.packageLength * widget.packageWeight * widget.packageHeight;
    double dimensionalWeightInPounds = sizeOfThePackageInInches / 139;
    double packageWeightInPounds = widget.packageWeight * 2.20462;
    double distanceInKm = Geolocator.distanceBetween(pickUpLat, pickUpLan,
            widget.pickUpLatitude, widget.pickUpLongitude) /
        1000;
    if (dimensionalWeightInPounds > packageWeightInPounds) {
      totalCost = ((dimensionalWeightInPounds * 20) +
              (distanceInKm * distanceCostPerKM))
          .ceilToDouble();
    } else {
      totalCost =
          ((packageWeightInPounds * 20) + (distanceInKm * distanceCostPerKM))
              .ceilToDouble();
    }
    //print("The total cost of the package: ");
    //print(totalCost);
  }

  Future<void> _goToNewAddress(lat, lan) async {
    await _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lan), 14.47));
    _markers
        .add(Marker(markerId: MarkerId('id-1'), position: LatLng(lat, lan)));
  }

  Future<void> _goTocurrentPosition() async {
    final loc.LocationData _locationResult = await _location.getLocation();
    var lat = _locationResult.latitude;
    var lan = _locationResult.longitude;
    _getTotalCost(lat, lan);
    _setCurrentPosition();
    setState(() {
      _markers.add(
          Marker(markerId: MarkerId('id-1'), position: LatLng(lat!, lan!)));
    });
    await _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat!, lan!), 14.47));
  }

  _setCurrentPosition() async {
    final loc.LocationData _locationResult = await _location.getLocation();
    receiverLat = _locationResult.latitude;
    receiverLan = _locationResult.longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(receiverLat, receiverLan);
    pickUpAddress = placemarks.first.street.toString() +
        ", " +
        placemarks.first.locality.toString() +
        ", " +
        placemarks.first.country.toString();
    print(placemarks.first.street.toString() +
        ", " +
        placemarks.first.locality.toString() +
        ", " +
        placemarks.first.country.toString());
  }

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

    try {
      await FirebaseFirestore.instance
          .collection('package')
          .doc(packageID)
          .set({
        'userid': user!.uid,
        'Vehicle Type': widget.packageVehicleType,
        'pickupdriverid': '',
        'deliverydriverid': '',
        'operationalCenterDriverId': '',
        'toOperationalCenterId': '',
        'driverlatitude': '',
        'driverlongitude': '',
        'packageid': packageID,
        'pickuplatitude': 6.958813,
        'pickuplongitude': 79.875363,
        'pickupAddress': "286, Muthuwella Mawatha, Colombo-15",
        'pickupreqaccepted': false,
        'packagePickedUp': false,
        'packageDroppedOperationalCenter': false,
        'packageDelivered': false,
        'packageLeftOperationalCenter': false,
        'operationalcenterid': "2rwXpc1t158ZliRNa8XQ",
        'dropofflatitude': 6.909447,
        'dropofflongitude': 79.868957,
        'receiverName': widget.senderName,
        'receiverAddress': "16 R.G. Senanayake Mawatha",
        'receiverContactNo': widget.senderContactNo,
        'receiverEmail': widget.senderEmail,
        'packageDescription': widget.packageDes,
        'packageWeight': widget.packageWeight,
        'totalCost': totalCost
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  /*_getLatLngFromAddress() async {
    List<Location> locations =
        await locationFromAddress("67 Mohamed Lane, Weligama");
    print(locations);
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

  Set<Marker> _markers = {};

  bool _changeAddressValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeMapMode();
    _addressController.addListener(() {
      _onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Confirmation"),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {
                _getLocation();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReceivedPackageList()));
                //_compareLocation();
              },
              //alignment: Alignment.topLeft,
            ),
            IconButton(
              icon: Icon(Icons.pending),
              onPressed: () {
                _setCurrentPosition();
                // _getTotalCost();
              },
              //alignment: Alignment.topLeft,
            ),
          ],
        ),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                    target: LatLng(6.96551, 79.8675395), zoom: 14.47),
                onMapCreated: _onMapCreated,
                //myLocationEnabled: true,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Your Address ",
                        enabled: true,
                        focusColor: Colors.white,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        //prefixIcon: Icon(Icons.map),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _addressController..text = "";
                          },
                        ),
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            /*Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => zecond(_placeList[index]["description"])));*/
                            List<Location> locations =
                                await locationFromAddress(
                                    _placeList[index]["description"]);
                            _addressController.text =
                                _placeList[index]["description"];
                            _getTotalCost(locations.first.latitude,
                                locations.first.longitude);
                            receiverLat = locations.first.latitude;
                            receiverLan = locations.first.longitude;
                            pickUpAddress = _placeList[index]["description"];
                            print("The total cost of the package: ");
                            print(totalCost);
                            _goToNewAddress(locations.first.latitude,
                                locations.first.longitude);
                            print("Latitude is: ${locations.first.latitude}");
                            print("Longitude is: ${locations.first.longitude}");
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: ListTile(
                                title: Text(_placeList[index]["description"]),
                                textColor: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Delivery Cost - LKR ${totalCost}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 18.0),
                            child: Text(
                              "Send packages to friends and family. Only accepting COD at the moment.",
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _getLocation();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReceivedPackageList()));
                            },
                            child: Text("Confirm"),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
