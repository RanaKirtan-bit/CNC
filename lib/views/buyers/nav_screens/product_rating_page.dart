import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double? averageRating;
  final int totalStars;

  const RatingStars({Key? key, this.averageRating, this.totalStars = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int filledStars = averageRating?.floor() ?? 0;
    double fraction = averageRating! - filledStars;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalStars, (index) {
        if (index < filledStars) {
          // Full star
          return Icon(
            Icons.star,
            color: Colors.yellow,
          );
        } else if (index == filledStars && fraction > 0) {
          // Half-filled star
          return Icon(
            Icons.star_half,
            color: Colors.yellow,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: Colors.yellow,
          );
        }
      }),
    );
  }
}
