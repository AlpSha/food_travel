import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/repositories/authentication_repository.dart';

class LogOut extends UseCase<void, LogOutParams> {
  final AuthenticationRepository _repository;
  LogOut(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(LogOutParams params) async {
    StreamController<void> controller = StreamController();
    try {
      await _repository.logOut();
      logger.severe("LogOut Successful");
    } catch(error) {
      logger.severe("LogOut Unsuccessful");
      controller.addError(error);
    }
    controller.close();
    return controller.stream;
  }

}

class LogOutParams {

}