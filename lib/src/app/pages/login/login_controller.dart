import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_view.dart';
import 'package:food_travel/src/app/pages/login/login_presenter.dart';
import 'package:food_travel/src/app/pages/phone_auth/phone_auth_view.dart';
import 'package:food_travel/src/app/pages/registration/registration_view.dart';
import 'package:food_travel/src/app/pages/splash/splash_view.dart';
import 'package:food_travel/src/domain/repositories/registration_repository.dart';


class LoginController extends Controller {
  final LoginPresenter loginPresenter;
  final RegistrationRepository _facebookRepository;

  bool isLoggedIn;
  bool isLoading = false;

  LoginController(facebookRepository, phoneRepository)
      : loginPresenter = LoginPresenter(facebookRepository, phoneRepository),
  _facebookRepository = facebookRepository,
        super();

  void loginWithFacebook() async {
    isLoading = true;
    refreshUI();
    loginPresenter.facebookLogin();
  }

  void loginWithPhone() {
    Navigator.of(getContext()).pushNamed(PhoneAuthView.routeName);
  }

  @override
  void initController(GlobalKey<State<StatefulWidget>> key) {
    loginPresenter.checkLoggedIn();
    super.initController(key);
  }

  @override
  void initListeners() {
    loginPresenter.checkIfLoggedInOnError = (e) {
      kShowAlert(context: getContext(), title: "Bilgi alınamadı.", content: "Giriş yaptığınıza dair bilgi sorgulanamadı. Lütfen daha sonra tekrar deneyin veya giriş yapın.");
      isLoggedIn = false;
    };

    loginPresenter.checkIfLoggedInOnNext = (bool result) {
      isLoggedIn = result;
    };

    loginPresenter.checkIfLoggedInOnComplete = () {
      if(isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(getContext(), SplashView.routeName, (_) => false);
      } else {
        refreshUI();
      }
    };

    loginPresenter.loginWithFacebookOnComplete = () {};

    loginPresenter.loginWithFacebookOnNext = (bool isRegistered) {
      if(isRegistered) {
        Navigator.of(getContext()).pushNamedAndRemoveUntil(SplashView.routeName, (_) => false);
      } else {
        Navigator.of(getContext()).pushReplacement(MaterialPageRoute(builder: (ctx) => RegistrationView(_facebookRepository)));
      }
    };

    loginPresenter.loginWithFacebookOnError = (e) {
      if(e.message == "canceled") {
        isLoading = false;
        refreshUI();
      } else {
        kShowAlert(
          context: getContext(),
          title: "Facebook hesabınız doğrulanamadı",
          content: e.message,
        );
      }
    };
  }
}
