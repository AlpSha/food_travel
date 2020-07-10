import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_travel/src/data/constants.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/mappers/product_mapper.dart';
import 'package:food_travel/src/data/mappers/review_mapper.dart';
import 'package:food_travel/src/data/models/product_model.dart';
import 'package:food_travel/src/data/models/review_model.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';

class ProductHelper {
  static final _firestore = Firestore.instance;

  static List<Product> _products;

  static StreamController<List<Product>> _streamController;

  static List<Product> get products {
    return _products.map((p) => Product.fromProduct(p)).toList();
  }

  static Future<void> fetchProducts() async {
    try {
      final query = _fetchProductsOnCurrentCountryQuery();
      final querySnapshot = await query.getDocuments();
      final documents = querySnapshot.documents;
      _products = [];
      for (var doc in documents) {
        final productModel = ProductModel.fromSnapshot(doc);
        final product = ProductMapper.createProductFromModel(productModel);
        _products.add(product);
      }
      prepareController();
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  static void prepareController() {
    _streamController = StreamController.broadcast(onListen: () {
      _streamController.add(products);
    });
  }

  static markProductAsFavorite(bool isFavorite, String productId) async {
    try {
      if (products == null) {
        await fetchProducts();
      }
      await UserHelper.addProductToFavorites(productId);
      final product =
          _products.firstWhere((product) => product.id == productId);
      if (product != null) {
        product.isFavorite = isFavorite;
      }
      _streamController.add(products);
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  static void updateAllergyStatusOfProducts() {
    for (var product in _products) {
      product.userHasAllergy = UserHelper.containsAllergenForUser(product);
    }
    _streamController.add(products);
  }

  static Future<Product> fetchProductWithBarcode(String barcode) async {
    try {
      final query = _fetchProductsOnCurrentCountryQuery();
      final querySnapshot =
          await query.where('barcode', isEqualTo: barcode).getDocuments();
      if (querySnapshot.documents.length == 0) {
        return null;
      }
      final document = querySnapshot.documents.first;
      final productModel = ProductModel.fromSnapshot(document);
      return ProductMapper.createProductFromModel(productModel);
    } catch (e, st) {
      print(st);
      print(e);
      rethrow;
    }
  }

  static Query _fetchProductsOnCurrentCountryQuery() {
    final country = UserHelper.country;
    final query = _firestore
        .collection(COL_PRODUCTS)
        .where('country', isEqualTo: country);
    return query;
  }

  static Stream<List<Product>> getProductsListStream() {
    Future.delayed(Duration.zero)
        .then((value) => _streamController.add(products));
    return _streamController.stream;
  }

  static Future<void> addReviewToProduct(Product product, Review review) async {
    try {
      final uid = UserHelper.uid;
      final language = UserHelper.currentUser.languages.first;
      final model = ReviewModel(
        comment: review.comment,
        uid: uid,
        language: language,
        stars: review.rate,
      );
      await _firestore.collection(COL_PRODUCTS).document(product.id).updateData({
        'reviews': FieldValue.arrayUnion([model.toMap()]),
      });
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  static Future<List<Review>> getReviewsOfProductOnPreferredLanguages(
      Product product) async {
    try {
      final usersLanguages = UserHelper.currentUser.languages;
      List<Review> reviews = [];
      final querySnapshot =
          await _firestore.collection(COL_PRODUCTS).document(product.id).get();
      final productModel = ProductModel.fromSnapshot(querySnapshot);
      productModel.reviews.forEach((reviewModel) {
        if (usersLanguages.contains(reviewModel.language)) {
          final review = ReviewMapper.createReviewFromModel(reviewModel);
          reviews.add(review);
        }
      });
      return reviews;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
