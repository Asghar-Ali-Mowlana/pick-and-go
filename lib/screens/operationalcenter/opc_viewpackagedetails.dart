import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as u;

import '../../databasehelper.dart';
import '../../services/routingpage.dart';

class ViewPackageDetails extends StatefulWidget {
  final String pkgId;
  final String id;

  const ViewPackageDetails({Key? key, required this.id, required this.pkgId})
      : super(key: key);

  @override
  _ViewPackageDetailsState createState() => _ViewPackageDetailsState();
}

class _ViewPackageDetailsState extends State<ViewPackageDetails> {
  final TextEditingController _pickupAddress = TextEditingController();
  final TextEditingController _recieverAddress = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _total = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();

  bool _pickUpReqValue = true;
  bool _packagepickedUpValue = true;
  bool _packageDroppedOperationalCenterValue = true;
  bool _packageLeftOperationalCenterValue = true;
  bool _packageDeliveredValue = true;

  DatabaseHelper _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('View Package Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    _db.logout(context);
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => RoutePage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Stack(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("package")
                      .doc(widget.pkgId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;

                      _pickupAddress.text = data['pickupAddress'];
                      _recieverAddress.text = data['receiverAddress'];
                      _name.text = data['receiverName'];
                      _total.text = data['totalCost'].toString();
                      _email.text = data['receiverEmail'];
                      _mobile.text = data['receiverContactNo'];

                      _pickUpReqValue = data['pickupreqaccepted'];
                      _packagepickedUpValue = data['packagePickedUp'];
                      _packageDroppedOperationalCenterValue =
                          data['packageDroppedOperationalCenter'];
                      _packageLeftOperationalCenterValue =
                          data['packageLeftOperationalCenter'];
                      _packageDeliveredValue = data['packageDelivered'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(1),
                              child: Text(
                                'Package Details',
                                style: TextStyle(fontSize: 30.0),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _pickupAddress,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                labelStyle: TextStyle(color: Colors.grey[800]),
                                labelText: "Pickup Address",
                                fillColor: Colors.white70,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _recieverAddress,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                labelStyle: TextStyle(color: Colors.grey[800]),
                                labelText: "Receiver Address",
                                fillColor: Colors.white70,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _name,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                labelStyle: TextStyle(color: Colors.grey[800]),
                                labelText: "Receiver Name",
                                fillColor: Colors.white70,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _total,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                labelStyle: TextStyle(color: Colors.grey[800]),
                                labelText: "Total Cost",
                                fillColor: Colors.white70,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _email,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                labelStyle: TextStyle(color: Colors.grey[800]),
                                labelText: "Email Address",
                                fillColor: Colors.white70,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _mobile,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                labelStyle: TextStyle(color: Colors.grey[800]),
                                labelText: "Contact Number",
                                fillColor: Colors.white70,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Pick Up Req Accepted?"),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton(
                                    value: _pickUpReqValue,
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text("True"),
                                        value: true,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("False"),
                                        value: false,
                                      ),
                                    ],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('package')
                                            .doc(widget.pkgId)
                                            .update({
                                          'pickupreqaccepted': value,
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Package Picked Up?"),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton(
                                    value: _packagepickedUpValue,
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text("True"),
                                        value: true,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("False"),
                                        value: false,
                                      ),
                                    ],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('package')
                                            .doc(widget.pkgId)
                                            .update({
                                          'packagePickedUp': value,
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Package Dropped at Op-Center ?"),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton(
                                    value:
                                        _packageDroppedOperationalCenterValue,
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text("True"),
                                        value: true,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("False"),
                                        value: false,
                                      ),
                                    ],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('package')
                                            .doc(widget.pkgId)
                                            .update({
                                          'packageDroppedOperationalCenter':
                                              value,
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Packge Left Op-Center?"),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton(
                                    value: _packageLeftOperationalCenterValue,
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text("True"),
                                        value: true,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("False"),
                                        value: false,
                                      ),
                                    ],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('package')
                                            .doc(widget.pkgId)
                                            .update({
                                          'packageLeftOperationalCenter': value,
                                        });
                                      });
                                      print("Package updated, package ID: ${widget.pkgId}");
                                      print("Package Status Changed to: packageLeftOperationalCenter");
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Row(
                                          children: const [
                                            Icon(
                                              Icons.playlist_add_check_sharp,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(child: Text('Updated Successfully')),
                                          ],
                                        ),
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Package Delivered ?"),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton(
                                    value: _packageDeliveredValue,
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text("True"),
                                        value: true,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("False"),
                                        value: false,
                                      ),
                                    ],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('package')
                                            .doc(widget.pkgId)
                                            .update({
                                          'packageDelivered': value,
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text("Please Wait..."),
                      );
                    }
                  },
                )
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('View Package Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    _db.logout(context);
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => RoutePage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("package")
                          .doc(widget.pkgId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;

                          _pickupAddress.text = data['pickupAddress'];
                          _recieverAddress.text = data['receiverAddress'];
                          _name.text = data['receiverName'];
                          _total.text = data['totalCost'].toString();
                          _email.text = data['receiverEmail'];
                          _mobile.text = data['receiverContactNo'];

                          _pickUpReqValue = data['pickupreqaccepted'];
                          _packagepickedUpValue = data['packagePickedUp'];
                          _packageDroppedOperationalCenterValue =
                              data['packageDroppedOperationalCenter'];
                          _packageLeftOperationalCenterValue =
                              data['packageLeftOperationalCenter'];
                          _packageDeliveredValue = data['packageDelivered'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 250.0),
                                  child: Text(
                                    'Package Details',
                                    style: TextStyle(fontSize: 30.0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: _pickupAddress,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    labelText: "Pickup Address",
                                    fillColor: Colors.white70,
                                  ),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _recieverAddress,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    labelText: "Receiver Address",
                                    fillColor: Colors.white70,
                                  ),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _name,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    labelText: "Receiver Name",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _total,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    labelText: "Total Cost",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _email,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    labelText: "Email Address",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _mobile,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    labelText: "Contact Number",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Pick Up Req Accepted?"),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        child: DropdownButton(
                                          value: _pickUpReqValue,
                                          items: const [
                                            DropdownMenuItem(
                                              child: Text("True"),
                                              value: true,
                                            ),
                                            DropdownMenuItem(
                                              child: Text("False"),
                                              value: false,
                                            ),
                                          ],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection('package')
                                                  .doc(widget.pkgId)
                                                  .update({
                                                'pickupreqaccepted': value,
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Package Picked Up?"),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: DropdownButton(
                                        value: _packagepickedUpValue,
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("True"),
                                            value: true,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("False"),
                                            value: false,
                                          ),
                                        ],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('package')
                                                .doc(widget.pkgId)
                                                .update({
                                              'packagePickedUp': value,
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Package Dropped at Op-Center ?"),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: DropdownButton(
                                        value:
                                            _packageDroppedOperationalCenterValue,
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("True"),
                                            value: true,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("False"),
                                            value: false,
                                          ),
                                        ],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('package')
                                                .doc(widget.pkgId)
                                                .update({
                                              'packageDroppedOperationalCenter':
                                                  value,
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Packge Left Op-Center?"),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: DropdownButton(
                                        value:
                                            _packageLeftOperationalCenterValue,
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("True"),
                                            value: true,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("False"),
                                            value: false,
                                          ),
                                        ],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('package')
                                                .doc(widget.pkgId)
                                                .update({
                                              'packageLeftOperationalCenter':
                                                  value,
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Package Delivered ?"),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: DropdownButton(
                                        value: _packageDeliveredValue,
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("True"),
                                            value: true,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("False"),
                                            value: false,
                                          ),
                                        ],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('package')
                                                .doc(widget.pkgId)
                                                .update({
                                              'packageDelivered': value,
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("Please Wait..."),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
