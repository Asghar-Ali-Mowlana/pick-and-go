import 'package:flutter/material.dart';
import 'package:pickandgo/screens/loginpage.dart';
import 'package:pickandgo/screens/user/sendpackage/customerPackagesList.dart';
import 'package:pickandgo/screens/user/sendpackage/receiverdetails.dart';

import '../../../databasehelper.dart';
import '../homepage.dart';
import '../makeacall/makeACall.dart';
import '../profile.dart';
import '../recievepackage/senderdetails.dart';
import '../sendpackage/customerPastPackagesList.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final String role;
  final String email;
  final String id;
  final String name;
  final String mobile;
  final String address;

  NavigationDrawerWidget(
      {required this.role,
      required this.email,
      required this.id,
      required this.name,
      required this.mobile,
      required this.address});

  @override
  DatabaseHelper _db = DatabaseHelper();

  Widget build(BuildContext context) {
    final urlImage =
        'https://static.vecteezy.com/system/resources/previews/002/318/271/non_2x/user-profile-icon-free-vector.jpg';

    return Drawer(
      child: Material(
        color: Colors.black87,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: "User",
              email: "${email}",
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditCustomerDetails(
                  uid: id,
                  name: name,
                  email: email,
                  mobile: mobile,
                  address: address,
                  role: role,
                ),
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
                    text: 'Home',
                    icon: Icons.dashboard,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Send Package',
                    icon: Icons.local_shipping,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Receive Package',
                    icon: Icons.call_received_rounded,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Onging Orders',
                    icon: Icons.pending_rounded,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Past Orders',
                    icon: Icons.check_circle_outline,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Make a Call',
                    icon: Icons.phone,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  // const SizedBox(height: 24),
                  // buildMenuItem(
                  //   text: 'Plugins',
                  //   icon: Icons.account_tree_outlined,
                  //   onClicked: () => selectedItem(context, 4),
                  // ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 6),
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
          builder: (context) => Homepage(
              role: 'role',
              email: 'email',
              id: 'id',
              name: 'name',
              mobile: 'mobile',
              address: 'address'),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ReceiverDetails(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SenderDetails(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ReceivedPackageList(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomerPastPackagesList(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MakeACall(),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
        _db.logout(context);
        break;
    }
  }
}
