import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/auth.dart';
import 'package:rsms/screens/dashboard_screen.dart';
import 'package:rsms/screens/post-ad.dart';
import 'package:rsms/screens/reports.dart';

import '../screens/agreement.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('RSMS!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          auth.rentee == true
              ? Container()
              : ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add Property'),
                  onTap: () {
                    Navigator.of(context).pushNamed(PostAd.routeName);
                  },
                ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search Properties'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          auth.rentee == false
              ? Container()
              : ListTile(
                  leading: Icon(Icons.space_dashboard_outlined),
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
          ListTile(
            leading: Icon(Icons.handshake),
            title: Text('View agreement'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Agreement()));
            },
          ),
          auth.rentee == false
              ? Container()
              : ListTile(
                  leading: Icon(Icons.file_present_rounded),
                  title: Text('View inspection report'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => Reports())));
                  },
                ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).errorColor,
            ),
            title: Text('Log Out'),
            textColor: Theme.of(context).errorColor,
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
