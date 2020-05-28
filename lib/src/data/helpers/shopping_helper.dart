import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_travel/src/data/constants.dart';
import 'package:food_travel/src/data/helpers/product_helper.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/models/shopping_list_model.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class ShoppingHelper {
  static final _firestore = Firestore.instance;

  static List<Product> _shoppingList;
  
  static List<Product> get shoppingList => _shoppingList.map((product) => Product.fromProduct(product)).toList();
  
  static StreamController<List<Product>> _streamController;
  

  static fetchShoppingList() async {
    final user = UserHelper.currentUser;
    final uid = UserHelper.uid;
    final querySnapshot = await _firestore
        .collection(COL_SHOPPING_LIST)
        .where('uid', isEqualTo: uid)
        .where('country', isEqualTo: user.country)
        .getDocuments();
    if (querySnapshot.documents.length == 0) {
      return;
    }
    final snapshot = querySnapshot.documents.first;
    _createListFromSnapshot(snapshot);
    _streamController.add(shoppingList);
  }

  static Future<bool> addToShoppingList(String barcode) async {
    try {
      final id = await _getDocumentIdOfCurrentShoppingList();
      if (id == null) {
        return false;
      }
      await _firestore.collection(COL_SHOPPING_LIST).document(id).updateData({
        'items': FieldValue.arrayUnion([barcode])
      });
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
      _streamController.add(shoppingList);
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  static Future<List<Product>> _createListFromSnapshot(DocumentSnapshot snapshot) async {

    final model = ShoppingListModel.fromSnapshot(snapshot);

    final _shoppingList = [];
    for (var item in model.items) {
      final product = await ProductHelper.fetchProductWithBarcode(item);
      _shoppingList.add(product);
    }
    return _shoppingList;
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

  static Stream<List<Product>> receiveProductsStream() {
    if(_streamController == null) {
      _streamController = StreamController.broadcast(
          onListen: () async {
            if (_shoppingList == null) {
              await fetchShoppingList();
            }
            _streamController.add(shoppingList);
            return null;
          }
      );  
    }
    return _streamController.stream;
  }
}
