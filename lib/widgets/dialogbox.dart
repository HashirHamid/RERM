import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Are you sure about it?'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            // Perform the desired action on Yes
            Navigator.of(context).pop(true);
          },
          child: Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () {
            // Perform the desired action on No
            Navigator.of(context).pop(false);
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
