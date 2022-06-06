import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/services/routingpage.dart';
import 'package:universal_io/io.dart' as u;

import '../../databasehelper.dart';

class ViewCustomerDetails extends StatefulWidget {
  String? uid;
  String? operationalcenterid;
  String? email;
  String? name;
  String? mobile;
  String? status;

  ViewCustomerDetails(this.uid, this.operationalcenterid, this.name, this.email,
      this.mobile, this.status);

  //const ViewRecipeDetails({Key? key}) : super(key: key);
  bool showProgress = false;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController statusController = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  @override
  _ViewCustomerDetailsState createState() => _ViewCustomerDetailsState();
}

class _ViewCustomerDetailsState extends State<ViewCustomerDetails> {
  //List items = [];
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerMobile = TextEditingController();
  final controllerStatus = TextEditingController();

  DatabaseHelper _db = DatabaseHelper();

  String dropdownValue = "Active";

  @override
  void initState() {
    // TODO: implement initState
    dropdownValue = widget.status!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('View Customer Details'),
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
              body: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(1),
                      child: Text(
                        'Customer Details',
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
                            readOnly: true,
                            controller: controllerName..text = widget.name!,
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
                            readOnly: true,
                            controller: controllerEmail..text = widget.email!,
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
                            readOnly: true,
                            controller: controllerMobile..text = widget.mobile!,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Active',
                                'Blocked'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
                              height: 40,
                              onPressed: () {
                                final docUser = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.uid);
                                docUser.update({
                                  'status': dropdownValue,
                                });
                                print("Customer Account Status Updated, ID: ${widget.uid}");
                                print("Customer Account Status Updated, Status: $dropdownValue");

                                const snackBar = SnackBar(
                                  content: Text(
                                      'Customer Details has been Updated Successfully....',
                                      style: TextStyle(
                                          color: Colors.lightGreenAccent)),
                                );
                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => OPHomepage(),
                                //   ),
                                // );
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
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('View Customer Details'),
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
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(1),
                        child: Text(
                          'Customer Details',
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
                              readOnly: true,
                              controller: controllerName..text = widget.name!,
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
                              readOnly: true,
                              controller: controllerEmail..text = widget.email!,
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
                              readOnly: true,
                              controller: controllerMobile
                                ..text = widget.mobile!,
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Active',
                                  'Blocked'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
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
                                height: 40,
                                onPressed: () {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.uid);
                                  docUser.update({
                                    'status': dropdownValue,
                                  });
                                  const snackBar = SnackBar(
                                    content: Text(
                                        'Customer Details has been Updated Successfully....',
                                        style: TextStyle(
                                            color: Colors.lightGreenAccent)),
                                  );
                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => OPHomepage(),
                                  //   ),
                                  // );
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
