import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/usecases/authenticate_phone_automatically.dart';
import 'package:food_travel/src/domain/usecases/authenticate_phone_manually.dart';
import 'package:food_travel/src/domain/usecases/start_phone_authentication.dart';

class PhoneAuthPresenter extends Presenter {
  Function startPhoneAuthenticationOnComplete;
  Function startPhoneAuthenticationOnError;

  Function autoAuthenticateOnError;
  Function autoAuthenticateOnNext;

  Function manualAuthenticateOnError;
  Function manualAuthenticateOnNext;
  
  final StartPhoneAuthentication startPhoneAuthentication;
  final AuthenticatePhoneManually authenticatePhoneManually;
  final AuthenticatePhoneAutomatically authenticatePhoneAutomatically;
  
  PhoneAuthPresenter(phoneRepository) :
      startPhoneAuthentication = StartPhoneAuthentication(phoneRepository),
      authenticatePhoneManually = AuthenticatePhoneManually(phoneRepository),
      authenticatePhoneAutomatically = AuthenticatePhoneAutomatically(phoneRepository);

  void sendSmsCode(String phoneNumber) {
    startPhoneAuthentication.execute(_StartPhoneAuthenticationObserver(this), StartVerificationParams(phoneNumber));
  }

  void loginWithSmsCode(String code) {
    authenticatePhoneManually.execute(_AuthenticatePhoneManuallyObserver(this), AuthenticatePhoneWithSmsParams(code));
  }

  void autoLogin() {
    authenticatePhoneAutomatically.execute(_AuthenticatePhoneAutomaticallyObserver(this));
  }

  @override
  void dispose() {
    startPhoneAuthentication.dispose();
    authenticatePhoneManually.dispose();
    authenticatePhoneAutomatically.dispose();
  }}

  class _AuthenticatePhoneManuallyObserver extends Observer<bool> {
  final PhoneAuthPresenter presenter;
  _AuthenticatePhoneManuallyObserver(this.presenter);
  @override
  void onComplete() {}

  @override
  void onError(e) {
    assert(presenter.manualAuthenticateOnError != null);
    presenter.manualAuthenticateOnError(e);
  }

  @override
  void onNext(bool isRegistered) {
    assert(presenter.manualAuthenticateOnNext != null);
    presenter.autoAuthenticateOnNext(isRegistered);
  }

  }

  class _AuthenticatePhoneAutomaticallyObserver extends Observer<bool> {
    final PhoneAuthPresenter presenter;
    _AuthenticatePhoneAutomaticallyObserver(this.presenter);

    @override
    void onComplete() {}

    @override
    void onError(e) {
      assert(presenter.autoAuthenticateOnError != null);
      presenter.autoAuthenticateOnError(e);
    }

    @override
    void onNext(bool isRegistered) {
      assert(presenter.autoAuthenticateOnNext != null);
      presenter.autoAuthenticateOnNext(isRegistered);
    }

  }

  class _StartPhoneAuthenticationObserver extends Observer<void> {
    final PhoneAuthPresenter presenter;
    _StartPhoneAuthenticationObserver(this.presenter);

    @override
    void onComplete() {
      assert(presenter.startPhoneAuthenticationOnComplete != null);
      presenter.startPhoneAuthenticationOnComplete();
    }

    @override
    void onError(e) {
      assert(presenter.startPhoneAuthenticationOnError != null);
      presenter.startPhoneAuthenticationOnError(e);
    }

    @override
    void onNext(ignore) {}

  }