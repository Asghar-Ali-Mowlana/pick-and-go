import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as u;

class PickupDriverPastOrderDetails extends StatefulWidget {
  String? packageId;
  String? id;

  PickupDriverPastOrderDetails(this.id, this.packageId);
  //const PickupDriverPastOrderDetails({Key? key}) : super(key: key);

  @override
  State<PickupDriverPastOrderDetails> createState() => _PickupDriverPastOrderDetailsState();
}

class _PickupDriverPastOrderDetailsState extends State<PickupDriverPastOrderDetails> {
  bool _isLoading = true;

   String? vehicleType;
   String? fromOperationalcenterId;
   String? packageDescription;
   double? packageWeight;
   String? packageId;
   String? pickUpAddress;
   String? pickUpDriverId;
   String? receiverAddress;
   String? receiverContactNumber;
   String? receiverEmail;
   String? receiverName;

  double? totalCost;

  String? senderName;
  String? senderContact;




  _getPackageData() async {
    await FirebaseFirestore.instance
        .collection('package')
        .doc(widget.packageId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        vehicleType = documentSnapshot['Vehicle Type'];
        fromOperationalcenterId = documentSnapshot['operationalcenterid'];
        packageDescription = documentSnapshot['packageDescription'];
        packageWeight = documentSnapshot['packageWeight'];
        pickUpAddress = documentSnapshot['pickupAddress'];
        pickUpDriverId = documentSnapshot['pickupdriverid'];
        receiverAddress = documentSnapshot['receiverAddress'];
        receiverContactNumber = documentSnapshot['receiverContactNo'];
        receiverEmail = documentSnapshot['receiverEmail'];
        receiverName = documentSnapshot['receiverName'];
        totalCost = documentSnapshot['totalCost'];
        FirebaseFirestore.instance
            .collection('users')
            .doc(documentSnapshot['userid'])
            .get()
            .then((value) {
          senderName = value.data()!['name'].toString();
          senderContact = value.data()!['mobile'].toString();
        });
      } else {
        print('The package document does not exist');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPackageData();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? Scaffold(
            appBar: AppBar(
              title: Text("Delivery Details"),
              backgroundColor: Colors.black,
            ),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sender Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sender Name - ${senderName}",
                                  style: TextStyle(fontSize: 14)),
                              Text("Sender Mobile - ${senderContact}",
                                  style: TextStyle(fontSize: 14)),
                              Text("Sender Address - ${pickUpAddress}",
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Receiver Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Receiver Name - ${receiverName}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Receiver Email - ${receiverEmail}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Receiver Contact Number - ${receiverContactNumber}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Receiver Address - ${receiverAddress}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 35,
                              ),

                            ],
                          ),

                          Text("Package Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Package Cost - LKR ${totalCost}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Package Weight - ${packageWeight} kg",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Package Description - ${packageDescription}",
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Driver Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pickup Driver ID - ${pickUpDriverId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Operational Center Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Operational Center - ${fromOperationalcenterId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),

                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
        : Scaffold(
            appBar: AppBar(
              title: Text("Package Details"),
              backgroundColor: Colors.black,
            ),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sender Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sender Address - ${pickUpAddress}",
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Receiver Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Receiver Name - ${receiverName}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Receiver Email - ${receiverEmail}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Receiver Contact Number - ${receiverContactNumber}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Receiver Address - ${receiverAddress}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 35,
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              SizedBox(
                                height: 35,
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Package Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Package Cost - LKR ${totalCost}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Package Weight - ${packageWeight} kg",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Package Description - ${packageDescription}",
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Driver Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pickup Driver ID - ${pickUpDriverId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text("Operational Center Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Operational Center - ${fromOperationalcenterId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),

                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
  }
}
