import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_travel/src/data/constants.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/mappers/product_mapper.dart';
import 'package:food_travel/src/data/models/product_model.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class ProductHelper {
  static final _firestore = Firestore.instance;

  static List<Product> _products;

  static StreamController<List<Product>> _streamController = StreamController();

  static List<Product> get products {
    return _products.map((p) => Product.fromProduct(p)).toList();
  }

  static Future<void> fetchProducts() async {
    final query = _fetchQueryProductsOnCurrentCountry();
    final querySnapshot = await query.getDocuments();
    final documents = querySnapshot.documents;
    _products = [];
    for (var doc in documents) {
      final productModel = ProductModel.fromSnapshot(doc);
      final product = ProductMapper.createProductFromModel(productModel);
      _products.add(product);
    }
    prepareController();
  }

  static void prepareController() {
    _streamController = StreamController.broadcast(
      onListen: () async {
        _streamController.add(products);
      }
    );
  }

  static markProductAsFavorite(bool isFavorite, String barcode) async {
    if (products == null) {
      await fetchProducts();
    }
    final product =
        products.firstWhere((product) => product.barcode == barcode);
    if (product != null) {
      product.isFavorite = isFavorite;
    }
    _streamController.add(products);
  }

  static void updateAllergyStatusOfProducts() {
    for (var product in _products) {
      product.userHasAllergy = UserHelper.containsAllergenForUser(product);
    }
    _streamController.add(products);
  }

  static Future<Product> fetchProductWithBarcode(String barcode) async {
    final query = _fetchQueryProductsOnCurrentCountry();
    final querySnapshot =
        await query.where('barcode', isEqualTo: barcode).getDocuments();
    if (querySnapshot.documents.length == 0) {
      return null;
    }
    final document = querySnapshot.documents.first;
    final productModel = ProductModel.fromSnapshot(document);
    return ProductMapper.createProductFromModel(productModel);
  }

  static Query _fetchQueryProductsOnCurrentCountry() {
    final country = UserHelper.country;
    final query = _firestore
        .collection(COL_PRODUCTS)
        .where('country', isEqualTo: country);
    return query;
  }

  static Stream<List<Product>> getProductsListStream() {
    Future.delayed(Duration.zero).then((value) => _streamController.add(products));
    return _streamController.stream;
  }

}
