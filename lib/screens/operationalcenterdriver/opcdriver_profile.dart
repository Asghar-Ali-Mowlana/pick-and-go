import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/operationalcenterdriver/widgets/navigationdrawerpickupdriver.dart';
import 'package:universal_io/io.dart' as u;

import '../../services/routingpage.dart';

class OPCDriverProfile extends StatefulWidget {
  final _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();

  final String id;
  bool? driveroccupied;
  String? operationalcenterid;

  OPCDriverProfile({
    required this.id,
    required this.operationalcenterid,
    required this.driveroccupied,
  });
  @override
  _OPCDriverProfileState createState() => _OPCDriverProfileState();
}

class _OPCDriverProfileState extends State<OPCDriverProfile> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerMobile = TextEditingController();
  final controllerAddress = TextEditingController();
  DatabaseHelper _db = DatabaseHelper();

  bool _isLoading = true;

  late String name;
  late String email;
  late String mobile;
  late String address;


  getyo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((value) {

      name = value.data()!['name'];
      email = value.data()!['email'];
      mobile = value.data()!['mobile'];
      address = value.data()!['address'];
    });
  }

  @override
  void initState() {
getyo();

Future.delayed(Duration(seconds: 2), () {
  setState(() {
    _isLoading = false;
  });
});

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ?   SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget(
            id: widget.id, operationalcenterid: widget.operationalcenterid),
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Pick&GO - Operational Center Driver'),
        ),
        body:
        (_isLoading)
            ?
        Center(
          child: CircularProgressIndicator(),
        ):
        Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(1),
                child: Text(
                  'Operational Center Driver Profile',
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextField(
                      controller: controllerName..text = name,
                      decoration: InputDecoration(
                        labelText: "Name",
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controllerEmail
                        ..text = email,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controllerMobile..text = mobile,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controllerAddress..text = address,
                      decoration: InputDecoration(
                        labelText: "Address",
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    MaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        elevation: 5.0,
                        height: 45,
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.id);
                          docUser.update({
                            'name': controllerName.text,
                            'email': controllerEmail.text,
                            'mobile': controllerMobile.text,
                            'address': controllerAddress.text,
                          });
                          const snackBar = SnackBar(
                            content: Text(
                                'User Profile has been Updated Sucessfully....',
                                style: TextStyle(
                                    color: Colors.lightGreenAccent)),
                          );
                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutePage(),
                            ),
                          );
                        },
                        color: Colors.black,
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        : SafeArea(
            child: Scaffold(
              drawer: NavigationDrawerWidget(
                id: widget.id,
                driveroccupied: widget.driveroccupied,
                operationalcenterid: widget.operationalcenterid,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick&GO - Operational Center Driver'),
              ),
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Text(
                          'Driver Profile',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: <Widget>[
                            TextField(
                              controller: controllerName..text = "Sonali",
                              decoration: InputDecoration(
                                labelText: "Name",
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: controllerEmail
                                ..text = "sonali@gmail.com",
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: controllerMobile..text = "0785957458",
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: controllerAddress..text = "Gampaha",
                              decoration: InputDecoration(
                                labelText: "Address",
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            MaterialButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                elevation: 5.0,
                                height: 45,
                                onPressed: () {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.id);
                                  docUser.update({
                                    'name': controllerName.text,
                                    'email': controllerEmail.text,
                                    'mobile': controllerMobile.text,
                                    'address': controllerAddress.text,
                                  });
                                  const snackBar = SnackBar(
                                    content: Text(
                                        'User Profile has been Updated Sucessfully....',
                                        style: TextStyle(
                                            color: Colors.lightGreenAccent)),
                                  );
                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RoutePage(),
                                    ),
                                  );
                                },
                                color: Colors.black,
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
