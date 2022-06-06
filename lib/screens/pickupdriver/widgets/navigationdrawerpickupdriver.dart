import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/loginpage.dart';
import 'package:pickandgo/screens/pickupdriver/pickuprequests.dart';

import '../../../databasehelper.dart';
import '../pickupdriverdashboard.dart';
import '../pickupdriverprofile.dart';
import '../pickuppastdeliveries.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  final String id;
  bool? driveroccupied;
  String? operationalcenterid;
  // final String mobile;
  // final String address;

  NavigationDrawerWidget(
      {required this.id, this.operationalcenterid, this.driveroccupied
      // required this.mobile,
      // required this.address
      });

  final admin_email = FirebaseAuth.instance.currentUser?.email;
  final adsmin_email = FirebaseAuth.instance.currentUser?.displayName;

  @override
  DatabaseHelper _db = DatabaseHelper();

  Widget build(BuildContext context) {
    // final name = 'Admin';
    // final email = 'admin@pickandgo.lk';

    final urlImage =
        'https://static.vecteezy.com/system/resources/previews/002/318/271/non_2x/user-profile-icon-free-vector.jpg';

    return Drawer(
      child: Material(
        //color: Color.fromRGBO(50, 75, 205, 1),
        color: Colors.black87,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: "Pick-Up Driver",
              email: "${admin_email}",
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PickupDriverProfile(
                    id: id,
                    driveroccupied: driveroccupied,
                    operationalcenterid: operationalcenterid),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // buildSearchField(),
                  // const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Dashboard',
                    icon: Icons.dashboard,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Pickup Requests',
                    icon: Icons.notifications_active,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Past Deliveries',
                    icon: Icons.check_circle_outline,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Profile',
                    icon: Icons.person,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //build header
  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              // Spacer(),
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PickupDriverDashboard(
            driveroccupied: driveroccupied,
            operationalcenterid: operationalcenterid,
            id: id,
          ),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PickupDriverPickupRequests(
            driveroccupied: driveroccupied,
            operationalcenterid: operationalcenterid,
            id: id,
          ),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PickupPastDeliveries(
            driveroccupied: driveroccupied,
            operationalcenterid: operationalcenterid,
            id: id,
          ),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PickupDriverProfile(
            driveroccupied: driveroccupied,
            operationalcenterid: operationalcenterid,
            id: id,
          ),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
        _db.logout(context);
        break;
    }
  }
}
