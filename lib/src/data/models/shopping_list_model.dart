import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListModel {
  List<String> items;
  String country;
  String uid;

  ShoppingListModel({
    this.items,
    this.country,
    this.uid,
  });

  ShoppingListModel.fromSnapshot(DocumentSnapshot snapshot) {
    country = snapshot.data['country'];
    items = List.from(snapshot.data['items']);
    uid = snapshot.data['uid'];
  }

  Map<String, dynamic> toDataMap() {
    return {
      'country': country,
      'items': items,
      'uid': uid,
    };
  }
}
