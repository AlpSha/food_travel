import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/data/repositories/phone_repository.dart';

class AuthenticatePhoneManually extends UseCase<void, AuthenticatePhoneWithSmsParams> {
  final PhoneRepository _repository;
  AuthenticatePhoneManually(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(AuthenticatePhoneWithSmsParams params) async {
    final StreamController<bool> controller = StreamController();
    try {
      await _repository.authenticateWithSmsCode(params._smsCode);
      String uid = await _repository.authenticatedUserId;
      if (await _repository.isRegistered(uid)) {
        controller.add(true);
      } else {
        controller.add(false);
        print('logging out for registration');
        _repository.logOut();
      }
      logger.finest("AuthenticatePhoneManually Successful");
    } catch (error) {
      logger.severe("AuthenticatePhoneManually Unsuccessful");
      controller.addError(error);
    }
    controller.close();
    return controller.stream;
  }
}

class AuthenticatePhoneWithSmsParams {
  String _smsCode;
  AuthenticatePhoneWithSmsParams(this._smsCode);
}