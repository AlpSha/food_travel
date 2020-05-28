import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/data/exceptions/login_failed_exception.dart';
import 'package:food_travel/src/data/repositories/facebook_repository.dart';

class LoginWithFacebook extends UseCase<bool, LoginWithFacebookParams> {
  final FacebookRepository _repository;
  LoginWithFacebook(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(LoginWithFacebookParams params) async {
    final StreamController<bool> controller = StreamController();
    try {
      await _repository.authenticate();
      String uid = await _repository.authenticatedUserId;
      if(await _repository.isRegistered(uid)) {
        controller.add(true);
      } else {
        controller.add(false);
        _repository.logOut();
      }
      logger.finest("LoginWithFacebook Successful");
    } catch (error) {
      logger.severe("LoginWithFacebook Unsuccessful");
      controller.addError(error);
      if (error != LoginFailedException) {
        print(error);
      }
    }
    controller.close();
    return controller.stream;
  }
}

class LoginWithFacebookParams {
}