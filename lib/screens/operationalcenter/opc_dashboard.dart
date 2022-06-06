import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/operationalcenter/opc_notification_service.dart';
import 'package:pickandgo/screens/operationalcenter/widgets/navigationdrawercenter.dart';
import 'package:universal_io/io.dart' as u;
import 'opc_notification_service.dart';

class Dashboard extends StatefulWidget {
  String? uid;
  String? operationalcenterid;

  //constructor
  Dashboard(
    this.uid,
    this.operationalcenterid,
  );

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DatabaseHelper _db = DatabaseHelper();

  @override
  initState() {
    super.initState();
    notificationService.setOnNotificationClick(onNotificationClick);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notificationService.scheduleNotification();
    });
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
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
                            Icon(Icons.dashboard),
                            SizedBox(
                              width: 3.0,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontSize: 21.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      ///dashboard cards
                      Card(
                        color: Color(0xFFDAF7A6),
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
                                '134',
                                style: TextStyle(fontSize: 28),
                              ),
                              subtitle: Text('Total Orders',
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
                        color: Color(0xFF9FD3EE),
                        child: InkWell(
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Padding(
                                child: Icon(
                                  Icons.payments,
                                  color: Colors.black87,
                                  size: 40,
                                ),
                                padding: EdgeInsets.all(2),
                              ),
                              title: Text(
                                '88',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              subtitle: Text('Total Deliveries',
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
                        color: Color(0xFFEEA8AE),
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
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Color(0xFFA37FA8),
                        child: InkWell(
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Padding(
                                child: Container(
                                  child: Icon(
                                    Icons.payments,
                                    color: Colors.black87,
                                    size: 40,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                              ),
                              title: Text(
                                'LKR. 122,000',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              subtitle: Text('Total Revenue',
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
              drawer: NavigationDrawerWidgetCenter(
                  widget.uid, widget.operationalcenterid),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick&GO - Operational Center'),
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
                            Icon(Icons.dashboard),
                            SizedBox(
                              width: 3.0,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontSize: 21.0, fontWeight: FontWeight.w600),
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
                                      color: Color(0xFFDAF7A6),
                                      child: InkWell(
                                        onTap: () {
                                          debugPrint('Card tapped.');
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(40),
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
                                              '134',
                                              style: TextStyle(fontSize: 28),
                                            ),
                                            subtitle: Text('Total Orders',
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
                                    color: Color(0xFF9FD3EE),
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint('Card tapped.');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(40),
                                        child: ListTile(
                                          leading: Padding(
                                            child: Icon(
                                              Icons.payments,
                                              color: Colors.black87,
                                              size: 40,
                                            ),
                                            padding: EdgeInsets.all(2),
                                          ),
                                          title: Text(
                                            '88',
                                            style: TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                          subtitle: Text('Total Deliveries',
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
                        padding: const EdgeInsets.only(left: 160.0, top: 70.0),
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
                                      color: Color(0xFFEEA8AE),
                                      child: InkWell(
                                        onTap: () {
                                          debugPrint('Card tapped.');
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(40),
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
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 560,
                                  height: 160,
                                  child: Card(
                                    color: Color(0xFFA37FA8),
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint('Card tapped.');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(40),
                                        child: ListTile(
                                          leading: Padding(
                                            child: Container(
                                              child: Icon(
                                                Icons.payments,
                                                color: Colors.black87,
                                                size: 40,
                                              ),
                                            ),
                                            padding: EdgeInsets.all(2),
                                          ),
                                          title: Text(
                                            'LKR. 122,000',
                                            style: TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                          subtitle: Text('Total Revenue',
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
                    ],
                  )),
            ),
          );
  }
}
