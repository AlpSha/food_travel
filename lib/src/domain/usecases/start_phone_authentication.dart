import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/data/repositories/phone_repository.dart';

class StartPhoneAuthentication extends UseCase<void, StartVerificationParams> {
  final PhoneRepository _repository;
  StartPhoneAuthentication(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(StartVerificationParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      await _repository.startVerification(params._phoneNumber);
      controller.close();
    } catch (error) {
      logger.severe("StartPhoneVerification Unsuccessful");
      controller.addError(error);
    }
    return controller.stream;
  }
}

class StartVerificationParams {
  String _phoneNumber;
  StartVerificationParams(this._phoneNumber);
}