import 'package:flutter/material.dart';

void showSnackBar(BuildContext ctx, String content) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(content)));
}
