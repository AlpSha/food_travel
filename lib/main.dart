import 'package:flutter/material.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/phone_auth/phone_auth_view.dart';
import 'package:food_travel/src/app/pages/splash/splash_view.dart';
import 'src/app/pages/home/home_view.dart';
import 'src/app/pages/login/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: kButtonColor,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: LoginView(),
      routes: {
        LoginView.routeName: (ctx) => LoginView(),
        HomeView.routeName: (ctx) => HomeView(),
        PhoneAuthView.routeName: (ctx) => PhoneAuthView(),
        SplashView.routeName: (ctx) => SplashView(),
      },
    );
  }
}
