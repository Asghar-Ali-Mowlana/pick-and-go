import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/operationalcenterdriver/operationalcenterdriverviewpastdeliveriesdetails.dart';
import 'package:pickandgo/screens/operationalcenterdriver/widgets/navigationdrawerpickupdriver.dart';
import 'package:universal_io/io.dart' as u;

class OPCDriverPastDeliveries extends StatefulWidget {


  final String id;

  bool? driveroccupied;
  String? operationalcenterid;

  OPCDriverPastDeliveries({
    required this.id,
    required this.operationalcenterid,
    required this.driveroccupied,
  });
  @override
  _OPCDriverPastDeliveriesState createState() =>
      _OPCDriverPastDeliveriesState();
}

class _OPCDriverPastDeliveriesState extends State<OPCDriverPastDeliveries> {
  DatabaseHelper _db = DatabaseHelper();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
              drawer: NavigationDrawerWidget(
                id: widget.id,
                driveroccupied: widget.driveroccupied,
                operationalcenterid: widget.operationalcenterid,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick&GO - OP-Center Delivery'),
              ),
              body: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  :
              Container(
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
                          .where('operationalCenterDriverId',
                          isEqualTo: widget.id)
                         // .where('toOperationalCenterId', isNotEqualTo: "")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text("No data"));
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

                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                            // TaskCardWidget(id: user.id, name: user.ingredients,)
                                            OperationalCenterDriverPastOrderDetails(
                                                widget.id,snapshot.data!.docs[index]['packageid']
                                                .toString()

                                            )));
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
              drawer: NavigationDrawerWidget(
                id: widget.id,
                driveroccupied: widget.driveroccupied,
                operationalcenterid: widget.operationalcenterid,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick&GO - Pickup Delivery'),
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
                          .where('toOperationalCenterId', isNotEqualTo: "")
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
