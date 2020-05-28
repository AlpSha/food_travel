import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/data/repositories/product_repository_data.dart';

import 'home_controller.dart';

class HomeView extends View {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() =>
      _HomeViewState(HomeController(ProductRepositoryData()));
}

class _HomeViewState extends ViewState<HomeView, HomeController> {
  _HomeViewState(HomeController controller) : super(controller);

  @override
  void initState() {
    controller.fetchProducts();
    super.initState();
  }

  @override
  Widget buildPage() {
    return Scaffold(
      appBar: kAppBar('Products'),
      drawer: kMainDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (ctx, i) => Card(
            child: Text(i.toString()),
          ),
          itemCount: 30,
        ),
      ),
    );
  }
}
