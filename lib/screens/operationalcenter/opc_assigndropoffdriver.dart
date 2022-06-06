import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/operationalcenter/widgets/navigationdrawercenter.dart';
import 'package:universal_io/io.dart' as u;

import '../../databasehelper.dart';
import 'opc_addpackagesdropoffdriver.dart';

class AssignDropOffDriver extends StatefulWidget {
  //const AssignDropOffDriver({Key? key}) : super(key: key);

  String uid;
  String operationalcenterid;

  AssignDropOffDriver(
    this.uid,
    this.operationalcenterid,
  );

  @override
  _AssignDropOffDriverState createState() => _AssignDropOffDriverState();
}

class _AssignDropOffDriverState extends State<AssignDropOffDriver> {
  DatabaseHelper _db = DatabaseHelper();
  final controllers = TextEditingController();

  @override
  void initState() {
    print(widget.operationalcenterid);
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
            body: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.black87,
                        size: 28,
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        'Assign Drop Off Driver',
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: "DropoffDriver")
                        .where('operationalcenterid',
                            isEqualTo: widget.operationalcenterid)
                        .where('driveroccupied', isEqualTo: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {},
                                      icon:
                                          Icon(Icons.account_circle, size: 32),
                                    ),
                                    Flexible(
                                      child: Text(
                                          snapshot.data!.docs[index]['name']
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                    "Driver Id: " +
                                        snapshot.data!.docs[index]['uid']
                                            .toString(),
                                    style: TextStyle(fontSize: 13.7)),
                                trailing: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddPackagesDropOffDriver(
                                                        widget.uid,
                                                        widget
                                                            .operationalcenterid,
                                                        snapshot.data!
                                                            .docs[index]['uid']
                                                            .toString())));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // TextField(
                //
                //   onSubmitted: (value) async{
                //
                //
                //     controllers.text = value;
                //     Navigator.of(context).push(
                //         MaterialPageRoute(
                //             builder: (context) => AddPackagesDropOffDriver(
                //                 widget.id,widget.operationalcenterid,value
                //             )));
                //
                //   },
                //
                //   controller: controllers,
                //
                // ),
              ],
            ),
          ))
        : SafeArea(
            child: Scaffold(
            drawer: NavigationDrawerWidgetCenter(
                widget.uid, widget.operationalcenterid),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Pick&GO - Operational Center'),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.black87,
                        size: 28,
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        'Assign Drop Off Driver',
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: "DropoffDriver")
                        .where('operationalcenterid',
                            isEqualTo: widget.operationalcenterid)
                        .where('driveroccupied', isEqualTo: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {},
                                      icon:
                                          Icon(Icons.account_circle, size: 32),
                                    ),
                                    Flexible(
                                      child: Text(
                                          snapshot.data!.docs[index]['name']
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                    "Driver Id: " +
                                        snapshot.data!.docs[index]['uid']
                                            .toString(),
                                    style: TextStyle(fontSize: 13.7)),
                                trailing: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddPackagesDropOffDriver(
                                                        widget.uid,
                                                        widget
                                                            .operationalcenterid,
                                                        snapshot.data!
                                                            .docs[index]['uid']
                                                            .toString())));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // TextField(
                //
                //   onSubmitted: (value) async{
                //
                //
                //     controllers.text = value;
                //     Navigator.of(context).push(
                //         MaterialPageRoute(
                //             builder: (context) => AddPackagesDropOffDriver(
                //                 widget.id,widget.operationalcenterid,value
                //             )));
                //
                //   },
                //
                //   controller: controllers,
                //
                // ),
              ],
            ),
          ));
  }
}
