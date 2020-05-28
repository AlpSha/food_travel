import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String title;
  String barcode;
  String country;
  List<ReviewModel> reviews;
  List<String> ingredients;
  List<String> allergens;
  String imageUrl;
  num price;
  String productId;

  ProductModel({
    this.title,
    this.barcode,
    this.country,
    this.reviews,
    this.ingredients,
    this.allergens,
    this.imageUrl,
    this.productId,
    this.price,
  });

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot.data['title'];
    barcode = snapshot.data['barcode'];
    country = snapshot.data['country'];
    ingredients = snapshot.data['ingredients'];
    allergens = snapshot.data['allergens'];
    imageUrl = snapshot.data['pictureUrl'];
    productId = snapshot.data['productId'];
    price = snapshot.data['price'];
    reviews = snapshot.data['reviews'].map((rev) => ReviewModel.fromMap(rev)).toList();
  }
}

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
}
