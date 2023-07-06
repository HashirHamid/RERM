import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class listItems extends StatelessWidget {
  const listItems({super.key});

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
            // child: Image.asset('logo.png')
          ),
          title: Text(
            "Hello",
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            "subtitle",
          ),
        ),
      ),
    );
  }
}
