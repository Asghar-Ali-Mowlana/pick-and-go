import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/operationalcenter/widgets/navigationdrawercenter.dart';
import 'package:universal_io/io.dart' as u;

import 'opc_viewpackagedetails.dart';

class Orders extends StatefulWidget {
  String? uid;
  String? operationalcenterid;

  //constructor

  Orders(
    this.uid,
    this.operationalcenterid,
  );

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    // print(widget.uid);
    // print(widget.operationalcenterid);

    // TODO: implement initState
    super.initState();
  }

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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Icon(Icons.local_shipping, size: 28),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ///package/order list view
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('package')
                          .where('packageDroppedOperationalCenter',
                              isEqualTo: true)
                          .where('operationalcenterid',
                              isEqualTo: widget.operationalcenterid)
                          .where('packageDelivered', isEqualTo: false)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              print("Package details displaying with Package ID: ${snapshot.data!.docs[index]['packageid']
                                  .toString()}");
                              return Card(
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.local_shipping,
                                            size: 28),
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot
                                              .data!.docs[index]['packageid']
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    "User Id: ${snapshot.data!.docs[index]['userid'].toString()}",
                                    style: TextStyle(fontSize: 14),
                                  ),

                                  ///package/order view navigation
                                  trailing: Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      // TaskCardWidget(id: user.id, name: user.ingredients,)
                                                      ViewPackageDetails(
                                                        id: widget.uid!,
                                                        pkgId: snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['packageid']
                                                            .toString(),
                                                      )));
                                          /* Your code */
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
              ),
            ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Icon(Icons.local_shipping, size: 28),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ///package/order list view
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('package')
                          .where('packageDroppedOperationalCenter',
                              isEqualTo: true)
                          .where('operationalcenterid',
                              isEqualTo: widget.operationalcenterid)
                          .where('packageDelivered', isEqualTo: false)
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
                                        icon: Icon(Icons.local_shipping,
                                            size: 28),
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot
                                              .data!.docs[index]['packageid']
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    "User Id: ${snapshot.data!.docs[index]['userid'].toString()}",
                                    style: TextStyle(fontSize: 14),
                                  ),

                                  ///package/order view navigation
                                  trailing: Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      // TaskCardWidget(id: user.id, name: user.ingredients,)
                                                      ViewPackageDetails(
                                                        id: widget.uid!,
                                                        pkgId: snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['packageid']
                                                            .toString(),
                                                      )));
                                          /* Your code */
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
              ),
            ),
          );
  }
}
