import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/reusable_text.dart';

class Track extends StatefulWidget {
  final String id;

  const Track({Key? key, required this.id}) : super(key: key);

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Track Package Status"),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("package")
                      .doc(widget.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 250.0),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Image(
                                    width: 480,
                                    height: 470,
                                    image: AssetImage('assets/gps.png'),
                                  ),
                                ),
                                const ReusableText(
                                  text: 'Tracking Package Status',
                                  size: 40,
                                  weight: FontWeight.bold,
                                  colour: Colors.black,
                                ),
                                const ReusableText(
                                  text:
                                      'Get deliverd in the time it takes to drive there..',
                                  size: 20.0,
                                  weight: FontWeight.normal,
                                  colour: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 350.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 13, 10, 5),
                                  child: data['pickupreqaccepted'] == true
                                      ? ReusableContainer2()
                                      : ReusableContainer(),
                                ),
                                const Text('Order confirmed',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                                const Icon(
                                  Icons.arrow_downward,
                                  size: 25,
                                ),
                                // Padding(
                                //   padding:EdgeInsets.fromLTRB(10, 0, 10.0, 0)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 15, 10, 10),
                                  child: data['packagePickedUp'] == true
                                      ? ReusableContainer2()
                                      : ReusableContainer(),
                                ),
                                // SizedBox(width: 45),
                                Text('Dispatched',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                                // ),
                                const Icon(
                                  Icons.arrow_downward,
                                  size: 25,
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 15, 10, 10),
                                  child:
                                      data['packageDroppedOperationalCenter'] ==
                                              true
                                          ? ReusableContainer2()
                                          : ReusableContainer(),
                                ),
                                // SizedBox(width: 50),
                                Text('In transist',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                                const Icon(
                                  Icons.arrow_downward,
                                  size: 25,
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 15, 10, 10),
                                  child:
                                      data['packageDroppedOperationalCenter'] ==
                                              true
                                          ? ReusableContainer2()
                                          : ReusableContainer(),
                                ),
                                // SizedBox(width: 42),
                                Text('Destination',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                                const Icon(
                                  Icons.arrow_downward,
                                  size: 25,
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 15, 10, 10),
                                  child: data['packageDelivered'] == true
                                      ? ReusableContainer2()
                                      : ReusableContainer(),
                                ),
                                Text('Delivered',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("Loading Tracking Information...!"),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableContainer extends StatelessWidget {
  const ReusableContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.red,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: const Center(
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReusableContainer2 extends StatelessWidget {
  const ReusableContainer2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(color: Colors.lightGreen),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
