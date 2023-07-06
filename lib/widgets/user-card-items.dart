import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/screens/post-ad.dart';

class UserCardItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserCardItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PostAd.routeName, arguments: id);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () {
              Provider.of<ad>(context, listen: false).deleteAd(id);
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
    );
  }
}
