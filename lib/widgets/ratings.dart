import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/rating.dart';

class RatingWidget extends StatelessWidget {
  List ratings;

  RatingWidget(this.ratings);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ratings.length,
      itemBuilder: (BuildContext context, int index) {
        final rating = ratings[index];
        return ListTile(
          leading: _buildStarRating(rating['stars']),
          title: Text('${rating['stars']} stars'),
          subtitle: Text(rating['review']),
        );
      },
    );
  }

  Widget _buildStarRating(double stars) {
    return RatingBarIndicator(
      rating: stars,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.orange,
      ),
      itemCount: 5,
      itemSize: 16.0,
      unratedColor: Colors.orange.withAlpha(50),
      direction: Axis.horizontal,
    );
  }
}
