import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/providers/reports.dart';
import 'package:rsms/widgets/ratings.dart';
import 'package:rsms/widgets/slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dialogbox.dart';

enum FilterOptions {
  LeaveHouse,
}

class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // ProductDetailScreen(this.title);
  static const routeName = '/ad-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as Map;
    final flag = productId['flag'];
    final products = Provider.of<ad>(
      context,
      listen: false,
    ).findById(productId['id']);
    NumberFormat numberFormat = NumberFormat.decimalPattern('en_us');
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.black.withOpacity(.4),
                          Colors.transparent
                        ], begin: Alignment.topCenter, end: Alignment.center),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25)),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: 300,
                        child: SliderImage(2, products.image!)),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 12),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Colors.white,
                          )),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rs ${numberFormat.format(products.price)}',
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 29,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          products.title.toString(),
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        Text(
                          'Details',
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Type",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Rent",
                              style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          products.description.toString(),
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        Text(
                          "Reviews",
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            height: 200,
                            width: double.infinity,
                            child: RatingWidget(products.rating!))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 72,
              width: double.infinity,
              color: Colors.blue,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse('tel://111-111-111'));
                        },
                        child: Text(
                          'Contact',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    Divider(
                      height: 2,
                    ),
                    flag
                        ? Container()
                        : TextButton(
                            onPressed: () async {
                              await Provider.of<report>(context, listen: false)
                                  .request(
                                      products.title.toString(),
                                      products.description.toString(),
                                      products.id.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "A request for inspection has been sent!"),
                              ));
                            },
                            child: Text(
                              '  Request \nInspection',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                  ]),
            ),
          )
        ],
      ),
    ));
  }
}
