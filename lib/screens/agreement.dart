import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';

class Agreement extends StatefulWidget {
  @override
  State<Agreement> createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  String? image;
  var _isLoading = true;
  getImage() {
    image = Provider.of<ad>(context, listen: false).image1;
  }

  @override
  void initState() {
    Provider.of<ad>(context, listen: false).getAgreement().then((value) {
      getImage();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agreement')),
      body: Center(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : image.toString() == ''
                  ? Center(
                      child: Text('No agreement to show'),
                    )
                  : Image.network(image.toString())),
    );
  }
}
