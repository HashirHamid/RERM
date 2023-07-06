import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rsms/screens/ad-details-screen.dart';

import '../providers/products_provider.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double? price;
  final String location;
  final String description;
  final String state;

  ProductItem(this.id, this.title, this.imageUrl, this.price, this.location,
      this.description, this.state);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<ad>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);
    // final authData = Provider.of<Auth>(context, listen: false);
    NumberFormat numberFormat = NumberFormat.decimalPattern('en_us');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
            arguments: {'id': this.id, "flag": false});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(221, 200, 199, 199)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      title.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "Rs ${numberFormat.format(price)}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      state,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
          // child: GridTileBar(
          //   backgroundColor: Colors.black87,
          //   leading: Consumer<ad>(
          //     builder: (ctx, product, child) => IconButton(
          //       icon:
          //           // Icon(
          //           // product.isFavorite ? Icons.favorite : Icons.favorite_border),
          //           Icon(Icons.abc),
          //       color: Theme.of(context).accentColor,
          //       onPressed: () {
          //         // product.toggleFavStatus(authData.token, authData.userId);
          //       },
          //     ),
          //   ),
          //   title: Text(
          //     product.title,
          //     textAlign: TextAlign.center,
          //   ),
          //   trailing: IconButton(
          //     icon: Icon(Icons.shopping_cart),
          //     color: Theme.of(context).accentColor,
          //     onPressed: () {
          //       // cart.addItem(product.id, product.price, product.title);
          //       // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //       // ScaffoldMessenger.of(context).showSnackBar(
          //       //   SnackBar(
          //       //     content: Text(
          //       //       'Added item to cart!',
          //       //     ),
          //       //     duration: Duration(seconds: 2),
          //       //     action: SnackBarAction(
          //       //       label: 'Undo',
          //       //       onPressed: () {
          //       //         cart.removeSingleItem(product.id);
          //       //       },
          //       //     ),
          //       //   ),
          //       // );
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }
}
