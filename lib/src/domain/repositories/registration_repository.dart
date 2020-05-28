import 'package:food_travel/src/domain/entities/user_registration.dart';

abstract class RegistrationRepository {
  Future<void> registerUser(UserRegistration userRegistration);

  Future<bool> isRegistered(String uid);

}