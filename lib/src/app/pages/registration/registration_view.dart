
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/pages/registration/registration_controller.dart';
import 'package:food_travel/src/app/widgets/country_info_picker.dart';
import 'package:food_travel/src/domain/repositories/registration_repository.dart';
import 'package:language_pickers/language_picker_dropdown.dart';
import 'package:language_pickers/languages.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';

class RegistrationView extends View {
  final RegistrationRepository _userRepository;

  RegistrationView(this._userRepository);

  @override
  State<StatefulWidget> createState() =>
      _RegistrationViewState(RegistrationController(_userRepository));
}

class _RegistrationViewState
    extends ViewState<RegistrationView, RegistrationController> {
  _RegistrationViewState(RegistrationController controller) : super(controller);

  List<DropdownMenuItem<String>> _genders = [
    DropdownMenuItem(
      child: Text("Erkek"),
      value: "Male",
    ),
    DropdownMenuItem(
      child: Text("Kadın"),
      value: "Female",
    ),
    DropdownMenuItem(
      child: Text("Diğer"),
      value: "Other",
    )
  ];

  Widget _buildDropdownItem(Language language) {
    return Container(
      child: Text("${language.name} (${language.isoCode})"),
      width: 150,
    );
  }

  @override
  Widget buildPage() {
    return Scaffold(
      key: globalKey,
      body: ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Bilgilerinizi Girin",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                kFormTextField(
                  lengthLimit: 4,
                  keyboardType: TextInputType.number,
                  labelText: "Doğum Yılınız",
                  onSaved: (value) {
                    controller.birthYear = value;
                  },
                  validator: (value) {
                    try {
                      var year = int.parse(value);
                      if (year < 2015 && year > 1930) {
                        return null;
                      }
                    } catch (error) {
                      return "Lütfen geçerli bir yıl girin";
                    }
                    return "Lütfen doğum yılınızı doğru girin";
                  },
                ),
                DropdownButton<String>(
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: kPrimaryColor,
                  ),
                  items: _genders,
                  value: controller.gender,
                  onChanged: (value) {
                    setState(() {
                      controller.gender = value;
                    });
                  },
                  hint: Text("Cinsiyetiniz"),
                ),
                CountryInfoPicker(
                  title: 'Konum',
                  selectedCountry: controller.location,
                  onChanged: (country) => controller.selectLocation(country),
                ),
                CountryInfoPicker(
                  title: 'Uyruk',
                  selectedCountry: controller.nationality,
                  onChanged: (country) => controller.selectNationality(country),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Dil',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    LanguagePickerDropdown(
                      itemBuilder: _buildDropdownItem,
                      initialValue: controller.language.isoCode,
                      onValuePicked: (language) =>
                          controller.selectLanguage(language),
                    ),
                  ],
                ),
                kRaisedButton(
                  text: "Kaydet",
                  onPressed: controller.submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
