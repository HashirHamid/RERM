import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/screens/post-ad.dart';

class ReportItem extends StatelessWidget {
  final String description;
  final String title;
  final String imgUrl;

  ReportItem(this.description, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100,
        child: ListTile(
          visualDensity: VisualDensity(vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            "${description}",
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Report',
                  style: TextStyle(color: Colors.blue),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
