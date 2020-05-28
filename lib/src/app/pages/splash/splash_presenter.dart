import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/usecases/initialize_app.dart';

class SplashPresenter extends Presenter {
  Function initializeAppOnComplete;
  Function initializeAppOnError;

  InitializeApp initializeApp;

  SplashPresenter(initializationRepository) : initializeApp = InitializeApp(initializationRepository);

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
