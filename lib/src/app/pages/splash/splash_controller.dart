import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_view.dart';
import 'package:food_travel/src/app/pages/splash/splash_presenter.dart';

class SplashController extends Controller {
  final SplashPresenter _presenter;

  SplashController(initializationRepository)
      : _presenter = SplashPresenter(initializationRepository);

  @override
  void initListeners() {
    _presenter.initializeAppOnComplete = () {
      Navigator.of(getContext()).pushReplacementNamed(HomeView.routeName);
    };

    _presenter.initializeAppOnError = (e) {
      kShowAlert(context: getContext(), title: 'Hata oluştu', content: 'Üzgünüm, uygulamayı başlatamıyoruz');
    };
  }

  @override
  void initController(GlobalKey<State<StatefulWidget>> key) {
    _presenter.startInitialization();
    super.initController(key);
  }
}
