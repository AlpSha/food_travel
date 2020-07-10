import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/pages/phone_auth/phone_auth_controller.dart';
import 'package:food_travel/src/app/widgets/phone_validation_scaffold.dart';
import 'package:food_travel/src/data/repositories/phone_repository.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../../constants.dart';

class PhoneAuthView extends View {
  static const String routeName = "/phone-login";

  @override
  State<StatefulWidget> createState() =>
      _PhoneAuthViewState(PhoneAuthController(PhoneRepository()));
}

class _PhoneAuthViewState
    extends ViewState<PhoneAuthView, PhoneAuthController> {
  _PhoneAuthViewState(PhoneAuthController controller) : super(controller);

  @override
  Widget buildPage() {
    return Container(
      color: Colors.white,
      key: globalKey,
      child: controller.phoneEntered ? askVerificationCode : askPhoneNumber,
    ) ;
  }

  Widget get askPhoneNumber {
    return PhoneValidationScaffold(
      formKey: controller.phoneNumberKey,
      isLoading: controller.isLoading,
      titleText: "Telefon numaranızı girin",
      children: <Widget>[
        kPhoneNumberInputWidget(
            context: context,
            onCountryCodeChanged: (value) {
              controller.countryCode = value;
            },
            onPhoneNumberSaved: (value) {
              controller.phoneNumber = value;
            }),
        SizedBox(
          height: 50,
        ),
        kRaisedButton(
          text: "Kod Gönder",
          onPressed: controller.sendCode,
        ),
      ],
    );
  }

  Widget get askVerificationCode {
    return PhoneValidationScaffold(
      formKey: controller.verificationKey,
      titleText: "Doğrulama kodunu girin",
      isLoading: controller.isLoading,
      children: <Widget>[
        PinInputTextFormField(
          pinLength: 6,
          decoration: BoxLooseDecoration(
            radius: Radius.circular(3),
            solidColor: kPrimaryColorLight,
            strokeColor: kGrey,
            enteredColor: kPrimaryColorLighter,
            textStyle: TextStyle(
              fontSize: 17,
            ),
            errorTextStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: kErrorColor,
              decorationColor: kErrorColor,
            ),
            strokeWidth: 2,
          ),
          onSaved: (value) {
            controller.pinCode = value;
          },
          validator: (value) {
            if (value.length != 6) {
              return "Doğrulama kodunu eksik girdiniz";
            }
            return null;
          },
        ),
        SizedBox(
          height: 50,
        ),
        kRaisedButton(
          onPressed: controller.verifyCode,
          text: "Doğrula",
        ),
      ],
    );
  }
}
