import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  // final bool showFavs;
  final String searchedAd;
  final String stateAd;
  final String cityAd;
  List<ad> products = [];
  ProductsGrid(this.searchedAd, this.stateAd, this.cityAd);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ad>(context);
    products = productsData.items
        .where((element) =>
            element.title!.toLowerCase().contains(searchedAd.toLowerCase()))
        .toList();
    products = products.where((element) => element.owned == false).toList();
    products = products
        .where((element) =>
            element.state!.toLowerCase().contains(stateAd.toLowerCase()))
        .toList();

    products = products
        .where((element) =>
            element.city!.toLowerCase().contains(cityAd.toLowerCase()))
        .toList();

    // final products = showFavs ? productsData.favoriteItems : productsData.items;
    return products.length == 0
        ? Center(child: Text('No ads found!'))
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(
                  products[i].id.toString(),
                  products[i].title.toString(),
                  products[i].image![0],
                  products[i].price,
                  products[i].location.toString(),
                  products[i].description.toString(),
                  products[i].state.toString()),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
