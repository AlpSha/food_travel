class Review {
  String comment;
  int rate;

  Review({
    this.comment,
    this.rate,
  });

  Review.fromReview(Review review) {
    comment = review.comment;
    rate = review.rate;
  }
}
