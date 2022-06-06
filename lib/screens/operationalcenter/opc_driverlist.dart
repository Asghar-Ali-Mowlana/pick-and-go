import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/operationalcenter/opc_viewdriverdetails.dart';
import 'package:pickandgo/screens/operationalcenter/widgets/navigationdrawercenter.dart';
import 'package:universal_io/io.dart' as u;

class Opc_DriverList extends StatefulWidget {
  String uid;
  String operationalcenterid;

  //constructor

  Opc_DriverList(
    this.uid,
    this.operationalcenterid,
  );

  @override
  _Opc_DriverListState createState() => _Opc_DriverListState();
}

class _Opc_DriverListState extends State<Opc_DriverList> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  String dropdownValue = "Active";

  DatabaseHelper _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
                drawer: NavigationDrawerWidgetCenter(
                    widget.uid, widget.operationalcenterid),
                appBar: AppBar(
                  backgroundColor: Colors.black87,
                  title: Text('Pick&GO - Operational Center'),
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.delivery_dining),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Delivery Persons',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('operationalcenterid',
                                isEqualTo: widget.operationalcenterid)
                            .where('role', isEqualTo: "Driver")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Row(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delivery_dining),
                                        ),
                                        Flexible(
                                          child: Text(
                                            snapshot.data!.docs[index]['uid']
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'User Id:' +
                                          snapshot.data!.docs[index]['uid']
                                              .toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    // trailing: const Padding(
                                    //   padding: EdgeInsets.all(13.0),
                                    //   child: Text("asd"),
                                    // ),
                                    trailing: Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewDriverDetais(
                                                            widget.uid,
                                                            widget
                                                                .operationalcenterid,
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['uid']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['name']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['email']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['mobile']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['status']
                                                                .toString())));
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) => AddPackagesDropOffDriver(
                                            //           //userId
                                            //           widget.id,
                                            //           //driverid
                                            //           snapshot
                                            //               .data!.docs[index]['uid']
                                            //               .toString(),
                                            //           //op id
                                            //           widget.operationalcenterid,
                                            //           widget.address,
                                            //           widget.email, widget.name, widget.mobile, widget.status,
                                            //         )));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    )
                  ]),
                )),
          )
        : SafeArea(
            child: Scaffold(
                drawer: NavigationDrawerWidgetCenter(
                    widget.uid, widget.operationalcenterid),
                appBar: AppBar(
                  backgroundColor: Colors.black87,
                  title: Text('Pick&GO - Operational Center'),
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.delivery_dining),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Delivery Persons',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('operationalcenterid',
                                isEqualTo: widget.operationalcenterid)
                            .where('role', isEqualTo: "Driver")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Row(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delivery_dining),
                                        ),
                                        Flexible(
                                          child: Text(
                                            snapshot.data!.docs[index]['uid']
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'User Id:' +
                                          snapshot.data!.docs[index]['uid']
                                              .toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    // trailing: const Padding(
                                    //   padding: EdgeInsets.all(13.0),
                                    //   child: Text("asd"),
                                    // ),
                                    trailing: Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewDriverDetais(
                                                            widget.uid,
                                                            widget
                                                                .operationalcenterid,
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['uid']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['name']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['email']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['mobile']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['status']
                                                                .toString())));
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) => AddPackagesDropOffDriver(
                                            //           //userId
                                            //           widget.id,
                                            //           //driverid
                                            //           snapshot
                                            //               .data!.docs[index]['uid']
                                            //               .toString(),
                                            //           //op id
                                            //           widget.operationalcenterid,
                                            //           widget.address,
                                            //           widget.email, widget.name, widget.mobile, widget.status,
                                            //         )));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    )
                  ]),
                )),
          );
  }
}
