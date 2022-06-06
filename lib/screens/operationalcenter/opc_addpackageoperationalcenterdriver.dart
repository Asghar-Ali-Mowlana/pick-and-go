import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as u;

import '../../../databasehelper.dart';

class AddPackagesOperationalCenterDriver extends StatefulWidget {
  String id;
  String operactionalCenterId;
  String driverId;

  //const AddPackagesOperationalCenterDriver({Key? key}) : super(key: key);

  AddPackagesOperationalCenterDriver(
    this.id,
    this.operactionalCenterId,
    this.driverId,
  );

  @override
  State<AddPackagesOperationalCenterDriver> createState() =>
      _AddPackagesOperationalCenterDriverState();
}

class _AddPackagesOperationalCenterDriverState
    extends State<AddPackagesOperationalCenterDriver> {
  DatabaseHelper _db = DatabaseHelper();
  final controllers = TextEditingController();
  final opCenterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
            resizeToAvoidBottomInset: false,
            //drawer:
            //  NavigationDrawerWidgetCenter(widget.id, widget.operationalcenterid),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Operational Center'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: Text(
                        'Package Details',
                        style: TextStyle(
                            fontSize: 28.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: controllers,
                        decoration: InputDecoration(
                          labelText: "Package ID..",
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              controllers..text = "";
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Package ID cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          controllers.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                        minWidth: 160,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          // //assign the package id into a list
                          //var list = [controllers.text];
                          FirebaseFirestore.instance
                              .collection('users')
                              //pass the driver id to know which document/record to update
                              .doc(widget.driverId)
                              //update method
                              .update({
                            //add the details inside the packages/orders array
                            "packages":
                                FieldValue.arrayUnion([controllers.text])
                          });
                          print(
                              "Driver assigned succesfully, Driver ID: ${widget.driverId}");
                          print(
                              "Package assigned to driver succesfully, Package ID: 38ef7cd6-dee0-4fca-91ba-477b8924b78a");
                          //controllers.text = "";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                              children: const [
                                Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                    child: Text('Package Added Successfully!')),
                              ],
                            ),
                          ));
                          FirebaseFirestore.instance
                              .collection('package')
                              //pass the package id to know which document/record to update
                              .doc(controllers.text)
                              //update method
                              .update({
                            //update id
                            "operationalCenterDriverId": widget.driverId
                          });
                        },
                        color: Colors.black,
                        child: const Text(
                          '+ Add Package',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: Text(
                        'Operational Center',
                        style: TextStyle(
                            fontSize: 28.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: opCenterController,
                        decoration: InputDecoration(
                          labelText: "Operational Center ID..",
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              opCenterController..text = "";
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Operational ID cannot be empty";
                          }
                        },
                        onSaved: (value) {
                          opCenterController.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                        minWidth: 160,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          // //assign the package id into a list
                          //var list = [controllers.text];
                          FirebaseFirestore.instance
                              .collection('users')
                              //pass the driver id to know which document/record to update
                              .doc(widget.driverId)
                              //update method
                              .update({
                            //add the details inside the packages/orders array
                            "toOperationalCenterId": opCenterController.text
                          });
                          print(
                              "Destination Added Successfully, Package: ${opCenterController.text}");
                          //controllers.text = "";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                              children: const [
                                Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                    child: Text(
                                        'Destination Assigned Successfully!')),
                              ],
                            ),
                          ));
                        },
                        color: Colors.black,
                        child: const Text(
                          'Assign Destination',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ))
        : SafeArea(
            child: Scaffold(
            resizeToAvoidBottomInset: false,
            //drawer:
            //  NavigationDrawerWidgetCenter(widget.id, widget.operationalcenterid),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Operational Center'),
            ),
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: Text(
                            'Package Details',
                            style: TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: controllers,
                            decoration: InputDecoration(
                              labelText: "Package ID..",
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
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  controllers..text = "";
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Package ID cannot be empty";
                              }
                            },
                            onSaved: (value) {
                              controllers.text = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            minWidth: 160,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            onPressed: () {
                              // //assign the package id into a list
                              //var list = [controllers.text];
                              FirebaseFirestore.instance
                                  .collection('users')
                                  //pass the driver id to know which document/record to update
                                  .doc(widget.driverId)
                                  //update method
                                  .update({
                                //add the details inside the packages/orders array
                                "packages":
                                    FieldValue.arrayUnion([controllers.text])
                              });
                              print(
                                  "Package Added Successfully, Package: ${controllers.text}");
                              //controllers.text = "";
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.playlist_add_check,
                                      color: Colors.greenAccent,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Text(
                                            'Package Added Successfully!')),
                                  ],
                                ),
                              ));
                              FirebaseFirestore.instance
                                  .collection('package')
                                  //pass the package id to know which document/record to update
                                  .doc(controllers.text)
                                  //update method
                                  .update({
                                //update id
                                "operationalCenterDriverId": widget.driverId
                              });
                            },
                            color: Colors.black,
                            child: const Text(
                              '+ Add Package',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: Text(
                            'Operational Center',
                            style: TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: opCenterController,
                            decoration: InputDecoration(
                              labelText: "Operational Center ID..",
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
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  opCenterController..text = "";
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Operational ID cannot be empty";
                              }
                            },
                            onSaved: (value) {
                              opCenterController.text = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            minWidth: 160,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            onPressed: () {
                              // //assign the package id into a list
                              //var list = [controllers.text];
                              FirebaseFirestore.instance
                                  .collection('users')
                                  //pass the driver id to know which document/record to update
                                  .doc(widget.driverId)
                                  //update method
                                  .update({
                                //add the details inside the packages/orders array
                                "toOperationalCenterId": opCenterController.text
                              });
                              print(
                                  "Destination Added Successfully, Package: ${opCenterController.text}");
                              //controllers.text = "";
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.playlist_add_check,
                                      color: Colors.greenAccent,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Text(
                                            'Destination Assigned Successfully!')),
                                  ],
                                ),
                              ));
                            },
                            color: Colors.black,
                            child: const Text(
                              'Assign Destination',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
  }
}
