import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/user/recievepackage/senderPackageDetails.dart';
import 'package:pickandgo/screens/user/sendpackage/packagedetails.dart';
import 'package:pickandgo/services/routingpage.dart';
import 'package:universal_io/io.dart' as u;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SenderDetails extends StatefulWidget {
  const SenderDetails({Key? key}) : super(key: key);

  @override
  State<SenderDetails> createState() => _SenderDetailsState();
}

class _SenderDetailsState extends State<SenderDetails> {
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController recNameController = TextEditingController();
  final TextEditingController recEmailController = TextEditingController();
  final TextEditingController recAddressController = TextEditingController();
  final TextEditingController recPostalCodeController = TextEditingController();
  final TextEditingController recContactController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  DatabaseHelper _db = DatabaseHelper();

  var _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  late double dropOffLatitude;
  late double dropOffLongitude;

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
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

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick Up Request'),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => RoutePage(),
                          ),
                        );
                      },
                      // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _db.logout(context);
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => RoutePage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              //body: ReceiverDetailsForm(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white10,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1.15,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(22),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Column(
                                    children: const <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(1),
                                        child: Text(
                                          'Who is sending the package?',
                                          style: TextStyle(fontSize: 40.0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'The driver may contact the sender to pickup the package.',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  controller: recNameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Sender Name',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Sender name cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recNameController.text = value!;
                                    // setState(() {
                                    //   recNameController.text = value!;
                                    // });
                                  },
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: recEmailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Sender Email',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Sender email cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recEmailController.text = value!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                /*TextFormField(
                                  controller: recAddressController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Receiver Address',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Receiver address cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recAddressController.text = value!;
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),*/
                                TextFormField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Sender Address",
                                    enabled: true,
                                    focusColor: Colors.white,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    //prefixIcon: Icon(Icons.map),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        _controller..text = "";
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Sender address cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    _controller.text = value!;
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
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
                                                _placeList[index]
                                                    ["description"]);
                                        _controller.text =
                                            _placeList[index]["description"];
                                        dropOffLatitude =
                                            locations.first.latitude;
                                        dropOffLongitude =
                                            locations.first.longitude;
                                        print(
                                            "Latitude is: ${locations.first.latitude}");
                                        print(
                                            "Longitude is: ${locations.first.longitude}");
                                      },
                                      child: ListTile(
                                        title: Text(
                                            _placeList[index]["description"]),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: recPostalCodeController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Sender Postal Code',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Sender postal code cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recPostalCodeController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: recContactController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Sender Contact No',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Sender contact number cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recContactController.text = value!;
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          _formkey.currentState!.save();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SenderPackageDetails(
                                                      recNameController.text,
                                                      recEmailController.text,
                                                      _controller.text,
                                                      recPostalCodeController
                                                          .text,
                                                      recContactController.text,
                                                      dropOffLatitude,
                                                      dropOffLongitude),
                                            ),
                                          );
                                        }
                                      },
                                      color: Colors.black,
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick Up Request'),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => RoutePage(),
                        ),
                      );
                    },
                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _db.logout(context);
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => RoutePage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            //body: ReceiverDetailsForm(),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white10,
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Center(
                        child: Container(
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(1),
                                        child: Text(
                                          'Who is receiving the package?',
                                          style: TextStyle(fontSize: 40.0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'The driver may contact the recipient to complete the delivery.',
                                        style: TextStyle(fontSize: 17.0),
                                      )
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                //Text('${widget.receiverName}'),
                                TextFormField(
                                  controller: recNameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Receiver Name',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Receiver name cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recNameController.text = value!;
                                    // setState(() {
                                    //   recNameController.text = value!;
                                    // });
                                  },
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                TextFormField(
                                  controller: recEmailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Receiver Email',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Receiver email cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recEmailController.text = value!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: recAddressController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Receiver Address',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Receiver address cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recAddressController.text = value!;
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: recPostalCodeController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Receiver Postal Code',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Receiver postal code cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recPostalCodeController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: recContactController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Receiver Contact No',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Receiver name cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    recContactController.text = value!;
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          _formkey.currentState!.save();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PackageDetails(
                                                      recNameController.text,
                                                      recEmailController.text,
                                                      recAddressController.text,
                                                      recPostalCodeController
                                                          .text,
                                                      recContactController.text,
                                                      dropOffLatitude,
                                                      dropOffLongitude),
                                            ),
                                          );
                                        }
                                      },
                                      color: Colors.black,
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
