import 'package:flutter/material.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/domain/entities/review.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CommentsListItem extends StatelessWidget {
  final Review _review;

  const CommentsListItem(this._review);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SmoothStarRating(
        color: kCommentStarColor,
        allowHalfRating: true,
        isReadOnly: true,
        rating: _review.rate.toDouble(),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _review.comment,
          style: TextStyle(
            fontSize: 18,
            color: kPrimaryTextColor,
          ),
        ),
      ),
    );
  }
}
