import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String homeCountry;
  String phone;
  String currentCountry;
  String email;
  String gender;
  String birthYear;
  String lastLogin;
  List<String> languages;
  List<String> productRequests;
  List<String> allergies;
  List<String> favoriteProducts;
  String os;
  String osVersion;

  UserModel({
    this.uid,
    this.homeCountry,
    this.currentCountry,
    this.phone,
    this.email,
    this.gender,
    this.birthYear,
    this.languages,
    this.allergies,
    this.favoriteProducts,
    this.lastLogin,
    this.os,
    this.osVersion,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'homeCountry': homeCountry,
      'currentCountry': currentCountry,
      'phone': phone,
      'email': email,
      'gender': gender,
      'birthYear': birthYear,
      'languages': languages,
      'allergies': allergies,
      'favoriteProducts': favoriteProducts,
      'os': os,
      'osVersion': osVersion,
    };
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.documentID;
    homeCountry = snapshot.data['homeCountry'];
    currentCountry = snapshot.data['currentCountry'];
    phone = snapshot.data['phone'];
    email = snapshot.data['email'];
    gender = snapshot.data['gender'];
    birthYear = snapshot.data['birthYear'];
    languages = List.from(snapshot.data['languages']);
    allergies = List.from(snapshot.data['allergies']);
    favoriteProducts = List.from(snapshot.data['favoriteProducts']);
    os = snapshot.data['os'];
    osVersion = snapshot.data['osVersion'];
  }
}
