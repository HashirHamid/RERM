import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/screens/myads-screen.dart';
import 'package:rsms/screens/search-screen.dart';
import 'package:rsms/screens/settings-screen.dart';
import 'package:rsms/screens/welcome-screen.dart';
import 'package:rsms/widgets/app_drawer.dart';

import '../providers/auth.dart';

class BottomNavBar extends StatefulWidget {
  static const routeName = 'bottom';

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  var _titles = ['Home', 'Search', 'My Ads', 'Settings'];

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    return Scaffold(
        drawer: AppDrawer(),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.lightBlueAccent,
          index: _page,
          color: Theme.of(context).primaryColor,
          items: authData.rentee == true
              ? [
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "Home",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "Search",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.settings,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "My Receipt",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ]
              : [
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "Home",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "Search",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.favorite_border_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "My Ads",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.miscellaneous_services,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: "Account",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
          onTap: (index) {
            setState(() {
              this._page = index;
            });
          },
        ),
        body: authData.rentee == true
            ? _page == 0
                ? WelcomeScreen()
                : _page == 1
                    ? SearchScreen()
                    : _page == 2
                        ? SettingsScreen()
                        : null
            : _page == 0
                ? WelcomeScreen()
                : _page == 1
                    ? SearchScreen()
                    : _page == 2
                        ? MyAdsScreen()
                        : _page == 3
                            ? SettingsScreen()
                            : null);
  }
}
