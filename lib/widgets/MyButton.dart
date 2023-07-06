import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyButton extends StatelessWidget {
  MyButton(this.text);
  Text text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Center(child: text),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 33, 124, 198),
            Color.fromARGB(255, 11, 82, 139),
          ],
        ),
      ),
    );
  }
}
