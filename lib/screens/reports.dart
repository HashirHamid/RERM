import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/auth.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/providers/reports.dart';
import 'package:rsms/screens/inpection-report-screen.dart';
import 'package:rsms/widgets/report_items.dart';

class Reports extends StatefulWidget {
  Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  var _flag = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_flag) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ad>(context, listen: false).getData();
      Provider.of<report>(context, listen: false).getReports().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _flag = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final reports = Provider.of<report>(context).reports;
    var reports1 =
        reports.where((element) => element.userId == auth.userId).toList();
    final ads = Provider.of<ad>(context).items;
    var ads1 = ads.where((element) {
      for (var i in reports1) {
        if (element.id == i.id) {
          return true;
        }
      }
      return false;
    }).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Inspection Reports"),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ads1.length == 0
                ? Center(child: Text('No ads found!'))
                : ListView.builder(
                    itemCount: ads1.length,
                    itemBuilder: (context, i) => ChangeNotifierProvider.value(
                        value: ads1[i],
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InspectionReport(
                                        Ad: ads1[i], Report: reports1[i])));
                          },
                          child: ReportItem(
                              ads1[i].description.toString(),
                              ads1[i].title.toString(),
                              ads1[i].image![0].toString()),
                        ))));
  }
}
