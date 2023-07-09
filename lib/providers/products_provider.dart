import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rsms/models/rating.dart';

import '../models/http_exception.dart';
import '../models/owned.dart';

class ad with ChangeNotifier {
  String? id;
  String? title;
  double? price;
  String? description;
  String? contact;
  List? image;
  String? location;
  String? state;
  String? city;
  String? type;
  bool? owned = false;
  List? rating = [];
  List? agreement = [];

  var adid;
  List<ad> _items = [];
  List<Owned> _filtered = [];

  String? authToken;
  String? userId;
  String? userEmail;

  ad.fromad(this.authToken, this._items, this.userId, this.userEmail);
  ad.fromadd();

  ad(
      {this.id,
      required this.contact,
      required this.description,
      required this.title,
      required this.price,
      required this.image,
      required this.location,
      required this.state,
      required this.city,
      required this.type,
      required this.owned,
      this.rating});

  // List<ad> _items = [
  //   ad(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     price: 29.99,
  //     description: "A red shirt",
  //     contact: "123",
  //     image:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //     location: '',
  //   ),
  //   ad(
  //       id: 'p2',
  //       title: 'Trousers',
  //       price: 59.99,
  //       description: "A red shirt",
  //       contact: "123",
  //       image:
  //           'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //       location: ''),
  //   ad(
  //       id: 'p3',
  //       title: 'Yellow Scarf',
  //       description: "A red shirt",
  //       contact: "123",
  //       price: 19.99,
  //       image: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //       location: ''),
  //   ad(
  //       id: 'p4',
  //       title: 'A Pan',
  //       description: "A red shirt",
  //       contact: "123",
  //       price: 49.99,
  //       image:
  //           'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //       location: ''),
  // ];

  List<ad> get items {
    return [..._items];
  }

  List<ad> myAds(String id) {
    return _items.where((element) => element.id == id).toList();
  }

  List<Owned> get filtered {
    return [..._filtered];
  }

  String get image1 {
    return this.agreement![0]['image'];
  }

  ad findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> getData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    print("hello");
    final uri =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ads.json?auth=$authToken&$filterString';
    final url = Uri.parse(uri);
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData as Map<String, dynamic>;

      final List<ad> loadedads = [];
      extractedData.forEach((key, doc) {
        loadedads.add(ad(
            id: key,
            owned: doc['owned'],
            title: doc['title'],
            contact: doc['contact'],
            description: doc['description'],
            image: doc['image'],
            location: doc['location'],
            price: doc['price'],
            state: doc['state'],
            city: doc['city'],
            type: doc['type'],
            rating: doc['ratings']));
      });
      _items = loadedads;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }

  Future<void> myAd() async {
    const uri =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ownedHouses.json';
    final url = Uri.parse(uri);
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData as Map<String, dynamic>;
      final List<Owned> list = [];
      extractedData.forEach((key, doc) {
        list.add(Owned(
            id: key, ad: doc['ad'], uid: doc['uid'], months: doc['payments']));
      });
      _filtered = list;
      adid = _filtered[0].ad;

      // .where((element) => element[0]['uid'] == this.userId).toList();
      notifyListeners();
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }

  Future<void> getAgreement() async {
    const uri = 'https://rsms-3e512-default-rtdb.firebaseio.com/Agreement.json';
    final url = Uri.parse(uri);
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData as Map<String, dynamic>;
      List list = [];
      extractedData.forEach((key, doc) {
        list.add({
          'url': doc['url'],
          'renteeId': doc['renteeId'],
          'renterId': doc['renterId']
        });
      });
      list = list.firstWhere(
        (element) =>
            element['renteeId'] == this.userId ||
            element['renterId'] == this.userId,
      );
      this.agreement = list;

      notifyListeners();
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }

  Future<void> addad(ad ads) async {
    final id1 = DateTime.now().toString();
    var url =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ads.json?auth=$authToken';
    // cards.json?auth=$authToken';
    try {
      final response = await http
          .post(
        Uri.parse(url),
        body: json.encode({
          'creatorId': userId,
          'title': ads.title,
          'description': ads.description,
          'contact': ads.contact,
          'image': ads.image,
          'location': ads.location,
          'price': ads.price,
          'state': ads.state,
          'city': ads.city,
          'type': ads.type,
          'owned': false,
          'ratings': [
            {'review': '', "stars": 0.0}
          ]
        }),
      )
          .then((value) {
        final newAd = ad(
          id: json.decode(value.body)['name'],
          owned: false,
          title: ads.title,
          location: ads.location,
          image: ads.image,
          price: ads.price,
          contact: ads.contact,
          description: ads.description,
          state: ads.state,
          city: ads.city,
          type: ads.type,
        );
        _items.add(newAd);
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateAd(
    String id,
    ad newAd,
  ) async {
    final prodInd = _items.indexWhere((element) => id == element.id);

    final url =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ads/$id.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': newAd.title,
          'description': newAd.description,
          'location': newAd.location,
          'contact': newAd.contact,
          'price': newAd.price,
          'imageUrl': newAd.image,
        }));
    _items[prodInd] = newAd;
    notifyListeners();
  }

  Future<void> addRatings(String id, Rating rate) async {
    final prodInd = _items.indexWhere((element) => id == element.id);
    List list = [];
    list.add({'review': rate.review, "stars": rate.stars});
    if (_items[prodInd].rating == null) {
      _items[prodInd].rating = list;
    } else {
      _items[prodInd].rating!.add({'review': rate.review, "stars": rate.stars});
    }
    ad newAd = _items[prodInd];

    print(list);

    final url =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ads/${newAd.id}.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'creatorId': userId,
          'title': newAd.title,
          'description': newAd.description,
          'contact': newAd.contact,
          'image': newAd.image,
          'location': newAd.location,
          'price': newAd.price,
          'state': newAd.state,
          'city': newAd.city,
          'type': newAd.type,
          'owned': false,
          'ratings': newAd.rating
        }));
    _items[prodInd] = newAd;
    notifyListeners();
  }

  Future<void> deleteAd(String id) async {
    final url =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ads/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    ad? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> leaveHouse(String id) async {
    final url =
        'https://rsms-3e512-default-rtdb.firebaseio.com/ownedHouses/$id.json';
    final existingProductIndex =
        _filtered.indexWhere((element) => element.id == id);
    Owned? existingProduct = _filtered[existingProductIndex];
    _filtered.removeAt(existingProductIndex);

    List<Map> rentees = [];
    final response = await http.delete(Uri.parse(url)).then((value) async {
      const uri1 = 'https://rsms-3e512-default-rtdb.firebaseio.com/rentee.json';
      final url1 = Uri.parse(uri1);
      try {
        final response = await http.get(url1);
        var extractedData = json.decode(response.body);
        if (extractedData == null) {
          return;
        }
        extractedData = extractedData as Map<String, dynamic>;
        final List<Map> list = [];
        extractedData.forEach((key, doc) {
          list.add({
            'key': key,
            'id': doc['id'],
            "email": doc['email'],
            'password': doc["password"],
            "cnic": doc['cnic'],
            "number": doc['number'],
            "owned": doc['owned']
          });
        });
        rentees = list;
      } catch (e) {}
    }).then((value) async {
      var rentee = rentees.firstWhere(
        (element) => element['id'] == existingProduct.uid,
      );
      final uri2 =
          'https://rsms-3e512-default-rtdb.firebaseio.com/rentee/${rentee['key']}.json';
      final url2 = Uri.parse(uri2);
      try {
        final response = await http.patch(url2,
            body: json.encode({
              'id': rentee['id'],
              "email": rentee['email'],
              'password': rentee["password"],
              "cnic": rentee['cnic'],
              "number": rentee['number'],
              "owned": false
            }));

        // .where((element) => element[0]['uid'] == this.userId).toList();
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    });
    if (response.statusCode >= 400) {
      _filtered.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    notifyListeners();
  }
}
