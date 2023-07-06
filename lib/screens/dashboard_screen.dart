import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/widgets/user-add-item.dart';

import '../widgets/app_drawer.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ad>(context, listen: false).getData();
    await Provider.of<ad>(context, listen: false).myAd();
  }

  @override
  Widget build(BuildContext context) {
    final ads = Provider.of<ad>(context, listen: false);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('My House'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: ((context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<ad>(
                    builder: (context, ad1, _) => ad1.filtered.length == 0
                        ? Center(child: Text("No ads found!"))
                        : Column(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: ListView.builder(
                                    itemBuilder: (_, i) => Column(
                                      children: [
                                        ad1.filtered[0].ad.toString().endsWith(
                                                ad1.items[i].id.toString())
                                            ? UserAddItem(
                                                ad1.items[i],
                                                ad1.filtered[0].id.toString(),
                                                ad1.items[i].id.toString(),
                                                ad1.items[i].title.toString(),
                                                ad1.items[i].image![0],
                                                ad1.items[i].description
                                                    .toString())
                                            : Container(),
                                      ],
                                    ),
                                    itemCount: ad1.items.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ))));
  }
}
