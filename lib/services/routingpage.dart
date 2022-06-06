import 'package:pickandgo/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/dropoffdriver/dropoffdriverdashboard.dart';
import 'package:pickandgo/screens/dropoffdriver/dropoffdriverdroppackageonreceiver.dart';
import 'package:pickandgo/screens/operationalcenterdriver/opcdriver_DriverPackagesDropped.dart';
import 'package:pickandgo/screens/operationalcenterdriver/opcdriver_dashboard.dart';
import 'package:pickandgo/screens/pickupdriver/pickupdriverdashboard.dart';
import 'package:pickandgo/screens/pickupdriver/pickuprequests.dart';
import 'package:pickandgo/screens/operationalcenter/opc_dashboard.dart';
import 'package:pickandgo/screens/operationalcenter/opc_assigndropoffdriver.dart';
import 'package:pickandgo/screens/user/homepage.dart';

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  _RoutePageState();

  @override
  Widget build(BuildContext context) {
    return contro();
  }
}

class contro extends StatefulWidget {
  contro();

  @override
  _controState createState() => _controState();
}

class _controState extends State<contro> {
  _controState();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var role;
  var emaill;
  var id;
  var driveroccupied;
  var operationalcenterid;

  @override
  void initState() {
    if (user?.uid != null) {
      super.initState();
      FirebaseFirestore.instance
          .collection("users") //.where('uid', isEqualTo: user!.uid)
          .doc(user?.uid)
          .get()
          .then((value) {
        this.loggedInUser = UserModel.fromMap(value.data());
      }).whenComplete(() {
        CircularProgressIndicator();
        if (this.mounted) {
          setState(() {
            emaill = loggedInUser.email.toString();
            role = loggedInUser.role.toString();
            id = loggedInUser.uid.toString();
            driveroccupied = loggedInUser.driveroccupied;
            operationalcenterid = loggedInUser.operationalcenterid.toString();
          });
        }
      });
    }
  }

  routing() {
    return (role == "OperationalCenter")
        ? Dashboard(
      loggedInUser.uid.toString(),
      loggedInUser.operationalcenterid.toString(),
    )
        : (role == "Driver" && loggedInUser.status == "Active")
        ? PickupDriverDashboard(
      operationalcenterid:
      loggedInUser.operationalcenterid.toString(),
      driveroccupied: loggedInUser.driveroccupied,
      id: loggedInUser.uid.toString(),
    )
        : (role == "Driver" && loggedInUser.status == "Blocked")
        ? Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Center(child: Wrap(
            children: [
              Text("Account Blocked. Contact Admin",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  )
              ),
            ],
          ))),
    )
        : (role == "DropoffDriver" && loggedInUser.status == "Active")
        ? DropoffDriverDashboard(
      id: loggedInUser.uid.toString(),
      operationalcenterid:
      loggedInUser.operationalcenterid.toString(),
      driveroccupied: loggedInUser.driveroccupied,
    )
        : (role == "DropoffDriver" &&
        loggedInUser.status == "Blocked")
        ? Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Center(child: Wrap(
            children: [
              Text("Account Blocked. Contact Admin",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  )
              ),
            ],
          ))),
    )
        : (role == "OperationalCenterDriver" &&
        loggedInUser.status == "Active")
        ? OPCDriverDashboard(
      id: loggedInUser.uid.toString(),
      operationalcenterid:
      loggedInUser.operationalcenterid.toString(),
      driveroccupied: loggedInUser.driveroccupied,
    )
        : (role == "OperationalCenterDriver" &&
        loggedInUser.status == "Blocked")
        ? Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Center(child: Wrap(
            children: [
              Text("Account Blocked. Contact Admin",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  )
              ),
            ],
          ))),
    )
    :

    (role == "User" &&
        loggedInUser.status == "Active")
    ?Homepage(
      id: loggedInUser.uid.toString(),
      name: loggedInUser.name.toString(),
      email: loggedInUser.email.toString(),
      mobile: loggedInUser.mobile.toString(),
      address: loggedInUser.address.toString(),
      role: loggedInUser.role.toString(),
    ):
    (role == "User" &&
        loggedInUser.status == "Blocked")
    ?Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Center(child: Wrap(
            children: [
              Text("Account Blocked. Contact Admin",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
              )
              ),
            ],
          ))),
    )
    :
        Scaffold(body: Center(child: CircularProgressIndicator(),));
  }

  @override
  Widget build(BuildContext context) {
    CircularProgressIndicator();
    return routing();
  }
}

