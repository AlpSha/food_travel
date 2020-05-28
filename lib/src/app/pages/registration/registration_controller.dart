import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:food_travel/src/app/pages/home/home_view.dart';
import 'package:food_travel/src/app/pages/splash/splash_view.dart';
import 'package:food_travel/src/domain/entities/user_registration.dart';
import 'package:language_pickers/language_pickers.dart';
import 'package:language_pickers/languages.dart';
import '../../constants.dart';
import 'registration_presenter.dart';

class RegistrationController extends Controller {
  final RegistrationPresenter registrationPresenter;

  final GlobalKey<FormState> formKey = GlobalKey();
  String birthYear;
  String gender;
  Country location = Country.TR;
  Country nationality = Country.TR;
  Language language = LanguagePickerUtils.getLanguageByIsoCode('tr');

  bool isLoading = false;
  bool _registerFailed = false;

  RegistrationController(userRepository)
      : registrationPresenter = RegistrationPresenter(userRepository);

  @override
  void initListeners() {
    registrationPresenter.registerUserOnError = (e) {
      _registerFailed = true;
    };

    registrationPresenter.registerUserOnComplete = () {
      if (_registerFailed) {
        kShowAlert(
            context: getContext(),
            title: "Kayıt başarısız",
            content: "Lütfen daha sonra tekrar deneyiniz");
        _registerFailed = null;
        isLoading = false;
        refreshUI();
      } else {
        Navigator.of(getContext())
            .pushNamedAndRemoveUntil(SplashView.routeName, (_) => false);
      }
    };
  }

  void submitForm() {
    if (!formKey.currentState.validate()) {
      return;
    }
    isLoading = true;
    refreshUI();
    formKey.currentState.save();
    final userRegistration = UserRegistration(
      allergies: [],
      languages: [language.isoCode],
      birthYear: birthYear,
      gender: gender,
      currentCountry: location.isoCode,
      homeCountry: nationality.isoCode,
    );
    registrationPresenter.register(userRegistration);
  }

  void selectLocation(country) {
    this.location = country;
    refreshUI();
  }

  void selectNationality(country) {
    this.nationality = country;
    refreshUI();
  }

  void selectLanguage(Language language) {
    this.language = language;
    refreshUI();
  }
}
