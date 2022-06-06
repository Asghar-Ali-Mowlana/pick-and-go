import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/operationalcenter/opc_pastpackagedetails.dart';
import 'package:pickandgo/screens/operationalcenter/widgets/navigationdrawercenter.dart';
import 'package:universal_io/io.dart' as u;

class OPC_PastPackages extends StatefulWidget {
  String? uid;
  String? operationalcenterid;

  //constructor

  OPC_PastPackages(
    this.uid,
    this.operationalcenterid,
  );

  @override
  _OPC_PastPackagesState createState() => _OPC_PastPackagesState();
}

class _OPC_PastPackagesState extends State<OPC_PastPackages> {
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
                        Icon(Icons.assignment_turned_in, size: 28),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Past Orders',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
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
                          .collection('package')
                          .where('packageDroppedOperationalCenter',
                              isEqualTo: true)
                          .where('operationalcenterid',
                              isEqualTo: widget.operationalcenterid)
                          .where('packageDelivered', isEqualTo: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              print("Displaying past packages, Package ID: ${snapshot.data!.docs[index]['packageid']
                                  .toString()}");
                              return ListTile(
                                title: Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.local_shipping,
                                        size: 28,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.docs[index]['packageid']
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  snapshot.data!.docs[index]['userid']
                                      .toString(),
                                ),

                                ///past package/order view navigation
                                trailing: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        /* Your code */

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    // TaskCardWidget(id: user.id, name: user.ingredients,)
                                                    PastPackageDetails(
                                                        widget.uid!,
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['packageid']
                                                            .toString())));
                                      },
                                    )
                                  ],
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
                        Icon(Icons.assignment_turned_in, size: 28),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Past Orders',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
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
                          .collection('package')
                          .where('packageDroppedOperationalCenter',
                              isEqualTo: true)
                          .where('operationalcenterid',
                              isEqualTo: widget.operationalcenterid)
                          .where('packageDelivered', isEqualTo: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.local_shipping,
                                        size: 28,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.docs[index]['packageid']
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  snapshot.data!.docs[index]['userid']
                                      .toString(),
                                ),

                                ///past package/order view navigation
                                trailing: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        /* Your code */

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    // TaskCardWidget(id: user.id, name: user.ingredients,)
                                                    PastPackageDetails(
                                                        widget.uid!,
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['packageid']
                                                            .toString())));
                                      },
                                    )
                                  ],
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
