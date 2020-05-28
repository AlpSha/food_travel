import 'package:food_travel/src/data/models/user_model.dart';
import 'package:food_travel/src/domain/entities/user.dart';
import 'package:food_travel/src/domain/entities/user_registration.dart';

class UserMapper {
  static User createUserFromModel(UserModel userModel) {
    return User(
      allergies: userModel.allergies,
      languages: userModel.languages,
      country: userModel.currentCountry,
      favorites: userModel.favoriteProducts,
    );
  }

  static UserModel createUserModelFromRegistration(UserRegistration userRegistration) {
    return UserModel(
      homeCountry: userRegistration.homeCountry,
      phone: userRegistration.phone,
      currentCountry: userRegistration.currentCountry,
      email: userRegistration.email,
      gender: userRegistration.gender,
      birthYear: userRegistration.birthYear,
      languages: userRegistration.languages,
      allergies: userRegistration.allergies,
      favoriteProducts: [],
    );
  }
}

