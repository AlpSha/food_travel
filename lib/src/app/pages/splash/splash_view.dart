import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/splash/splash_controller.dart';
import 'package:food_travel/src/data/repositories/initialization_repository_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SplashView extends View {
  static const routeName = '/splash';

  @override
  State<StatefulWidget> createState() =>
      _SplashViewState(SplashController(InitializationRepositoryData()));
}

class _SplashViewState extends ViewState<SplashView, SplashController> {
  _SplashViewState(SplashController controller) : super(controller);

  @override
  Widget buildPage() {
    return Scaffold(
      key: globalKey,
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: true,
          child: Container(),
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
