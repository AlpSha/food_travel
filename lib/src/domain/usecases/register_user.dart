import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/user_registration.dart';
import 'package:food_travel/src/domain/repositories/registration_repository.dart';

class RegisterUser extends UseCase<void, RegisterUserParams> {
  final RegistrationRepository _repository;

  RegisterUser(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(RegisterUserParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      await _repository.registerUser(params.userRegistration);
    } catch (error){
      print(error);
      logger.severe("RegisterUser Unsuccessful");
      controller.addError(error);
    }
    controller.close();
    return controller.stream;
  }
}

class RegisterUserParams {
  final UserRegistration userRegistration;

  RegisterUserParams(this.userRegistration);
}
