import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/repositories/authentication_repository.dart';

class CheckIfLoggedIn extends UseCase<bool, CheckIfLoggedInParams> {
  final AuthenticationRepository _repository;
  CheckIfLoggedIn(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(CheckIfLoggedInParams params) async {
    final StreamController<bool> controller = StreamController();
    try {
      final isLoggedIn = await _repository.isAuthenticated;
      controller.add(isLoggedIn);
      logger.finest("CheckIfLoggedIn Successful");
      controller.close();
    } catch (error) {
      logger.severe("CheckIfLoggedIn Unsuccessful");
      controller.addError(error);
    }
    return controller.stream;
  }
}

class CheckIfLoggedInParams {
}