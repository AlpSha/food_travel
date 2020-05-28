import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/pages/splash/splash_presenter.dart';

class SplashController extends Controller {
  final SplashPresenter _presenter;

  SplashController(
    initializationRepository
  ) : _presenter = SplashPresenter(initializationRepository);

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
