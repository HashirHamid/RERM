import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rsms/models/owned.dart';
import 'package:rsms/providers/products_provider.dart';

import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  File? _image;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ad>(context, listen: false).myAd();
  }

  Future getImage(bool isCamera) async {
    XFile? image;
    if (isCamera) {
      image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    File file = File(image!.path);
    setState(() {
      _image = file;
    });
  }

  void _submit(Owned owned, String mon) async {
    final id = owned.id;
    if (_image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImage")
          .child(DateTime.now().toString() + ".jpg");
      await ref.putFile(File(_image!.path));
      final url = await ref.getDownloadURL();

      final uri =
          'https://rsms-3e512-default-rtdb.firebaseio.com/ownedHouses/${id}.json';
      final url1 = Uri.parse(uri);
      try {
        final response = await http.patch(url1,
            body: json.encode({
              'ad': owned.ad,
              'uid': owned.uid,
              'payments': {
                'January': {
                  'status': mon == 'January'
                      ? 'pending'
                      : owned.months!['January']['status'],
                  'image':
                      mon == 'January' ? url : owned.months!['January']['image']
                },
                'February': {
                  'status': mon == 'February'
                      ? 'pending'
                      : owned.months!['February']['status'],
                  'image': mon == 'February'
                      ? url
                      : owned.months!['February']['image']
                },
                'March': {
                  'status': mon == 'March'
                      ? 'pending'
                      : owned.months!['March']['status'],
                  'image':
                      mon == 'March' ? url : owned.months!['March']['image']
                },
                'April': {
                  'status': mon == 'April'
                      ? 'pending'
                      : owned.months!['April']['status'],
                  'image':
                      mon == 'April' ? url : owned.months!['April']['image']
                },
                'May': {
                  'status':
                      mon == 'May' ? 'pending' : owned.months!['May']['status'],
                  'image': mon == 'May' ? url : owned.months!['May']['image']
                },
                'June': {
                  'status': mon == 'June'
                      ? 'pending'
                      : owned.months!['June']['status'],
                  'image': mon == 'June' ? url : owned.months!['June']['image']
                },
                'July': {
                  'status': mon == 'July'
                      ? 'pending'
                      : owned.months!['July']['status'],
                  'image': mon == 'July' ? url : owned.months!['July']['image']
                },
                'August': {
                  'status': mon == 'August'
                      ? 'pending'
                      : owned.months!['August']['status'],
                  'image':
                      mon == 'August' ? url : owned.months!['August']['image']
                },
                'September': {
                  'status': mon == 'September'
                      ? 'pending'
                      : owned.months!['September']['status'],
                  'image': mon == 'September'
                      ? url
                      : owned.months!['September']['image']
                },
                'October': {
                  'status': mon == 'October'
                      ? 'pending'
                      : owned.months!['October']['status'],
                  'image':
                      mon == 'October' ? url : owned.months!['October']['image']
                },
                'November': {
                  'status': mon == 'November'
                      ? 'pending'
                      : owned.months!['November']['status'],
                  'image': mon == 'November'
                      ? url
                      : owned.months!['November']['image']
                },
                'December': {
                  'status': mon == 'December'
                      ? 'pending'
                      : owned.months!['December']['status'],
                  'image': mon == 'December'
                      ? url
                      : owned.months!['December']['image']
                }
              }
            }));
      } catch (e) {
        throw e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ad>(
                  builder: (context, ad, _) => ListView.builder(
                    itemCount: months.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(months[index]),
                          subtitle: Text("Status: " +
                              ad.filtered[0].months![months[index]]!['status']),
                          trailing: ad.filtered[0]
                                      .months![months[index]]!['status'] ==
                                  'none'
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await getImage(true).then((value) {
                                      _submit(ad.filtered[0], months[index]);
                                    });
                                  },
                                  child: Text('Upload\nReceipt'),
                                )
                              : ad.filtered[0]
                                          .months![months[index]]!['status'] ==
                                      'pending'
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Icon(
                                        Icons.pending_actions,
                                        size: 34,
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 34,
                                        color: Colors.green,
                                      ),
                                    ));
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
