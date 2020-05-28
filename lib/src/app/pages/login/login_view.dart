import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/widgets/login_option_button.dart';
import 'package:food_travel/src/data/repositories/facebook_repository.dart';
import 'package:food_travel/src/data/repositories/phone_repository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'login_controller.dart';

class LoginView extends View {
  static const routeName = "/login";

  @override
  State<StatefulWidget> createState() =>
      _LoginViewState(LoginController(FacebookRepository(), PhoneRepository()));
}

class _LoginViewState extends ViewState<LoginView, LoginController> {
  _LoginViewState(LoginController controller) : super(controller);


  @override
  Widget buildPage() {
    return Scaffold(
      key: globalKey,
      body: (controller.isLoggedIn == null || controller.isLoggedIn) ?
      ModalProgressHUD(
        inAsyncCall: true,
        child: Container(),
      ) :
      ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Login"),
            SizedBox(
              height: 20,
            ),
            LoginOptionButton.fromType(
              type: LoginButtonType.facebook,
              onPressed: controller.loginWithFacebook,
            ),
            SizedBox(
              height: 20,
            ),
            LoginOptionButton.fromType(
                type: LoginButtonType.phone,
                onPressed: controller.loginWithPhone),
          ],
        ),
      ),
    );
  }
}
