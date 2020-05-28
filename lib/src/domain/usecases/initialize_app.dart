import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/repositories/initialization_repository.dart';

class InitializeApp extends UseCase<void, void> {
  final InitializationRepository _repository;

  InitializeApp(
    this._repository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    StreamController<void> controller = StreamController();
    try {
      await _repository.fetchAllData();
      controller.close();
    } catch (e, st) {
      print(e);
      print(st);
      controller.addError(e);
    }
    return controller.stream;
  }
}
