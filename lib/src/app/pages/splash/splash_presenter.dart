import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/usecases/initialize_app.dart';

class SplashPresenter extends Presenter {
  Function initializeAppOnComplete;
  Function initializeAppOnError;

  InitializeApp initializeApp;

  SplashPresenter(initializationRepository)
      : initializeApp = InitializeApp(initializationRepository);

  void startInitialization() {
    initializeApp.execute(InitializeAppObserver(this));
  }

  @override
  void dispose() {
    initializeApp.dispose();
  }
}

class InitializeAppObserver extends Observer<void> {
  final SplashPresenter _presenter;

  InitializeAppObserver(this._presenter);

  @override
  void onComplete() {
    assert(_presenter.initializeAppOnComplete != null);
    _presenter.initializeAppOnComplete();
  }

  @override
  void onError(e) {
    assert(_presenter.initializeAppOnError != null);
    _presenter.initializeAppOnError(e);
  }

  @override
  void onNext(_) {}
}
