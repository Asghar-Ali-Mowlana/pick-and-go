import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as u;

class PastPackageDetails extends StatefulWidget {
  String packageId;
  String id;

  PastPackageDetails(this.id, this.packageId);
  //const PastPackageDetails({Key? key}) : super(key: key);

  @override
  State<PastPackageDetails> createState() => _PastPackageDetailsState();
}

class _PastPackageDetailsState extends State<PastPackageDetails> {
  bool _isLoading = true;

  late String vehicleType;
  late String deliveryDriverId;
  late String operationalCenterDriverId;
  late String fromOperationalcenterId;
  late String packageDescription;
  late double packageWeight;
  late String packageId;
  late String pickUpAddress;
  late String pickUpDriverId;
  late String receiverAddress;
  late String receiverContactNumber;
  late String receiverEmail;
  late String receiverName;
  late String receiverPhoto;
  late String receiverSignature;
  late String toOperationalCenterId;
  late double totalCost;

  _getPackageData() async {
    await FirebaseFirestore.instance
        .collection('package')
        .doc(widget.packageId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        vehicleType = documentSnapshot['Vehicle Type'];
        deliveryDriverId = documentSnapshot['deliverydriverid'];
        fromOperationalcenterId = documentSnapshot['operationalcenterid'];
        packageDescription = documentSnapshot['packageDescription'];
        packageWeight = documentSnapshot['packageWeight'];
        pickUpAddress = documentSnapshot['pickupAddress'];
        pickUpDriverId = documentSnapshot['pickupdriverid'];
        receiverAddress = documentSnapshot['receiverAddress'];
        receiverContactNumber = documentSnapshot['receiverContactNo'];
        receiverEmail = documentSnapshot['receiverEmail'];
        receiverName = documentSnapshot['receiverName'];
        receiverPhoto = documentSnapshot['receiverphoto'];
        receiverSignature = documentSnapshot['receiversignature'];
        toOperationalCenterId = documentSnapshot['toOperationalCenterId'];
        totalCost = documentSnapshot['totalCost'];
        operationalCenterDriverId =
            documentSnapshot['operationalCenterDriverId'];
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
                              Text("Receiver Photo",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.network(receiverPhoto)),
                              SizedBox(
                                height: 35,
                              ),
                              Text("Receiver Signature",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.network(receiverSignature)),
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
                              Text(
                                  "Operational Center Driver ID - ${operationalCenterDriverId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Delivery Driver ID - ${deliveryDriverId}",
                                  style: TextStyle(fontSize: 14)),
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
                                  "From Operational Center - ${fromOperationalcenterId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "To Operational Center - ${toOperationalCenterId}",
                                  style: TextStyle(fontSize: 14)),
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
                              Text("Receiver Photo",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.network(receiverPhoto)),
                              SizedBox(
                                height: 35,
                              ),
                              Text("Receiver Signature",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.network(receiverSignature)),
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
                              Text(
                                  "Operational Center Driver ID - ${operationalCenterDriverId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Delivery Driver ID - ${deliveryDriverId}",
                                  style: TextStyle(fontSize: 14)),
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
                                  "From Operational Center - ${fromOperationalcenterId}",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "To Operational Center - ${toOperationalCenterId}",
                                  style: TextStyle(fontSize: 14)),
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
