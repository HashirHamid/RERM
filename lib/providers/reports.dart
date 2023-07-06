import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class report with ChangeNotifier {
  String? id;
  String? userId;
  int? overall;
  int? tilework;
  int? walls;
  int? water;
  int? electricity;
  int? severage;
  int? paint;
  int? woodwork;

  List<report> _reports = [];

  String? authToken;
  String? userEmail;

  report.fromad(this.authToken, this._reports, this.userId, this.userEmail);

  report({
    this.id,
    required this.userId,
    required this.overall,
    required this.tilework,
    required this.walls,
    required this.woodwork,
    required this.water,
    required this.paint,
    required this.electricity,
    required this.severage,
  });

  report.fromRep() {}

  List<report> get reports {
    return [..._reports];
  }

  getReports() async {
    final uri =
        'https://rsms-3e512-default-rtdb.firebaseio.com/inspectionReports.json';
    final url = Uri.parse(uri);
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData = extractedData as Map<String, dynamic>;

      final List<report> loadedads = [];
      extractedData.forEach((key, doc) {
        loadedads.add(report(
            id: doc['id'],
            userId: doc['userId'],
            overall: doc['overall'],
            tilework: doc['tilework'],
            walls: doc['walls'],
            woodwork: doc['woodwork'],
            electricity: doc['electricity'],
            paint: doc['paint'],
            severage: doc['severage'],
            water: doc['water']));
      });
      _reports = loadedads;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }

  Future<void> request(String title, String description, String id) async {
    const uri = 'https://rsms-3e512-default-rtdb.firebaseio.com/pending.json';
    final url = Uri.parse(uri);
    try {
      final response = await http.post(url,
          body: json.encode({
            "UID": this.userId,
            "title": title,
            "description": description,
            "adId": id
          }));
    } catch (e) {
      throw e;
    }
  }
}
