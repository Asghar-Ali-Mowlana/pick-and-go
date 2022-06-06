import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:universal_io/io.dart' as u;

import '../../services/routingpage.dart';
import 'widgets/navigationdrawerdriverdropofff.dart';

class DropoffDriverProfile extends StatefulWidget {
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
  final String? name;
  final String? email;
  final String? mobile;
  final String? address;

  DropoffDriverProfile({
    required this.id,
    this.operationalcenterid,
    this.driveroccupied,
    this.name,
    this.email,
    this.mobile,
    this.address,
  });
  @override
  _DropoffDriverProfileState createState() => _DropoffDriverProfileState();
}

class _DropoffDriverProfileState extends State<DropoffDriverProfile> {
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
        ?
   SafeArea(
            child: Scaffold(
              drawer: NavigationDrawerWidget(
                  id: widget.id, operationalcenterid: widget.operationalcenterid),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick&GO - Drop Off Driver'),
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
                        'Drop-Off Driver Profile',
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
                  id: widget.id, operationalcenterid: widget.operationalcenterid),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick&GO - Drop Off Driver'),
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
                          'Drop-Off Driver Profile',
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
                              controller: controllerName..text = "Ruzna",
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
                                ..text = "ruzna@gmail.com",
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
                              controller: controllerMobile..text = "075896478",
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
                              controller: controllerAddress
                                ..text = "Maligawatta",
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
