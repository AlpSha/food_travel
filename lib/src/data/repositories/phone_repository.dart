import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_travel/src/data/exceptions/login_failed_exception.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/mappers/user_mapper.dart';
import 'package:food_travel/src/data/models/user_model.dart';
import 'package:food_travel/src/domain/entities/user_registration.dart';
import 'package:food_travel/src/domain/repositories/authentication_repository.dart';
import 'package:food_travel/src/domain/repositories/registration_repository.dart';

class PhoneRepository implements AuthenticationRepository, RegistrationRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  UserModel _userModel;
  String _phoneNumber;

  // ignore: missing_return
  PhoneVerificationCompleted verificationCompleted(AuthCredential credential) {
    UserHelper.authCredential = credential;
  }

  Future<void> startVerification(String phoneNumber) async {
    _phoneNumber = phoneNumber;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      _verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      _verificationId = verId;
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      throw exception;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<void> authenticateWithSmsCode(String smsCode) async {
    try {
      UserHelper.authCredential = PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: smsCode);
      await authenticate();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> authenticate() async {
    try {
      final result = await _firebaseAuth.signInWithCredential(UserHelper.authCredential);
      if(result.user != null) {
        final firebaseUser = await _firebaseAuth.currentUser();
        UserHelper.uid = firebaseUser.uid;
        return;
      } else {
        throw LoginFailedException("Doğrulama başarısız");
      }
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String> get authenticatedUserId async {
    return UserHelper.uid;
  }

  @override
  Future<bool> get isAuthenticated async {
    final user = _firebaseAuth.currentUser();
    return user != null;
  }

  @override
  Future<bool> isRegistered(String uid) async {
    return UserHelper.userExists(uid);
  }

  @override
  Future<void> registerUser(UserRegistration userRegistration) async {
    try {
      _userModel = UserMapper.createUserModelFromRegistration(userRegistration);
      _userModel
        ..uid = UserHelper.uid
        ..phone = _phoneNumber;
      await UserHelper.addUserToDatabase(_userModel);
      authenticate();
    } catch (error) {
      rethrow;
    }
  }
}