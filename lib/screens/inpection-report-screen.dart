import 'package:flutter/material.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/providers/reports.dart';

class InspectionReport extends StatelessWidget {
  InspectionReport({required this.Ad, required this.Report});

  ad Ad;
  report Report;

  @override
  Widget build(BuildContext context) {
    double barHeight = 3.0;
    double barWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text(Ad.title.toString())),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Inspection Report',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Overall:"), Text('${Report.overall!}%')],
                ),
                HorizontalBar(
                  number: Report.overall,
                  barH: barHeight,
                  barW: barWidth,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("TileWork:"), Text('${Report.tilework!}%')],
                ),
                HorizontalBar(
                  number: Report.woodwork,
                  barH: barHeight,
                  barW: barWidth,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("WoodWork:"), Text('${Report.woodwork!}%')],
                ),
                HorizontalBar(
                  number: Report.tilework,
                  barH: barHeight,
                  barW: barWidth,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Walls:"), Text('${Report.walls!}%')],
                ),
                HorizontalBar(
                  number: Report.walls,
                  barH: barHeight,
                  barW: barWidth,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("View ad"))),
                )
              ],
            ),
          ),
        ));
  }
}

class HorizontalBar extends StatelessWidget {
  int? number;
  double barH;
  double barW;

  HorizontalBar({required this.number, required this.barH, required this.barW});

  @override
  Widget build(BuildContext context) {
    double barHeight = barH;
    double barWidth = barW;
    double filledWidth = (barWidth * number!) / 100;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: barHeight,
            width: barWidth,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(width: 8.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: barHeight,
            width: filledWidth,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
