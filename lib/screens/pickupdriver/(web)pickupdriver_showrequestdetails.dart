import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/pickupdriver/pickuprequests.dart';
import 'package:universal_io/io.dart' as u;

class WebShowRequestDetails extends StatefulWidget {
  String packageId;
  String operationalcenterid;
  String id;

  WebShowRequestDetails(this.id, this.operationalcenterid,this.packageId);
  //const WebShowRequestDetails({Key? key}) : super(key: key);

  @override
  State<WebShowRequestDetails> createState() => _WebShowRequestDetailsState();
}

class _WebShowRequestDetailsState extends State<WebShowRequestDetails> {
  bool _isLoading = true;

  late String vehicleType;

  late String packageDescription;

  late String packageId;
  late String pickUpAddress;
  late String pickUpDriverId;
  late String receiverAddress;
  late String receiverContactNumber;
  bool? packagePickedUp;

  late String receiverName;

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
        packageDescription = documentSnapshot['packageDescription'];
        pickUpAddress = documentSnapshot['pickupAddress'];
        pickUpDriverId = documentSnapshot['pickupdriverid'];
        receiverAddress = documentSnapshot['receiverAddress'];
        receiverContactNumber = documentSnapshot['receiverContactNo'];
        receiverName = documentSnapshot['receiverName'];
        packagePickedUp = documentSnapshot['packagePickedUp'];

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
    return
        Scaffold(
            appBar: AppBar(
              title: Text("Package Details"),
              backgroundColor: Colors.black,
            ),
            body: (_isLoading==true && packagePickedUp==null)
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
                              Text("Sender Contact - ${senderContact}",
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
                  
                              SizedBox(
                                height: 10,
                              ),
                     
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Package ID - ${widget.packageId}",
                                  style: TextStyle(fontSize: 14)),
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
                          
                              SizedBox(
                                height: 10,
                              ),
                     
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
              
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                          (packagePickedUp==false)
                          ?Center(
                            child: MaterialButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PickupDriverPickupRequests(

                                                id: widget.id,
                                                driveroccupied: true,
                                                operationalcenterid: widget.operationalcenterid,

                                                //     id: id,
                                              )));

                                  FirebaseFirestore.instance
                                      .collection('package')
                                      .doc(widget.packageId)
                                  //update method
                                      .update({
                                    //add the user id inside the favourites array
                                    "packagePickedUp": true
                                  });
                                },
                                child: Text("Picked up")),
                          )


                          :Center(
                            child: MaterialButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: () {
                                  //_stopListening();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         MyApp()));
                                  FirebaseFirestore.instance
                                      .collection('package')
                                      .doc(widget.packageId)
                                  //update method
                                      .update({
                                    //add the user id inside the favourites array
                                    "packageDroppedOperationalCenter":
                                    true,
                                  });

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.id)
                                  //update method
                                      .update({
                                    //add the user id inside the favourites array
                                    "driveroccupied": false,
                                    "packageid": "",
                                  });


                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PickupDriverPickupRequests(

                                                id: widget.id,
                                                driveroccupied: true,
                                                operationalcenterid: widget.operationalcenterid,

                                                //     id: id,
                                              )));
                                },
                                child: Text("Package Dropped")),
                          ),
                        ],
                      ),
                    ),
                  ));

  }
}
