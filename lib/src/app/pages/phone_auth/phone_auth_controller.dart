import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/pages/home/home_view.dart';
import 'package:food_travel/src/app/pages/registration/registration_view.dart';
import 'package:food_travel/src/app/pages/splash/splash_view.dart';
import 'package:food_travel/src/data/repositories/phone_repository.dart';

import '../../constants.dart';
import 'phone_auth_presenter.dart';

class PhoneAuthController extends Controller {
  final GlobalKey<FormState> phoneNumberKey = GlobalKey();
  final GlobalKey<FormState> verificationKey = GlobalKey();

  final PhoneAuthPresenter presenter;
  bool phoneEntered = false;
  String countryCode = "+90";
  String phoneNumber;
  String pinCode;
  bool isLoading = false;
  bool _isRegistered;

  final PhoneRepository _phoneRepository;

  PhoneAuthController(phoneRepository)
      : presenter = PhoneAuthPresenter(phoneRepository),
        _phoneRepository = phoneRepository;

  @override
  void initListeners() {
    presenter.startPhoneAuthenticationOnComplete = () {
      phoneEntered = true;
      refreshUI();
      presenter.autoLogin();
    };

    presenter.startPhoneAuthenticationOnError = (e) {
      phoneEntered = false;
      isLoading = false;
      refreshUI();
      kShowAlert(
        context: getContext(),
        title: "Doğrulama başlatılamadı",
        content: e.message,
      );
    };

    presenter.autoAuthenticateOnError = (e) {
      isLoading = false;
      refreshUI();
    };

    presenter.autoAuthenticateOnNext = (bool isRegistered) {
      _isRegistered = isRegistered;
      authenticationOnComplete();
    };

    presenter.manualAuthenticateOnError = (e) {
      kShowAlert(
        context: getContext(),
        title: "Doğrulama başarısız",
        content: "Daha sonra tekrar deneyin",
      );
      isLoading = false;
      refreshUI();
    };

    presenter.manualAuthenticateOnNext = (bool isRegistered) {
      _isRegistered = isRegistered;
      authenticationOnComplete();
    };
  }

  void authenticationOnComplete() {
    if (_isRegistered) {
      Navigator.of(getContext())
          .pushNamedAndRemoveUntil(SplashView.routeName, (_) => false);
    } else {
      Navigator.of(getContext()).pushReplacement(MaterialPageRoute(
          builder: (ctx) => RegistrationView(_phoneRepository)));
    }
  }

  void sendCode() {
    if (!phoneNumberKey.currentState.validate()) {
      return;
    }
    phoneNumberKey.currentState.save();
    isLoading = true;
    refreshUI();
    presenter.sendSmsCode("$countryCode$phoneNumber");
  }

  void verifyCode() {
    if (!verificationKey.currentState.validate()) {
      return;
    }
    verificationKey.currentState.save();
    isLoading = true;
    refreshUI();
    presenter.loginWithSmsCode(pinCode);
  }
}
