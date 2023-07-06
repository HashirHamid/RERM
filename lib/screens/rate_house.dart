import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rsms/models/rating.dart';
import 'package:rsms/providers/products_provider.dart';

class RateHouseModal extends StatefulWidget {
  String id;
  RateHouseModal(this.id);

  @override
  _RateHouseModalState createState() => _RateHouseModalState();
}

class _RateHouseModalState extends State<RateHouseModal> {
  double _rating = 0.0;
  TextEditingController _CommentController = new TextEditingController();

  void _fillTextBox(String keyword) {
    setState(() {
      _CommentController.text = keyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _fillTextBox('Great house!'),
                child: Text('Great'),
              ),
              ElevatedButton(
                onPressed: () => _fillTextBox('Average house'),
                child: Text('Average'),
              ),
              ElevatedButton(
                onPressed: () => _fillTextBox('Needs improvement'),
                child: Text('Needs Improvement'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Material(
            child: TextField(
              controller: _CommentController,
              onChanged: (value) {
                setState(() {
                  _CommentController.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter your comments',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Provider.of<ad>(context, listen: false).addRatings(widget.id,
                  Rating(stars: _rating, review: _CommentController.text));
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
