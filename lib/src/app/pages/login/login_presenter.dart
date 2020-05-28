import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/usecases/check_if_logged_in.dart';
import 'package:food_travel/src/domain/usecases/login_with_facebook.dart';

class LoginPresenter extends Presenter {
  Function loginWithFacebookOnComplete;
  Function loginWithFacebookOnError;
  Function loginWithFacebookOnNext;

  Function checkIfLoggedInOnComplete;
  Function checkIfLoggedInOnError;
  Function checkIfLoggedInOnNext;


  final LoginWithFacebook loginWithFacebook;
  final CheckIfLoggedIn checkIfLoggedIn;

  LoginPresenter(facebookRepository, phoneRepository) : loginWithFacebook =
  LoginWithFacebook(facebookRepository),
  checkIfLoggedIn = CheckIfLoggedIn(facebookRepository);

  @override
  void dispose() {
    loginWithFacebook.dispose();
    checkIfLoggedIn.dispose();
  }

  void facebookLogin() {
    loginWithFacebook.execute(
      _LoginWithFacebookObserver(this),
    );
  }

  void checkLoggedIn() {
    checkIfLoggedIn.execute(_CheckIfLoggedInObserver(this));
  }
}

class _LoginWithFacebookObserver extends Observer<bool> {
  final LoginPresenter presenter;
  _LoginWithFacebookObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.loginWithFacebookOnComplete != null);
    presenter.loginWithFacebookOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.loginWithFacebookOnError != null);
    presenter.loginWithFacebookOnError(e);
  }

  @override
  void onNext(bool isRegistered) {
    assert(presenter.loginWithFacebookOnNext != null);
    presenter.loginWithFacebookOnNext(isRegistered);
  }
}

class _CheckIfLoggedInObserver extends Observer<bool> {
  final LoginPresenter presenter;
  _CheckIfLoggedInObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.checkIfLoggedInOnComplete != null);
    presenter.checkIfLoggedInOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.checkIfLoggedInOnError != null);
    presenter.checkIfLoggedInOnError(e);
  }

  @override
  void onNext(bool response) {
    assert(presenter.checkIfLoggedInOnNext != null);
    presenter.checkIfLoggedInOnNext(response);
  }

}