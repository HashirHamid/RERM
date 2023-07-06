import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/screens/search-screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/productsGrid.dart';

class ListScreen extends StatefulWidget {
  static const routeName = 'list-screen';

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var _flag = true;
  var _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    if (_flag) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ad>(context, listen: false).getData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _flag = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final filters =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final searchedAd = filters['search'];
    final stateAd = filters['state'];
    final cityAd = filters['city'];
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height * 1.0,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: Icon(Icons.menu)),
                      Expanded(
                        child: TextField(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SearchScreen.routeName);
                          },
                          onChanged: (value) {},
                          style: const TextStyle(color: Colors.grey),
                          showCursor: false,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color.fromRGBO(241, 245, 254, 1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search...",
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoading == true
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: ProductsGrid(searchedAd!, stateAd!, cityAd!),
                      ),
              ],
            ),
          ),
        ));
  }
}
