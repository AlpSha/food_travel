import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_travel/src/data/constants.dart';
import 'package:food_travel/src/data/helpers/product_helper.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/models/shopping_list_model.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class ShoppingHelper {
  static final _firestore = Firestore.instance;

  static Set<Product> _shoppingList;

  static List<Product> get shoppingList =>
      _shoppingList.map((product) => Product.fromProduct(product)).toList();

  static StreamController<List<Product>> _streamController;

  static Future<bool> fetchShoppingList() async {
    final user = UserHelper.currentUser;
    final uid = UserHelper.uid;
    final querySnapshot = await _firestore
        .collection(COL_SHOPPING_LIST)
        .where('uid', isEqualTo: uid)
        .where('country', isEqualTo: user.country)
        .getDocuments();
    if (querySnapshot.documents.length == 0) {
      return false;
    }
    final snapshot = querySnapshot.documents.first;
    _shoppingList = await _createListFromSnapshot(snapshot);
    prepareController();
    return true;
  }

  static void prepareController() {
    _streamController = StreamController.broadcast(onListen: () async {
      _streamController.add(shoppingList);
    });
  }

  static Future<bool> addToShoppingList(Product product) async {
    try {
      final id = await _getDocumentIdOfCurrentShoppingList();
      if (id == null) {
        return false;
      }
      await _firestore.collection(COL_SHOPPING_LIST).document(id).updateData({
        'items': FieldValue.arrayUnion([product.barcode])
      });
      _shoppingList.add(product);
      _streamController.add(shoppingList);
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  static Future<bool> removeFromShoppingList(String barcode) async {
    try {
      final id = await _getDocumentIdOfCurrentShoppingList();
      if (id == null) {
        return false;
      }
      await _firestore.collection(COL_SHOPPING_LIST).document(id).updateData({
        'items': FieldValue.arrayRemove([barcode])
      });
      _shoppingList.removeWhere((product) => product.barcode == barcode);
      _streamController.add(shoppingList);
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  static Future<bool> createShoppingListForUser() async {
    try {
      final model = ShoppingListModel(
          uid: UserHelper.uid, items: [], country: UserHelper.country);
      await _firestore.collection(COL_SHOPPING_LIST).add(model.toDataMap());
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  static Future<Set<Product>> _createListFromSnapshot(
      DocumentSnapshot snapshot) async {
    try {
      final model = ShoppingListModel.fromSnapshot(snapshot);

      final shoppingList = Set<Product>();
      await Future.forEach(model.items, (item) async {
        final product = await ProductHelper.fetchProductWithBarcode(item);
        shoppingList.add(product);
      });
      return shoppingList;
    } catch (e, st) {
      print(e);
      print(st);
      return null;
    }
  }

  static Future<String> _getDocumentIdOfCurrentShoppingList() async {
    try {
      final query = _getShoppingListQuery();
      final querySnapshot = await query.getDocuments();
      if (querySnapshot.documents.length == 0) {
        return null;
      }
      final documentId = querySnapshot.documents.first.documentID;
      return documentId;
    } catch (e, st) {
      print(e);
      print(st);
      return null;
    }
  }

  static Query _getShoppingListQuery() {
    final user = UserHelper.currentUser;
    final uid = UserHelper.uid;
    final query = _firestore
        .collection(COL_SHOPPING_LIST)
        .where('uid', isEqualTo: uid)
        .where('country', isEqualTo: user.country);
    return query;
  }

  static Stream<List<Product>> receiveListStream() {
    Future.delayed(Duration.zero)
        .then((_) => _streamController.add(shoppingList));
    return _streamController.stream;
  }
}
