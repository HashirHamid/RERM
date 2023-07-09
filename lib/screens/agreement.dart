import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';

class Agreement extends StatefulWidget {
  @override
  State<Agreement> createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  String? image;

  getImage(context) {
    image = Provider.of<ad>(context, listen: false).image1;
  }

  @override
  void initState() {
    getImage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agreement')),
      body: Center(child: Image.network(image.toString())),
    );
  }
}
