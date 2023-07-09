import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/screens/payment.dart';
import 'package:rsms/screens/rate_house.dart';

import 'dialogbox.dart';

enum FilterOptions { Leave, Payment }

class UserAddItem extends StatelessWidget {
  final ad Ad;
  final String delid;
  final String id;
  final String title;
  final String imgUrl;
  final String description;

  UserAddItem(
      this.Ad, this.delid, this.id, this.title, this.imgUrl, this.description);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(imgUrl),
      ),
      subtitle: Text(description),
      trailing: Container(
        child: PopupMenuButton(
          onSelected: (FilterOptions value) async {
            if (value == FilterOptions.Leave) {
              bool confirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog();
                },
              );
              if (confirmed == true) {
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return RateHouseModal(id);
                  },
                ).then((value) =>
                    Provider.of<ad>(context, listen: false).leaveHouse(delid));
              } else {
                // Perform action when user selects "No" or dismisses the dialog
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Payment()),
              );
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Leave House'),
              value: FilterOptions.Leave,
            ),
            PopupMenuItem(
              child: Text('View Payments'),
              value: FilterOptions.Payment,
            ),
          ],
          icon: Icon(
            Icons.more_vert,
          ),
        ),
      ),
    );
  }
}
