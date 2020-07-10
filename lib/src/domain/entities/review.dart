class Review {
  String uid;
  String comment;
  int rate;

  Review({
    this.comment,
    this.rate,
    this.uid,
  });

  Review.fromReview(Review review) {
    uid = review.uid;
    comment = review.comment;
    rate = review.rate;
  }
}
