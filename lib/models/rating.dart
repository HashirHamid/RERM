class Rating {
  final double stars;
  final String review;

  Rating({required this.stars, required this.review});
}

final List<Rating> ratings = [
  Rating(
    stars: 5,
    review: 'This app is amazing! I love it so much.',
  ),
  Rating(
    stars: 4,
    review: 'Pretty good app, but could use some improvements.',
  ),
  Rating(
    stars: 3,
    review: 'It\'s okay, but not my favorite.',
  ),
  Rating(
    stars: 2,
    review: 'Not very good, needs a lot of work.',
  ),
  Rating(
    stars: 1,
    review: 'Terrible app, do not recommend.',
  ),
];
