import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class CountryInfoPicker extends StatelessWidget {
  final String title;
  final Function onChanged;
  final Country selectedCountry;

  CountryInfoPicker({
    @required this.title,
    @required this.onChanged,
    @required this.selectedCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(
            width: 10,
          ),
          CountryPicker(
            selectedCountry: selectedCountry,
            onChanged: onChanged,
            showName: true,
            showDialingCode: false,
          ),
        ],
      ),
    );
  }
}
