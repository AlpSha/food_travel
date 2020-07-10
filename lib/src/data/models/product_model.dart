import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_travel/src/data/models/review_model.dart';

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
    ingredients = List.from(snapshot.data['ingredients']);
    allergens = List.from(snapshot.data['allergens']);
    imageUrl = snapshot.data['imageUrl'];
    productId = snapshot.documentID;
    price = snapshot.data['price'];
    reviews = List.from(snapshot.data['reviews'].map((rev) => ReviewModel.fromMap(rev)));
  }
}

