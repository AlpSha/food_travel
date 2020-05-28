import 'package:flutter/material.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_view.dart';

class DrawerOptionItem extends StatelessWidget {
  final Function onTap;
  final String title;
  final IconData iconData;

  DrawerOptionItem({
    this.onTap,
    this.title,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: kPrimaryColorLighter,
      child: ListTile(
        leading: Icon(
          iconData,
          color: kPrimaryColor,
        ),
        title: Text(
          title,
          style: kDrawerItemTextStyle(),
        ),
        onTap: onTap,
      ),
    );
  }
}
