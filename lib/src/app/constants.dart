import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_travel/src/app/pages/home/home_view.dart';
import 'package:food_travel/src/app/widgets/drawer_option_item.dart';

const kPrimaryColor = Color(0xffed3851);
const kPrimaryColorLight = Color(0xfff25f73);
const kPrimaryColorLighter = Color(0xfff4c6ce);
const kPrimaryColorLightest = Color(0xfff6eaed);
const kFadedColor = kPrimaryColorLight;
const kPrimaryTextColor = Color(0xff191919);
const kGrey = Color(0xffe8e8e8);
const kGreyBorderColor = Color(0xffd2d2d2);
const kGreyDark = Color(0xffababab);
const kTextFieldColor = kPrimaryWhiteColor;
const kButtonColor = kPrimaryColor;
const kCommentStarColor = Color(0xffffc000);
const kErrorColor = Color(0xffbb0000);
const kPrimaryWhiteColor = Color(0xffffffff);
const kSecondaryWhiteColor = Color(0xffe2e2e2);

final kPhonePattern = RegExp(r'^(\+[0-9]{3})?[0-9]{10}$');

Widget kFormTextField({
  @required Function onSaved,
  @required Function validator,
  TextInputType keyboardType: TextInputType.text,
  String hintText: '',
  String labelText: '',
  int lengthLimit,
}) {
  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(lengthLimit),
    ],
    keyboardType: keyboardType,
    decoration: InputDecoration(
      fillColor: kTextFieldColor,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kPrimaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kPrimaryColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kErrorColor, width: 1),
      ),
      hintStyle: TextStyle(color: kPrimaryColorLighter),
      hintText: hintText,
      labelText: labelText,
      errorStyle: TextStyle(
        color: kErrorColor,
        fontSize: 14,
      ),
    ),
    style: TextStyle(color: kPrimaryTextColor),
    onSaved: onSaved,
    validator: validator,
  );
}

Widget kTextField({
  TextInputType keyboardType: TextInputType.text,
  String hintText: '',
  String labelText: '',
  int lengthLimit,
  double fontSize,
  Alignment alignment,
  Widget prefixIcon,
  double verticalPadding: 15,
}) {
  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(lengthLimit),
    ],
    keyboardType: keyboardType,
    decoration: InputDecoration(
      fillColor: kTextFieldColor,
      filled: true,
      contentPadding:
          EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kPrimaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: kPrimaryColor, width: 1),
      ),
      hintStyle: TextStyle(color: kPrimaryColorLight),
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
    ),
    style: TextStyle(
      color: Colors.white,
      fontSize: fontSize,
    ),
  );
}

Widget kRaisedButton({
  Function onPressed,
  String text,
}) {
  return Container(
    width: double.infinity,
    child: RaisedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget kPhoneNumberInputWidget({
  @required Function onCountryCodeChanged,
  @required Function onPhoneNumberSaved,
  @required BuildContext context,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Flexible(
        flex: 8,
        child: Container(
          height: 50,
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: kPrimaryColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(3),
            color: kTextFieldColor,
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: CountryCodePicker(
              onChanged: onCountryCodeChanged,
              initialSelection: "TR",
              favorite: ["+90", "TR"],
              showOnlyCountryWhenClosed: false,
              textStyle: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontWeight: FontWeight.w300, fontSize: 19),
            ),
          ),
        ),
      ),
      Flexible(
        flex: 14,
        child: kFormTextField(
          onSaved: onPhoneNumberSaved,
          validator: (value) {
            if (value.length == 0) {
              return "Numaranızı girin";
            } else if (!kPhonePattern.hasMatch(value)) {
              return "Hatalı numara girdiniz";
            }
            return null;
          },
          keyboardType: TextInputType.phone,
          hintText: "5#########",
          lengthLimit: 10,
        ),
      ),
    ],
  );
}

AppBar kAppBarWithBackButton(BuildContext context, String title,
    {List<Widget> actions, Widget bottom}) {
  return AppBar(
    title: Text(
      title,
      style: kAppBarTitleStyle(),
    ),
    bottom: bottom,
    centerTitle: true,
    backgroundColor: kPrimaryColor,
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    ),
    actions: actions,
  );
}

AppBar kAppBar(String title, {List<Widget> actions}) {
  return AppBar(
    title: Text(
      title,
      style: kAppBarTitleStyle(),
    ),
    centerTitle: true,
    backgroundColor: kPrimaryColor,
    elevation: 0,
    actions: <Widget>[
      ...actions,
    ],
  );
}

TextStyle kAppBarTitleStyle() {
  return TextStyle(
    fontSize: 23,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w400,
  );
}

Widget kMainDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      color: kPrimaryColorLightest,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text(
              'Menü',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          DrawerOptionItem(
            title: 'Ürünler',
            iconData: Icons.local_grocery_store,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(HomeView.routeName),
          ),
          DrawerOptionItem(
            title: 'Favoriler',
            iconData: Icons.star,
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => HomeView(
                  onlyFavorites: true,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

TextStyle kDrawerItemTextStyle() {
  return TextStyle(
    fontSize: 20,
    color: kPrimaryColor,
  );
}

void kShowAlert({
  @required BuildContext context,
  @required String title,
  @required String content,
  List<Widget> actions,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: kGrey,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline2.copyWith(
                color: Colors.black,
              ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        actions: actions != null
            ? actions
            : <Widget>[
                FlatButton(
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
      );
    },
  );
}
