import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/pickupdriver/widgets/navigationdrawerpickupdriver.dart';
import 'package:universal_io/io.dart' as u;

class PickupDriverDashboard extends StatefulWidget {
  final String id;

  bool? driveroccupied;
  String? operationalcenterid;

  PickupDriverDashboard({
    required this.id,
    this.operationalcenterid,
    this.driveroccupied,
  });
  @override
  _PickupDriverDashboardState createState() => _PickupDriverDashboardState();
}

class _PickupDriverDashboardState extends State<PickupDriverDashboard> {
  DatabaseHelper _db = DatabaseHelper();

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
                title: Text('Pick&GO - Pickup Delivery'),
              ),
              body: Container(
                  color: Colors.white60,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.dashboard, size: 28),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontSize: 21.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      ///dashboard cards
                      Card(
                        color: Color(0xFFC8A8BA),
                        child: InkWell(
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Padding(
                                child: Icon(
                                  Icons.local_shipping,
                                  color: Colors.black87,
                                  size: 40,
                                ),
                                padding: EdgeInsets.all(2),
                              ),
                              title: Text(
                                '12',
                                style: TextStyle(fontSize: 28),
                              ),
                              subtitle: Text('Active Deliveries',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Color(0xFFE1D580),
                        child: InkWell(
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Padding(
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.black87,
                                  size: 40,
                                ),
                                padding: EdgeInsets.all(2),
                              ),
                              title: Text(
                                '188',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              subtitle: Text('Completed Deliveries',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Color(0xFFBCBCDA),
                        child: InkWell(
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Padding(
                                child: Icon(
                                  Icons.people,
                                  color: Colors.black87,
                                  size: 40,
                                ),
                                padding: EdgeInsets.all(2),
                              ),
                              title: Text(
                                '52',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              subtitle: Text('No of Delivery Persons',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
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
                  color: Colors.white60,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.dashboard, size: 28),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontSize: 21.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),

                      ///dashboard cards
                      Padding(
                        padding: const EdgeInsets.only(left: 160.0, top: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 90.0),
                                  child: Container(
                                    width: 560,
                                    height: 160,
                                    child: Card(
                                      color: Color(0xFFC8A8BA),
                                      child: InkWell(
                                        onTap: () {
                                          debugPrint('Card tapped.');
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ListTile(
                                            leading: Padding(
                                              child: Icon(
                                                Icons.local_shipping,
                                                color: Colors.black87,
                                                size: 40,
                                              ),
                                              padding: EdgeInsets.all(2),
                                            ),
                                            title: Text(
                                              '12',
                                              style: TextStyle(fontSize: 28),
                                            ),
                                            subtitle: Text('Active Deliveries',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 560,
                                  height: 160,
                                  child: Card(
                                    color: Color(0xFFE1D580),
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint('Card tapped.');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: ListTile(
                                          leading: Padding(
                                            child: Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.black87,
                                              size: 40,
                                            ),
                                            padding: EdgeInsets.all(2),
                                          ),
                                          title: Text(
                                            '188',
                                            style: TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                          subtitle: Text('Completed Deliveries',
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 480.0, top: 70.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Container(
                                    width: 560,
                                    height: 160,
                                    child: Card(
                                      color: Color(0xFFBCBCDA),
                                      child: InkWell(
                                        onTap: () {
                                          debugPrint('Card tapped.');
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ListTile(
                                            leading: Padding(
                                              child: Icon(
                                                Icons.people,
                                                color: Colors.black87,
                                                size: 40,
                                              ),
                                              padding: EdgeInsets.all(2),
                                            ),
                                            title: Text(
                                              '52',
                                              style: TextStyle(
                                                fontSize: 28,
                                              ),
                                            ),
                                            subtitle:
                                                Text('No of Delivery Persons',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}
