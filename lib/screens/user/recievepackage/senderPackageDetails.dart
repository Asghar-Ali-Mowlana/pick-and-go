import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/screens/user/recievepackage/confirmReceiverLocation.dart';
import 'package:pickandgo/screens/user/sendpackage/confirmCustomerLocation.dart';
//import 'package:pickandgo/screens/user/sendpackage/connecttodriver.dart';
import 'package:pickandgo/screens/user/sendpackage/receiverdetails.dart';
import 'package:pickandgo/services/routingpage.dart';
import 'package:universal_io/io.dart' as u;

class SenderPackageDetails extends StatefulWidget {
  final String senderName;
  final String senderEmail;
  final String senderAddress;
  final String senderPostalCode;
  final String senderContactNo;
  final double pickUpLatitude;
  final double pickUpLongitude;

  SenderPackageDetails(
      this.senderName,
      this.senderEmail,
      this.senderAddress,
      this.senderPostalCode,
      this.senderContactNo,
      this.pickUpLatitude,
      this.pickUpLongitude);

  //const SenderPackageDetails({Key? key}) : super(key: key);

  @override
  State<SenderPackageDetails> createState() => _SenderPackageDetailsState();
}

class _SenderPackageDetailsState extends State<SenderPackageDetails> {
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController packageDescController =
      new TextEditingController();
  final TextEditingController packageLengthController =
      new TextEditingController();
  final TextEditingController packageHeightController =
      new TextEditingController();
  final TextEditingController packageWidthController =
      new TextEditingController();
  final TextEditingController packageWeightController =
      new TextEditingController();

  final _auth = FirebaseAuth.instance;

  DatabaseHelper _db = DatabaseHelper();

  String dropdownValue = 'Bike';

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick Up Request'),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => ReceiverDetails(),
                          ),
                        );
                      },
                      // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  },
                ),
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
              //body: PackageDetailsForm(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white10,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(22),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: const <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(1),
                                        // child: Text('What do you wish to send?',
                                        //   style: TextStyle(fontSize: 40.0),),
                                        //child: Text('${widget.receiverName} color was passed'),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'If default maximum package weight exceeds, you will',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Center(
                                        child: Text(
                                          'be billed separately.',
                                          style: TextStyle(fontSize: 17.0),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: packageDescController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Product Description',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Product description cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    packageDescController.text = value!;
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Vehicle Type"),
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      items: <String>['Bike', 'Lorry']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  // maxLines: 5,
                                  // minLines: 3,
                                  controller: packageLengthController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Package Length (In inches)',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Package weight cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    packageLengthController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: packageHeightController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Package Height (In inches)',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Package height cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    packageHeightController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: packageWidthController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Package Width (In inches)',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Package width cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    packageWidthController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: packageWeightController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText:
                                        'Package Weight (In kg - Max 20kg)',
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return "Package weight cannot be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    packageWeightController.text = value!;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // MaterialButton(
                                    //   shape: const RoundedRectangleBorder(
                                    //       borderRadius:
                                    //       BorderRadius.all(Radius.circular(10.0))),
                                    //   elevation: 5.0,
                                    //   height: 40,
                                    //   onPressed: () {
                                    //     setState(() {
                                    //       visible = true;
                                    //     });
                                    //     signIn(emailController.text,
                                    //         passwordController.text);
                                    //   },
                                    //   child: const Text(
                                    //     "Login",
                                    //     style: const TextStyle(
                                    //       fontSize: 20,
                                    //     ),
                                    //   ),
                                    //   color: Colors.white,
                                    // ),
                                    MaterialButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          _formkey.currentState!.save();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmReceiverLocation(
                                                      widget.senderName,
                                                      widget.senderEmail,
                                                      widget.senderAddress,
                                                      widget.senderPostalCode,
                                                      widget.senderContactNo,
                                                      widget.pickUpLatitude,
                                                      widget.pickUpLongitude,
                                                      packageDescController
                                                          .text,
                                                      dropdownValue,
                                                      double.parse(
                                                          packageLengthController
                                                              .text),
                                                      double.parse(
                                                          packageHeightController
                                                              .text),
                                                      double.parse(
                                                          packageWidthController
                                                              .text),
                                                      double.parse(
                                                          packageWeightController
                                                              .text)),
                                            ),
                                          );
                                        }
                                      },
                                      color: Colors.black,
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    '${widget.senderName}, ${widget.senderEmail}, ${widget.senderAddress}')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Pick Up Request'),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => ReceiverDetails(),
                          ),
                        );
                      },
                      // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  },
                ),
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
              //body: PackageDetailsForm(),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white10,
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.height * 0.90,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(22),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: const <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(1),
                                          // child: Text('What do you wish to send?',
                                          //   style: TextStyle(fontSize: 40.0),),
                                          //child: Text('${widget.receiverName} color was passed'),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Text(
                                          'If default maximum package weight exceeds, you will',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          'be billed separately.',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: packageDescController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Product Description',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length == 0) {
                                        return "Product description cannot be empty";
                                      }
                                    },
                                    onSaved: (value) {
                                      packageDescController.text = value!;
                                    },
                                    keyboardType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    // maxLines: 5,
                                    // minLines: 3,
                                    controller: packageLengthController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Package Length (In cm)',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length == 0) {
                                        return "Package weight cannot be empty";
                                      }
                                    },
                                    onSaved: (value) {
                                      packageLengthController.text = value!;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: packageHeightController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Package Height (In cm)',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 15.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Package height cannot be empty";
                                      }
                                    },
                                    onSaved: (value) {
                                      packageHeightController.text = value!;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: packageWidthController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Package Width (In cm)',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length == 0) {
                                        return "Package width cannot be empty";
                                      }
                                    },
                                    onSaved: (value) {
                                      packageWidthController.text = value!;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: packageWeightController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText:
                                          'Package Weight (In kg - Max 20kg)',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.green),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length == 0) {
                                        return "Package weight cannot be empty";
                                      }
                                    },
                                    onSaved: (value) {
                                      packageWeightController.text = value!;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // MaterialButton(
                                      //   shape: const RoundedRectangleBorder(
                                      //       borderRadius:
                                      //       BorderRadius.all(Radius.circular(10.0))),
                                      //   elevation: 5.0,
                                      //   height: 40,
                                      //   onPressed: () {
                                      //     setState(() {
                                      //       visible = true;
                                      //     });
                                      //     signIn(emailController.text,
                                      //         passwordController.text);
                                      //   },
                                      //   child: const Text(
                                      //     "Login",
                                      //     style: const TextStyle(
                                      //       fontSize: 20,
                                      //     ),
                                      //   ),
                                      //   color: Colors.white,
                                      // ),
                                      MaterialButton(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        elevation: 5.0,
                                        height: 40,
                                        onPressed: () {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            _formkey.currentState!.save();
                                            /*Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ConnectToDriver(
                                                        widget.receiverName,
                                                        widget.receiverEmail,
                                                        widget.receiverAddress,
                                                        widget
                                                            .receiverPostalCode,
                                                        widget
                                                            .receiverContactNo,
                                                        packageDescController
                                                            .text,
                                                        packageLengthController
                                                            .text,
                                                        packageHeightController
                                                            .text,
                                                        packageWidthController
                                                            .text,
                                                        packageWeightController
                                                            .text),
                                              ),
                                            );*/
                                          }
                                        },
                                        color: Colors.black,
                                        child: const Text(
                                          "Next",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      '${widget.senderName}, ${widget.senderEmail}, ${widget.senderAddress}')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
