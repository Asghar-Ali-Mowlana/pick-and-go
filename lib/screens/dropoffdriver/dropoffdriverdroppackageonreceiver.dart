import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/api/firebase_api.dart';
import 'package:pickandgo/screens/dropoffdriver/dropoffrequests.dart';
import 'package:pickandgo/services/routingpage.dart';
import '../../databasehelper.dart';
import 'dart:io' as d;
import 'package:path/path.dart';
import 'package:universal_io/io.dart' as u;
import 'dart:typed_data';

class DropPackagesDropOffDriver extends StatefulWidget {
  //const DropPackagesDropOffDriver({Key? key}) : super(key: key);

  String? id;
  bool? driveroccupied;
  String? operationalcenterid;
  DropPackagesDropOffDriver(
      this.id,
      this.operationalcenterid,

      this.driveroccupied,);

  @override
  _DropPackagesDropOffDriverState createState() => _DropPackagesDropOffDriverState();
}


class _DropPackagesDropOffDriverState extends State<DropPackagesDropOffDriver> {
  DatabaseHelper _db = DatabaseHelper();
  final controllers = TextEditingController();
  var imagelink;
  var imagelink2;
  UploadTask? task;
  UploadTask? task2;
  String? file;
  String? file2;
  d.File? fileandroid;
  d.File? fileandroid2;
  FilePickerResult? result;
  FilePickerResult? result2;

  @override
  Widget build(BuildContext context) {
    final fileName = fileandroid != null ? basename(fileandroid!.path) : 'No File Selected';
    final fileName2 = fileandroid2 != null ? basename(fileandroid2!.path) : 'No File Selected';
    return SafeArea(child:
    Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Drop a Package'),
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


      body: Padding(
            padding: const EdgeInsets.all(20.0),
         child: SingleChildScrollView(
           child: Column(
        children: [
            const Padding(
              padding: EdgeInsets.all(1),
              child: Text(
                'Package & Receiver Details',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllers,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Package ID...',
                enabled: true,
                contentPadding: const EdgeInsets.only(
                    left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: new BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.black),
                  borderRadius: new BorderRadius.circular(10),
                ),

              ),
              validator: (value) {
                if (value!.length == 0) {
                  return "Receiver name cannot be empty";
                }
              },
              onSaved: (value) {
                controllers.text = value!;
                // setState(() {
                //   recNameController.text = value!;
                // });
              },
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),

              SizedBox(
                height: 25,
              ),
            (u.Platform.operatingSystem=="android")
                ?
                ///Receiver Photo
            Column(
              children: [
                Card(
                    child: Column(
                      children: [
                        Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding( padding: EdgeInsets.all(8),
                                  child: Container(
                                    child: Row(
                                      children: const [
                                        Icon(Icons.insert_photo),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "Add Receiver Photo",
                                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400 ),
                                        ),
                                      ],),
                                  ), ),
                              ),
                            ]),
                        Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0))),
                        height: 25,
                        child: Text(
                          "select file",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        color: Colors.grey,
                        onPressed: selectFile2Android,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0))),
                        child: Text(
                          "upload file",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        height: 25,
                        color: Colors.blueAccent,
                        onPressed: uploadFile2Android,
                      ),
                    ),
                    task2 != null ? buildUploadStatus(task2!) : Text(""),
                  ],
                    ),
                        ///no file selected
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                fileName2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                              ),
                            ),
                          ),

                        ]),
                      ],
                    ),
                ),
                Card(
                  child: Column(
                    children: [
                      Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding( padding: EdgeInsets.all(8),
                                child: Container(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Add Receiver Signature",
                                        style: TextStyle(fontSize:19, fontWeight: FontWeight.w400 ),
                                      ),
                                    ],),
                                ), ),
                            ),
                          ]),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              height: 25,
                              child: Text(
                                "select file",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              color: Colors.grey,
                              onPressed: selectFile1Android,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: Text(
                                "upload file",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              height: 25,
                              color: Colors.blueAccent,
                              onPressed: uploadFile1Android,
                            ),
                          ),
                          task != null ? buildUploadStatus(task!) : Text(""),
                        ],
                      ),
                      ///no signature photo selected
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              fileName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey),
                            ),
                          ),
                        ),

                      ]
                      ),
                    ],
                  ),
                ),
              ],
            )

                :
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0))),
                    height: 25,
                    child: Text(
                      "select windows file",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    color: Colors.grey,
                    onPressed: selectFile,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0))),
                    child: Text(
                      "upload windows file",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    height: 25,
                    color: Colors.blueAccent,
                    onPressed: uploadFile,
                  ),
                ),
                task != null ? buildUploadStatus(task!) : Text(""),
              ],
            ),

            const SizedBox(
              height: 24,
            ),

            MaterialButton(
                minWidth: 160,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                onPressed: () async {

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.id)
                      .get()
                      .then((value) {

                    var x = [];
                    var list = [controllers.text];
                    x = value.data()!['packages'].toList();


                    //print(lala);
                    if (x.length == 1){
                      //assign the typed ingredient into a list

                      FirebaseFirestore.instance
                          .collection('users')
                      //pass the recipe id to know which document/record to update
                          .doc(widget.id)
                      //update method
                          .update({
                        //add the ingredient inside the ingredients array
                        "packages": FieldValue.arrayRemove(list),
                        "driveroccupied": false,
                      });

                      FirebaseFirestore.instance
                          .collection('package')
                      //pass the recipe id to know which document/record to update
                          .doc(controllers.text)
                      //update method
                          .update({
                        //add the ingredient inside the ingredients array
                        "packageDelivered": true,
                        "receiversignature": imagelink,
                        "receiverphoto": imagelink2,
                      });
                      print("Package Dropped Successfully, Package: ${controllers.text}");
                      controllers.text = "";
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: const [
                            Icon(
                              Icons.playlist_add_check,
                              color: Colors.greenAccent,
                            ),
                            SizedBox(width: 20),
                            Expanded(child: Text('Package Added Successfully!')),
                          ],
                        ),
                      ));


                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DropoffDriverRequests(
                        id: widget.id!,


                             operationalcenterid: widget.operationalcenterid,
                              driveroccupied: widget.driveroccupied,
                            )));

                    }else{
                      //assign the typed ingredient into a list

                      FirebaseFirestore.instance
                          .collection('users')
                      //pass the recipe id to know which document/record to update
                          .doc(widget.id)
                      //update method
                          .update({
                        //add the ingredient inside the ingredients array
                        "packages": FieldValue.arrayRemove(list),
                      });

                      FirebaseFirestore.instance
                          .collection('package')
                      //pass the recipe id to know which document/record to update
                          .doc(controllers.text)
                      //update method
                          .update({
                        //add the ingredient inside the ingredients array
                        "packageDelivered": true,
                        "receiversignature": imagelink,
                        "receiverphoto": imagelink2,
                      });
                      print("Package Dropped Successfully, Package: ${controllers.text}");
                      print("Package Receiver Signature, Image Link: ${imagelink}");
                      print("Package Receiver Photo, Image Link: ${imagelink2}");
                      controllers.text = "";
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: const [
                            Icon(
                              Icons.playlist_add_check,
                              color: Colors.greenAccent,
                            ),
                            SizedBox(width: 20),
                            Expanded(child: Text('Package Dropped Successfully!')),
                          ],
                        ),
                      ));
                    }


                  });


                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DropoffDriverRequests(
                        id: widget.id!,


                        operationalcenterid: widget.operationalcenterid,
                        driveroccupied: widget.driveroccupied,
                      )));



                },
                color: Colors.black,
                child: const Text(
                  'Package Delivered',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )),
        ],
      ),
         ),
          ),
    ));
  }







  Future selectFile() async {
    print('OS: ${u.Platform.operatingSystem}');
    try{
      result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);
      setState(() => result = result);
      String filename = basename(result!.files.single.name);
      setState(() => file = filename);

    } catch(e)
    { print(e);
    }


  }

  Future uploadFile() async {
    if(result == null) {
      print("Result is null!");
    }


    if(result != null) {

      try {
        print("Start of upload file method");
        Uint8List uploadfile = result!.files.single.bytes!;

        String filename = basename(result!.files.single.name);

        //final fileName = basename(file!.path);
        final destination = 'recipeimages/$filename';
        print("the destination is $destination");




        final ref = FirebaseStorage.instance.ref(destination);
        task = ref.putData(uploadfile);
        setState(() {});
        print("Total bytes $task");
        print("Total bytes ${task!.snapshot.totalBytes}");


        if (task == null) return;
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        print('Download-Link: $urlDownload');

        imagelink = urlDownload;

        setState(() => imagelink = urlDownload);


      } catch (e) {
        print(e);
      }
    }

  }

  Future selectFile1Android() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => fileandroid = d.File(path));
  }

  Future selectFile2Android() async {
    final result2 = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result2 == null) return;
    final path = result2.files.single.path!;

    setState(() => fileandroid2 = d.File(path));
  }

  Future uploadFile1Android() async {
    if (fileandroid == null) return;

    final fileName = basename(fileandroid!.path);
    final destination = 'receiverimages/$fileName';

    task = FirebaseApi.uploadFile(destination, fileandroid!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();



    print('Download-Link: $urlDownload');

    imagelink = urlDownload;
  }



  Future uploadFile2Android() async {
    if (fileandroid2 == null) return;

    final fileName2 = basename(fileandroid2!.path);
    final destination = 'receiverimages/$fileName2';

    task2 = FirebaseApi.uploadFile(destination, fileandroid2!);
    setState(() {});

    if (task2 == null) return;

    final snapshot = await task2!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    imagelink2 = urlDownload;
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );







}
