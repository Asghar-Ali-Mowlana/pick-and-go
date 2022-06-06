import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/user/homepage.dart';
import 'package:pickandgo/screens/user/sendpackage/customerPastPackagesList.dart';
import 'package:pickandgo/screens/user/sendpackage/customerTracking.dart';
import 'package:pickandgo/screens/user/widgets/navigationdrawer.dart';
import 'package:universal_io/io.dart' as u;

class ReceivedPackageList extends StatefulWidget {
  const ReceivedPackageList({Key? key}) : super(key: key);

  @override
  State<ReceivedPackageList> createState() => _ReceivedPackageListState();
}

class _ReceivedPackageListState extends State<ReceivedPackageList> {
  bool _isLoading = true;

  late String role;
  late String id;
  late String email;
  late String address;
  late String mobile;
  late String name;

  _getuserDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        role = documentSnapshot['role'];
        id = documentSnapshot['uid'];
        email = documentSnapshot['email'];
        address = documentSnapshot['address'];
        mobile = documentSnapshot['mobile'];
        name = documentSnapshot['name'];
      } else {
        print("User document does not exist");
      }
    });
  }

  @override
  void initState() {
    //super.initState();
    _getuserDetails();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final CollectionReference packageCollection =
        FirebaseFirestore.instance.collection('package');
    final Query unpicked = packageCollection
        .where('userid', isEqualTo: user!.uid)
        .where('packageDelivered', isEqualTo: false);

    return _isLoading == true
        ? Center(child: CircularProgressIndicator())
        : (u.Platform.operatingSystem == "android")
            ? Scaffold(
                appBar: AppBar(
                  title: Text("Ongoing Packages"),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Homepage(
                                    role: role,
                                    id: id,
                                    email: email,
                                    address: address,
                                    mobile: mobile,
                                    name: name,
                                  )));
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.local_shipping),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerPastPackagesList()));
                      },
                    )
                  ],
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                ),
                body: StreamBuilder<QuerySnapshot>(
                  stream: unpicked.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Card(
                                child: InkWell(
                              onTap: () {
                                //_setLocation();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReceiverTracking(
                                            doc['packageid'])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          doc['packageid'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          height: 31,
                                          width: 78,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/logo2.png'))),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 12.0, 0.0, 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 8.0),
                                            child: Text(
                                              doc[
                                                              'pickupreqaccepted'] ==
                                                          false &&
                                                      doc['packagePickedUp'] ==
                                                          false &&
                                                      doc['packageDroppedOperationalCenter'] ==
                                                          false &&
                                                      doc['packageLeftOperationalCenter'] ==
                                                          false &&
                                                      doc['packageDelivered'] ==
                                                          false
                                                  ? "Waiting for confirmation"
                                                  : doc['pickupreqaccepted'] ==
                                                              true &&
                                                          doc['packagePickedUp'] ==
                                                              false &&
                                                          doc['packageDroppedOperationalCenter'] ==
                                                              false &&
                                                          doc['packageLeftOperationalCenter'] ==
                                                              false &&
                                                          doc['packageDelivered'] ==
                                                              false
                                                      ? "Waiting for pickup"
                                                      : doc['pickupreqaccepted'] == true &&
                                                              doc['packagePickedUp'] ==
                                                                  true &&
                                                              doc['packageDroppedOperationalCenter'] ==
                                                                  false &&
                                                              doc['packageLeftOperationalCenter'] ==
                                                                  false &&
                                                              doc['packageDelivered'] ==
                                                                  false
                                                          ? "On the way to operational center"
                                                          : doc['pickupreqaccepted'] == true &&
                                                                  doc['packagePickedUp'] ==
                                                                      true &&
                                                                  doc['packageDroppedOperationalCenter'] ==
                                                                      true &&
                                                                  doc['packageLeftOperationalCenter'] ==
                                                                      false &&
                                                                  doc['packageDelivered'] ==
                                                                      false
                                                              ? "In transit"
                                                              : doc[
                                                                              'pickupreqaccepted'] ==
                                                                          true &&
                                                                      doc['packagePickedUp'] ==
                                                                          true &&
                                                                      doc['packageDroppedOperationalCenter'] ==
                                                                          true &&
                                                                      doc['packageLeftOperationalCenter'] ==
                                                                          true &&
                                                                      doc['packageDelivered'] ==
                                                                          false
                                                                  ? "Package left operational center"
                                                                  : doc['pickupreqaccepted'] ==
                                                                              true &&
                                                                          doc['packagePickedUp'] ==
                                                                              true &&
                                                                          doc['packageDroppedOperationalCenter'] ==
                                                                              true &&
                                                                          doc['packageLeftOperationalCenter'] ==
                                                                              true &&
                                                                          doc['packageDelivered'] ==
                                                                              true
                                                                      ? "Delivered"
                                                                      : "",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Text(
                                            "Last update: a second ago",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 12.0, 0.0, 8.0),
                                            child: Container(
                                              height: 5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.5)),
                                              child: LinearProgressIndicator(
                                                value: doc['pickupreqaccepted'] == false &&
                                                        doc['packagePickedUp'] ==
                                                            false &&
                                                        doc['packageDroppedOperationalCenter'] ==
                                                            false &&
                                                        doc['packageLeftOperationalCenter'] ==
                                                            false &&
                                                        doc['packageDelivered'] ==
                                                            false
                                                    ? 0.0
                                                    : doc['pickupreqaccepted'] ==
                                                                true &&
                                                            doc['packagePickedUp'] ==
                                                                false &&
                                                            doc['packageDroppedOperationalCenter'] ==
                                                                false &&
                                                            doc['packageLeftOperationalCenter'] ==
                                                                false &&
                                                            doc['packageDelivered'] ==
                                                                false
                                                        ? 0.2
                                                        : doc['pickupreqaccepted'] ==
                                                                    true &&
                                                                doc['packagePickedUp'] ==
                                                                    true &&
                                                                doc['packageDroppedOperationalCenter'] ==
                                                                    false &&
                                                                doc['packageLeftOperationalCenter'] ==
                                                                    false &&
                                                                doc['packageDelivered'] ==
                                                                    false
                                                            ? 0.4
                                                            : doc['pickupreqaccepted'] ==
                                                                        true &&
                                                                    doc['packagePickedUp'] ==
                                                                        true &&
                                                                    doc['packageDroppedOperationalCenter'] ==
                                                                        true &&
                                                                    doc['packageLeftOperationalCenter'] ==
                                                                        false &&
                                                                    doc['packageDelivered'] ==
                                                                        false
                                                                ? 0.6
                                                                : doc['pickupreqaccepted'] == true &&
                                                                        doc['packagePickedUp'] ==
                                                                            true &&
                                                                        doc['packageDroppedOperationalCenter'] ==
                                                                            true &&
                                                                        doc['packageLeftOperationalCenter'] ==
                                                                            true &&
                                                                        doc['packageDelivered'] ==
                                                                            false
                                                                    ? 0.8
                                                                    : doc['pickupreqaccepted'] == true &&
                                                                            doc['packagePickedUp'] ==
                                                                                true &&
                                                                            doc['packageDroppedOperationalCenter'] ==
                                                                                true &&
                                                                            doc['packageLeftOperationalCenter'] ==
                                                                                true &&
                                                                            doc['packageDelivered'] ==
                                                                                true
                                                                        ? 1.0
                                                                        : 0.0,
                                                color: Colors.black,
                                                backgroundColor:
                                                    Colors.grey[300],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Details",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              Icon(
                                                Icons.navigate_next_rounded,
                                                size: 16,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text("All Packages"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.local_shipping),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerPastPackagesList()));
                      },
                    )
                  ],
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                ),
                body: StreamBuilder<QuerySnapshot>(
                  stream: unpicked.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Card(
                                child: InkWell(
                              onTap: () {
                                //_setLocation();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReceiverTracking(
                                            doc['packageid'])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          doc['packageid'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          height: 31,
                                          width: 78,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/logo2.png'))),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 12.0, 0.0, 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 8.0),
                                            child: Text(
                                              doc[
                                                              'pickupreqaccepted'] ==
                                                          false &&
                                                      doc['packagePickedUp'] ==
                                                          false &&
                                                      doc['packageDroppedOperationalCenter'] ==
                                                          false &&
                                                      doc['packageLeftOperationalCenter'] ==
                                                          false &&
                                                      doc['packageDelivered'] ==
                                                          false
                                                  ? "Waiting for confirmation"
                                                  : doc['pickupreqaccepted'] ==
                                                              true &&
                                                          doc['packagePickedUp'] ==
                                                              false &&
                                                          doc['packageDroppedOperationalCenter'] ==
                                                              false &&
                                                          doc['packageLeftOperationalCenter'] ==
                                                              false &&
                                                          doc['packageDelivered'] ==
                                                              false
                                                      ? "Waiting for pickup"
                                                      : doc['pickupreqaccepted'] == true &&
                                                              doc['packagePickedUp'] ==
                                                                  true &&
                                                              doc['packageDroppedOperationalCenter'] ==
                                                                  false &&
                                                              doc['packageLeftOperationalCenter'] ==
                                                                  false &&
                                                              doc['packageDelivered'] ==
                                                                  false
                                                          ? "On the way to operational center"
                                                          : doc['pickupreqaccepted'] == true &&
                                                                  doc['packagePickedUp'] ==
                                                                      true &&
                                                                  doc['packageDroppedOperationalCenter'] ==
                                                                      true &&
                                                                  doc['packageLeftOperationalCenter'] ==
                                                                      false &&
                                                                  doc['packageDelivered'] ==
                                                                      false
                                                              ? "In transit"
                                                              : doc[
                                                                              'pickupreqaccepted'] ==
                                                                          true &&
                                                                      doc['packagePickedUp'] ==
                                                                          true &&
                                                                      doc['packageDroppedOperationalCenter'] ==
                                                                          true &&
                                                                      doc['packageLeftOperationalCenter'] ==
                                                                          true &&
                                                                      doc['packageDelivered'] ==
                                                                          false
                                                                  ? "Package left operational center"
                                                                  : doc['pickupreqaccepted'] ==
                                                                              true &&
                                                                          doc['packagePickedUp'] ==
                                                                              true &&
                                                                          doc['packageDroppedOperationalCenter'] ==
                                                                              true &&
                                                                          doc['packageLeftOperationalCenter'] ==
                                                                              true &&
                                                                          doc['packageDelivered'] ==
                                                                              true
                                                                      ? "Delivered"
                                                                      : "",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Text(
                                            "Last update: a second ago",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 12.0, 0.0, 8.0),
                                            child: Container(
                                              height: 5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.5)),
                                              child: LinearProgressIndicator(
                                                value: doc['pickupreqaccepted'] == false &&
                                                        doc['packagePickedUp'] ==
                                                            false &&
                                                        doc['packageDroppedOperationalCenter'] ==
                                                            false &&
                                                        doc['packageLeftOperationalCenter'] ==
                                                            false &&
                                                        doc['packageDelivered'] ==
                                                            false
                                                    ? 0.0
                                                    : doc['pickupreqaccepted'] ==
                                                                true &&
                                                            doc['packagePickedUp'] ==
                                                                false &&
                                                            doc['packageDroppedOperationalCenter'] ==
                                                                false &&
                                                            doc['packageLeftOperationalCenter'] ==
                                                                false &&
                                                            doc['packageDelivered'] ==
                                                                false
                                                        ? 0.2
                                                        : doc['pickupreqaccepted'] ==
                                                                    true &&
                                                                doc['packagePickedUp'] ==
                                                                    true &&
                                                                doc['packageDroppedOperationalCenter'] ==
                                                                    false &&
                                                                doc['packageLeftOperationalCenter'] ==
                                                                    false &&
                                                                doc['packageDelivered'] ==
                                                                    false
                                                            ? 0.4
                                                            : doc['pickupreqaccepted'] ==
                                                                        true &&
                                                                    doc['packagePickedUp'] ==
                                                                        true &&
                                                                    doc['packageDroppedOperationalCenter'] ==
                                                                        true &&
                                                                    doc['packageLeftOperationalCenter'] ==
                                                                        false &&
                                                                    doc['packageDelivered'] ==
                                                                        false
                                                                ? 0.6
                                                                : doc['pickupreqaccepted'] == true &&
                                                                        doc['packagePickedUp'] ==
                                                                            true &&
                                                                        doc['packageDroppedOperationalCenter'] ==
                                                                            true &&
                                                                        doc['packageLeftOperationalCenter'] ==
                                                                            true &&
                                                                        doc['packageDelivered'] ==
                                                                            false
                                                                    ? 0.8
                                                                    : doc['pickupreqaccepted'] == true &&
                                                                            doc['packagePickedUp'] ==
                                                                                true &&
                                                                            doc['packageDroppedOperationalCenter'] ==
                                                                                true &&
                                                                            doc['packageLeftOperationalCenter'] ==
                                                                                true &&
                                                                            doc['packageDelivered'] ==
                                                                                true
                                                                        ? 1.0
                                                                        : 0.0,
                                                color: Colors.black,
                                                backgroundColor:
                                                    Colors.grey[300],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Details",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              Icon(
                                                Icons.navigate_next_rounded,
                                                size: 16,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              );
  }
}
