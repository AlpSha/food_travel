import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_travel/src/data/exceptions/login_failed_exception.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/mappers/user_mapper.dart';
import 'package:food_travel/src/data/models/user_model.dart';
import 'package:food_travel/src/domain/entities/user_registration.dart';
import 'package:food_travel/src/domain/repositories/authentication_repository.dart';
import 'package:food_travel/src/domain/repositories/registration_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookRepository
    implements AuthenticationRepository, RegistrationRepository {
  final _facebookLogin = FacebookLogin();
  final _firebaseAuth = FirebaseAuth.instance;
  String _facebookToken;
  UserModel _userModel;
  AuthCredential _credential;

  @override
  Future<void> authenticate() async {
    final result = await _facebookLogin.logIn(["email"]);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _facebookToken = result.accessToken.token;
        _credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        await _firebaseAuth.signInWithCredential(_credential);
        UserHelper.uid = (await _firebaseAuth.currentUser()).uid;
        break;
      case FacebookLoginStatus.error:
        throw LoginFailedException(result.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
      default:
        throw LoginFailedException("canceled");
    }
  }

  @override
  Future<String> get authenticatedUserId async {
    final user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Future<bool> get isAuthenticated async {
    await _firebaseAuth.signOut();
    final user = await _firebaseAuth.currentUser();
    return user != null;
  }

  @override
  Future<void> logOut() {
    _firebaseAuth.signOut();
    UserHelper.signOut();
    return null;
  }

  Future<void> setFacebookFields() async {
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$_facebookToken');
    final profile = json.decode(graphResponse.body);
    _userModel
      ..uid = UserHelper.uid
      ..email = profile["email"];
  }

  @override
  Future<void> registerUser(UserRegistration userRegistration) async {
    try {
      _userModel = UserMapper.createUserModelFromRegistration(userRegistration);
      if (await _firebaseAuth.currentUser() == null) {
        await _firebaseAuth.signInWithCredential(_credential);
      }
      await setFacebookFields();
      await UserHelper.addUserToDatabase(_userModel);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> isRegistered(String uid) async {
    return UserHelper.userExists(uid);
  }

}
