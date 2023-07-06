import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/screens/post-ad.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user-card-items.dart';

class MyAdsScreen extends StatelessWidget {
  static const routeName = 'user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ad>(context, listen: false).getData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('My Ads'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(PostAd.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: ((context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<ad>(
                        builder: (context, ad1, _) => Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: ListView.builder(
                                  itemBuilder: (_, i) => Column(
                                    children: [
                                      UserCardItem(
                                          ad1.items[i].id.toString(),
                                          ad1.items[i].title.toString(),
                                          ad1.items[i].image![0].toString()),
                                      const Divider()
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
