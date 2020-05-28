import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginOptionButton extends StatelessWidget {
  String text;
  Function onPressed;
  IconData icon;
  Color color;

  LoginOptionButton.fromType({
    @required LoginButtonType type,
    @required Function this.onPressed,
  }) {
    switch (type) {
      case LoginButtonType.facebook:
        this.text = "Facebook ile devam et";
        this.icon = FontAwesomeIcons.facebookSquare;
        this.color = Color(0xFFB4267B2);
        break;
      case LoginButtonType.phone:
        this.text = "Telefon numarasıyla giriş";
        this.icon = FontAwesomeIcons.phone;
        this.color = Color(0xFFB43C5A5);
    }
  }

  LoginOptionButton({
    @required this.text,
    @required this.onPressed,
    this.icon,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            FaIcon(
              icon,
              size: 35,
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
        onPressed: onPressed,
        color: color,
        textColor: Colors.white,
      ),
    );
  }
}

enum LoginButtonType {
  facebook,
  phone,
}