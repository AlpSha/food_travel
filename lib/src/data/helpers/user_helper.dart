import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_travel/src/data/constants.dart';
import 'package:food_travel/src/data/exceptions/not_logged_in_exception.dart';
import 'package:food_travel/src/data/mappers/user_mapper.dart';
import 'package:food_travel/src/data/models/user_model.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/user.dart';

class UserHelper {
  static final _firestore = Firestore.instance;

  static String uid;
  static User _user;

  static AuthCredential authCredential;

  static String get country => _user.country;

  static StreamController<User> _streamController;

  static User get currentUser {
    if (uid == null) {
      return null;
    }
    return User.fromUser(_user);
  }

  static void signOut() {
    uid = null;
    _user = null;
  }

  static Future<User> fetchCurrentUser() async {
    return _fetchUserWithUid(uid);
  }
  
  static Future<User> _fetchUserWithUid(String uid) async {
    try {
      final snapshot =
          await _firestore.collection(COL_USER).document(uid).get();
      return UserMapper.createUserFromModel(UserModel.fromSnapshot(snapshot));
    } catch (error, st) {
      print(error);
      print(st);
      rethrow;
    }
  }

  static Future<bool> addProductToFavorites(String barcode) async {
    try {
      await _firestore.collection(COL_USER).document(uid).updateData({
        'favoriteProducts': FieldValue.arrayUnion([barcode])
      });
      _user.favorites.add(barcode);
      _streamController.add(currentUser);
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  static Future<bool> removeProductFromFavorites(String barcode) async {
    try {
      await _firestore.collection(COL_USER).document(uid).updateData({
        'favoriteProducts': FieldValue.arrayRemove([barcode])
      });
      _user.favorites.removeWhere((bc) => bc == barcode);
      _streamController.add(currentUser);
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }

  static bool isFavoriteOfUser(String productBarcode) {
    for (var barcode in _user.favorites) {
      if (barcode == productBarcode) {
        return true;
      }
    }
    return false;
  }

  static Future<List<String>> get allergensOfUser async {
    if (_user.allergies == null) {
      _user.allergies = await fetchAllergiesOfUser();
    }
    return _user.allergies;
  }

  static bool containsAllergenForUser(Product product) {
    return userHasAllergyToAny(product.allergens);
  }
  
  static bool userHasAllergyToAny(List<String> allergens) {
    for (var allergy in _user.allergies) {
      for (var allergen in allergens) {
        if (allergen == allergy) {
          return true;
        }
      }
    }
    return false;   
  }

  static Future<bool> updateAllergies(List<String> allergies) async {
    try {
      _firestore.collection(COL_USER).document(uid).updateData({
        'allergies': allergies,
      });
      currentUser.allergies = allergies;
      _streamController.add(currentUser);
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      return false;
    }
  }
  
  static Future<List<String>> fetchAllergiesOfUser() async {
    try {
      final snapshot =
          await _firestore.collection(COL_USER).document(uid).get();
      final model = UserModel.fromSnapshot(snapshot);
      return model.allergies;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  static Future<void> addUserToDatabase(UserModel userModel) async {
    try {
      await _firestore
          .collection(COL_USER)
          .document("${userModel.uid}")
          .setData(userModel.toMap());
    } catch (error, st) {
      print(error);
      print(st);
      rethrow;
    }
  }

  static Future<bool> userExists(String uid) async {
    final snapshot = await _firestore.collection("user").document(uid).get();
    return snapshot.exists;
  }

  static Stream<User> getCurrentUserStream() {
    if (_streamController == null) {
      _streamController = StreamController.broadcast(onListen: () async {
        if (uid == null) {
          _streamController
              .addError(NotLoggedInException('User not logged in'));
          return null;
        }
        if (_user == null) {
          await _fetchUserWithUid(uid);
        }
        _streamController.add(currentUser);
        return null;
      });
    }
    return _streamController.stream;
  }
}
