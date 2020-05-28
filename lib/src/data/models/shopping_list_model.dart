import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListModel {
  List<String> items;
  String country;
  String uid;

  ShoppingListModel({
    this.items,
    this.country,
  });

  ShoppingListModel.fromSnapshot(DocumentSnapshot snapshot) {
    country = snapshot.data['country'];
    items = snapshot.data['items'];
    uid = snapshot.data['uid'];
  }
}
