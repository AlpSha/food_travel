class ReviewModel {
  String comment;
  int stars;
  String language;
  String uid;

  ReviewModel({
    this.comment,
    this.stars,
    this.language,
    this.uid,
  });

  ReviewModel.fromMap(Map<String, dynamic> map) {
    comment = map['comment'];
    language = map['language'];
    stars = map['stars'];
    uid = map['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'language': language,
      'stars': stars,
      'uid': uid,
    };
  }
}
