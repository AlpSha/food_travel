import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/user_registration.dart';
import 'package:food_travel/src/domain/usecases/register_user.dart';

class RegistrationPresenter extends Presenter {
  Function registerUserOnComplete;
  Function registerUserOnError;

  final RegisterUser registerUser;

  RegistrationPresenter(userRepository)
      : registerUser = RegisterUser(userRepository),
        super();

  void register(UserRegistration userRegistration) {
    registerUser.execute(
        RegisterUserObserver(this), RegisterUserParams(userRegistration));
  }

  @override
  void dispose() {
    registerUser.dispose();
  }
}

class RegisterUserObserver extends Observer<void> {
  RegistrationPresenter _presenter;

  RegisterUserObserver(this._presenter);

  @override
  void onComplete() {
    assert(_presenter.registerUserOnComplete != null);
    _presenter.registerUserOnComplete();
  }

  @override
  void onError(e) {
    assert(_presenter.registerUserOnError != null);
    _presenter.registerUserOnError(e);
  }

  @override
  void onNext(ignore) {}
}
