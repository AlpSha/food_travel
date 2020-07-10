import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhoneValidationScaffold extends StatefulWidget {
  final List<Widget> children;
  @required
  final String titleText;
  @required
  final GlobalKey<FormState> formKey;
  final GlobalKey<State<StatefulWidget>> key;
  final bool isLoading;

  PhoneValidationScaffold({
    this.children,
    this.titleText: "",
    @required this.formKey,
    this.isLoading: false,
    this.key,
  });

  @override
  _PhoneValidationScaffoldState createState() =>
      _PhoneValidationScaffoldState();
}

class _PhoneValidationScaffoldState extends State<PhoneValidationScaffold> {
  final _appBar = AppBar(
    title: Text("Numaranızı doğrulayın"),
  );

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      key: widget.key,
      inAsyncCall: widget.isLoading,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _appBar,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      widget.titleText,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ...widget.children,
                ],
              ),
            ),
          )),
    );
  }
}