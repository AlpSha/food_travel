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

  Product(
    this.title,
    this.price,
    this.isFavorite,
    this.barcode,
    this.reviews,
    this.avgRate,
    this.ingredients,
    this.allergens,
    this.imageUrl,
    this.userHasAllergy,
  );

  Product.fromProduct(Product product) {
    userHasAllergy = product.userHasAllergy;
    isFavorite = product.isFavorite;
    barcode = product.barcode;
    if (reviews != null) {
      reviews = product.reviews.map((rev) => Review.fromReview(rev)).toList();
    }
    avgRate = product.avgRate;
    ingredients = [...product.ingredients];
    allergens = [...product.allergens];
    price = product.price;
    title = product.title;
    imageUrl = product.imageUrl;
  }

  String get allergensString {
    var result = '';
    for(var allergen in allergens) {
      result += '$allergen';
      if(allergens.last != allergen) {
        result += ', ';
      }
    }
    return result;
  }

  String get ingredientsString {
    var result = '';
    for(var ingredient in ingredients) {
      result += '$ingredient';
      if(allergens.last != ingredient) {
        result += ', ';
      }
    }
    return result;
  }
}
