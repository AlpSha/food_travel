import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/data/repositories/phone_repository.dart';

class AuthenticatePhoneAutomatically extends UseCase<bool,AuthenticatePhoneAutomaticallyParams> {
  final PhoneRepository _repository;
  AuthenticatePhoneAutomatically(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(AuthenticatePhoneAutomaticallyParams params) async {
    final StreamController<bool> controller = StreamController();
    try {
      await _repository.authenticate();
      String uid = await _repository.authenticatedUserId;
      if (await _repository.isRegistered(uid)) {
        controller.add(true);
      } else {
        controller.add(false);
        _repository.logOut();
      }
      logger.finest("AuthenticatePhoneAutomatically Successful");
    } catch (error) {
      logger.severe("AuthenticatePhoneAutomatically Unsuccessful");
      print(error.message);
      controller.addError(error);
    }
    controller.close();
    return controller.stream;
  }
}

class AuthenticatePhoneAutomaticallyParams {
}