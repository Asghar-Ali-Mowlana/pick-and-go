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

import 'package:universal_io/io.dart' as u;

import 'package:permission_handler/permission_handler.dart';
//import 'package:pickandgo/screens/CustomerPackagesList.dart';
//import 'package:pickandgo/screens/CustomerDriverTrack.dart';
//import 'package:pickandgo/screens/CustomerWaitForDriver.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geocoding/geocoding.dart';

// 1 Pound - Rs 20
// 1KM - Rs 40 for Lorry
// 1km - Rs 20 for Bike
// Dim divisor = 139 inches per pound
// SizeOfThePackage = L(inches) * W(inches) * H(inches)
// DimensionalWeightInPounds = SizeOfThePackage / 139 (Dim divisor)
// PackageWeightInPounds = PackageweightInKg * 2.20462
// Get the highest value between DimensionalWeightInPounds and PackageWeightInPounds
// Total Cost = (DimensionalWeightInPounds or PackageWeightInPounds * 20) + (DistanceInKm * 40)

class CustomerLocationTrack extends StatefulWidget {
  final receiverName;
  final receiverEmail;
  final receiverAddress;
  final receiverPostalCode;
  final receiverContactNo;
  final dropOffLatitude;
  final dropOffLongitude;
  final String packageDes;
  final String packageVehicleType;
  final double packageLength;
  final double packageHeight;
  final double packageWidth;
  final double packageWeight;
  CustomerLocationTrack(
      this.receiverName,
      this.receiverEmail,
      this.receiverAddress,
      this.receiverPostalCode,
      this.receiverContactNo,
      this.dropOffLatitude,
      this.dropOffLongitude,
      this.packageDes,
      this.packageVehicleType,
      this.packageLength,
      this.packageHeight,
      this.packageWidth,
      this.packageWeight);
  //const CustomerLocationTrack({Key? key}) : super(key: key);

  @override
  State<CustomerLocationTrack> createState() => CustomerLocationTrackState();
}

@visibleForTesting
class CustomerLocationTrackState extends State<CustomerLocationTrack> {
  final loc.Location _location = loc.Location();
  Geolocator geolocator = Geolocator();

  late GoogleMapController _controller;

  var _addressController = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  final TextEditingController addressController = TextEditingController();

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

  var customerPickUpLat;
  var customerPickUpLan;

  late String pickUpAddress;

  getTotalCost(pickUpLat, pickUpLan) async {
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
            widget.dropOffLatitude, widget.dropOffLongitude) /
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
    getTotalCost(lat, lan);
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
    customerPickUpLat = _locationResult.latitude;
    customerPickUpLan = _locationResult.longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(customerPickUpLat, customerPickUpLan);
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
        'pickuplatitude': u.Platform.operatingSystem == 'android'
            ? customerPickUpLat
            : 5.9756851,
        'pickuplongitude': u.Platform.operatingSystem == 'android'
            ? customerPickUpLan
            : 80.4313126,
        'pickupAddress': u.Platform.operatingSystem == 'android'
            ? pickUpAddress
            : "64 Sri Wajiragnana Nahimi Mawatha, Weligama, Sri Lanka",
        'pickupreqaccepted': false,
        'packagePickedUp': false,
        'packageDroppedOperationalCenter': false,
        'packageDelivered': false,
        'packageLeftOperationalCenter': false,
        'operationalcenterid': operationalCenterId,
        'dropofflatitude': widget.dropOffLatitude,
        'dropofflongitude': widget.dropOffLongitude,
        'receiverName': widget.receiverName,
        'receiverAddress': widget.receiverAddress,
        'receiverContactNo': widget.receiverContactNo,
        'receiverEmail': widget.receiverEmail,
        'packageDescription': widget.packageDes,
        'packageWeight': widget.packageWeight,
        'totalCost': totalCost
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
    print("Package created successfully");
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
    if (u.Platform.operatingSystem == 'android') {
      changeMapMode();
      _addressController.addListener(() {
        _onChanged();
      });
    } else {
      getTotalCost(5.9756851, 80.4313126);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == 'android')
        ? SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text("Confirmation"),
                  backgroundColor: Colors.black,
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
                                hintText: "Enter Your Address",
                                enabled: true,
                                focusColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 15.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                                    List<Location> locations =
                                        await locationFromAddress(
                                            _placeList[index]["description"]);
                                    _addressController.text =
                                        _placeList[index]["description"];
                                    getTotalCost(locations.first.latitude,
                                        locations.first.longitude);
                                    customerPickUpLat =
                                        locations.first.latitude;
                                    customerPickUpLan =
                                        locations.first.longitude;
                                    pickUpAddress =
                                        _placeList[index]["description"];
                                    print("The total cost of the package: ");
                                    print(totalCost);
                                    _goToNewAddress(locations.first.latitude,
                                        locations.first.longitude);
                                    print(
                                        "Latitude is: ${locations.first.latitude}");
                                    print(
                                        "Longitude is: ${locations.first.longitude}");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: ListTile(
                                        title: Text(
                                            _placeList[index]["description"]),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 16.0, 0.0, 18.0),
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
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )))
        : SafeArea(
            child: Scaffold(
            appBar: AppBar(
              title: Text("Confirmation"),
              backgroundColor: Colors.black87,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white10,
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.90,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(22),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: addressController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter Your Address',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.green),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Location address cannot be empty";
                                  }
                                },
                                onSaved: (value) {
                                  addressController.text = value!;
                                },
                                keyboardType: TextInputType.text,
                              ),
                              Container(
                                height: 300,
                                width: 900,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Delivery Cost - LKR ${totalCost}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 16.0, 0.0, 18.0),
                                      child: Text(
                                        "Send packages to friends and family. Only accepting COD at the moment.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
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
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
  }
}
