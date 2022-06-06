//import 'package:firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/operationalcenterdriver/opcdriver_DriverRequests.dart';
import 'package:pickandgo/screens/operationalcenterdriver/opcdriver_dashboard.dart';
import 'package:pickandgo/screens/operationalcenterdriver/widgets/navigationdrawerpickupdriver.dart';
import 'package:universal_io/io.dart' as u;

class OperationalCenterDriverPackagesDropped extends StatefulWidget {
  final String id;
  bool? driveroccupiedy;
  String? operationalcenterid;

  OperationalCenterDriverPackagesDropped({
    required this.id,
    required this.driveroccupiedy,
    required this.operationalcenterid,
  });
  //const OperationalCenterDriverPackagesDropped({Key? key}) : super(key: key);

  @override
  State<OperationalCenterDriverPackagesDropped> createState() =>
      _OperationalCenterDriverPackagesDroppedState();
}

class _OperationalCenterDriverPackagesDroppedState
    extends State<OperationalCenterDriverPackagesDropped> {
  var toOperationalCenterId;

  _updatePackagesDropped() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        toOperationalCenterId = documentSnapshot['toOperationalCenterId'];
      } else {
        print("The user document does not exist");
      }
    });

    await FirebaseFirestore.instance
        .collection('package')
        .where('operationalCenterid', isEqualTo: widget.id)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                FirebaseFirestore.instance
                    .collection('package')
                    .doc(doc['packageid'].toString())
                    .set({
                  "toOperationalCenterId": toOperationalCenterId,
                }, SetOptions(merge: true));
              })
            });

    await FirebaseFirestore.instance.collection('users').doc(widget.id).update(
        {'packages': [], 'driveroccupied': false, 'toOperationalCenterId': ''});

    print("All operations done");
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? Scaffold(
            drawer: NavigationDrawerWidget(
              id: widget.id,
              driveroccupied: widget.driveroccupiedy,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              title: Text("Drop All Packages"),
              backgroundColor: Colors.black,
            ),
            body: Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  onPressed: () {
                    _updatePackagesDropped();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OPCDriverDashboard(
                                  id: widget.id,
                                )));
                  },
                  minWidth: 160,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Colors.black,
                  child: const Text(
                    'Packages Delivered',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
            ),
          )
        : Scaffold(
            drawer: NavigationDrawerWidget(
              id: widget.id,
              driveroccupied: widget.driveroccupiedy,
              operationalcenterid: widget.operationalcenterid,
            ),
            appBar: AppBar(
              title: Text("Drop All Packages"),
              backgroundColor: Colors.black,
            ),
            body: Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  onPressed: () {
                    _updatePackagesDropped();
                  },
                  minWidth: 160,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Colors.black,
                  child: const Text(
                    'Packages Delivered',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
            ),
          );
  }
}
