import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickandgo/screens/loginpage.dart';
import 'package:pickandgo/screens/receivertracking.dart';
import 'package:pickandgo/screens/user/sendpackage/customerTrackingWeb.dart';
import 'package:universal_io/io.dart' as u;

import '../../../databasehelper.dart';

class TrackPackage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  _TrackPackageState createState() => _TrackPackageState();
}

class _TrackPackageState extends State<TrackPackage> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _id = TextEditingController();

  final formKey = GlobalKey<FormState>();
  DatabaseHelper _db = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final controllers = TextEditingController();
    return (u.Platform.operatingSystem == "android")
        ? Scaffold(
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
                          builder: (_) => LoginPage(),
                        ),
                      );
                    },
                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                    child: Center(
                      child: Image(
                        width: 200,
                        height: 200,
                        image: AssetImage('assets/trackpackage.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pick & go',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Text(
                      "Pick & Go is Sri Lanka's no 01 unique delivery service. We offering the cheapest, quickest and safest service in door to door delivery.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Enter tracking code",
                          fillColor: Colors.white70),
                      controller: controllers,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 380,
                    height: 50,
                    color: Colors.white,
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.black)))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ReceiverTracking(controllers.text)));
                      },
                      child: const Text(
                        'Track',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
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
                          builder: (_) => LoginPage(),
                        ),
                      );
                    },
                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                    child: Center(
                      child: Image(
                        width: 200,
                        height: 200,
                        image: AssetImage('assets/trackpackage.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pick & go',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Text(
                      "Pick & Go is Sri Lanka's no 01 unique delivery service. We offering the cheapest, quickest and safest service in door to door delivery.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _id,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Package ID is missing';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Enter tracking code (Order ID)",
                              fillColor: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 320,
                    height: 50,
                    color: Colors.white54,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.black)))),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Track(
                                        id: _id.text,
                                      )));
                        }
                      },
                      child: const Text(
                        'Track',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )
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
