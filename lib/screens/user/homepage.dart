import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/databasehelper.dart';
import 'package:pickandgo/models/reusable_button.dart';
import 'package:pickandgo/models/reusable_text.dart';
import 'package:pickandgo/screens/user/recievepackage/senderdetails.dart';
import 'package:pickandgo/screens/user/sendpackage/receiverdetails.dart';
import 'package:pickandgo/screens/user/widgets/navigationdrawer.dart';
import 'package:pickandgo/services/routingpage.dart';
import 'package:universal_io/io.dart' as u;

import 'makeacall/makeACall.dart';

class Homepage extends StatefulWidget {
  final String role;
  final String email;
  final String id;
  final String name;
  final String mobile;
  final String address;

  Homepage(
      {required this.role,
      required this.email,
      required this.id,
      required this.name,
      required this.mobile,
      required this.address});

  //const Homepagey({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return (u.Platform.operatingSystem == "android")
        ? SafeArea(
            child: Scaffold(
              drawer: NavigationDrawerWidget(
                id: widget.id,
                name: widget.name,
                email: widget.email,
                mobile: widget.mobile,
                address: widget.address,
                role: widget.role,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Home Screen'),
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                height: 25,
                                child: const Icon(
                                  Icons.info_sharp,
                                  size: 25,
                                ),
                              ),
                              Container(
                                height: 40,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'What to send',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Image(
                        width: 300,
                        height: 260,
                        image: AssetImage('assets/homepage.png'),
                      ),
                    ),
                    const ReusableText(
                      text: 'Send Packages with',
                      size: 30,
                      weight: FontWeight.bold,
                      colour: Colors.black,
                    ),
                    const ReusableText(
                      text: 'Connect',
                      size: 30,
                      weight: FontWeight.bold,
                      colour: Colors.black,
                    ),
                    const ReusableText(
                      text: 'Get deliverd in the time it takes to drive',
                      size: 16.0,
                      weight: FontWeight.normal,
                      colour: Colors.grey,
                    ),
                    const ReusableText(
                      text: 'there',
                      size: 18.0,
                      weight: FontWeight.normal,
                      colour: Colors.grey,
                    ),
                    const SizedBox(height: 20.0),
                    ReusableButton(
                      text: 'Send a package',
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReceiverDetails()),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ReusableButton(
                      text: 'Receive a package',
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SenderDetails()),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ReusableButton(
                      text: 'Make a call',
                      function: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MakeACall()),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              drawer: NavigationDrawerWidget(
                id: widget.id,
                name: widget.name,
                email: widget.email,
                mobile: widget.mobile,
                address: widget.address,
                role: widget.role,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Home Screen'),
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                height: 25,
                                child: const Icon(
                                  Icons.info_sharp,
                                  size: 25,
                                ),
                              ),
                              Container(
                                height: 40,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'What to send',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 140.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Image(
                                  width: 480,
                                  height: 470,
                                  image: AssetImage('assets/homepage.png'),
                                ),
                              ),
                              const ReusableText(
                                text: 'Send Packages with Connect',
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
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(180.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ReusableButton(
                                text: 'Send a package',
                                function: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReceiverDetails()),
                                  );
                                },
                              ),
                              const SizedBox(height: 20.0),
                              ReusableButton(
                                text: 'Receive a package',
                                function: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SenderDetails()),
                                  );
                                },
                              ),
                              const SizedBox(height: 20.0),
                              ReusableButton(
                                text: 'Make a call',
                                function: () async {},
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
