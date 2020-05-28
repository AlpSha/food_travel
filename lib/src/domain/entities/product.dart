import 'package:food_travel/src/domain/entities/review.dart';

class Product {
  bool userHasAllergy;
  bool isFavorite;
  String barcode;
  List<Review> reviews;
  double avgRate;
  List<String> ingredients;
  List<String> allergens;
  double price;
  String title;
  String imageUrl;

  Product({
    this.userHasAllergy,
    this.isFavorite,
    this.barcode,
    this.reviews,
    this.avgRate,
    this.ingredients,
    this.price,
    this.title,
    this.imageUrl,
  });

  Product.fromProduct(Product product) {
    userHasAllergy = product.userHasAllergy;
    isFavorite = product.isFavorite;
    barcode = product.barcode;
    if(reviews != null) {
      reviews = product.reviews.map((rev) => Review.fromReview(rev)).toList();
    }
    avgRate = product.avgRate;
    ingredients = [...product.ingredients];
    allergens = [...product.allergens];
    price = product.price;
    title = product.title;
    imageUrl = product.imageUrl;
  }
}
