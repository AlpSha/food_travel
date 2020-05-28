import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_controller.dart';
import 'package:food_travel/src/app/widgets/product_grid_item.dart';
import 'package:food_travel/src/data/repositories/product_repository_data.dart';

class HomeView extends View {
  static const routeName = '/home';

  final onlyFavorites;

  HomeView({this.onlyFavorites: false});

  @override
  State<StatefulWidget> createState() =>
      _HomeViewState(HomeController(ProductRepositoryData(), onlyFavorites));
}

class _HomeViewState extends ViewState<HomeView, HomeController> {
  _HomeViewState(HomeController controller) : super(controller);

  @override
  Widget buildPage() {
    return Scaffold(
      key: globalKey,
      appBar: kAppBar(controller.appBarTitle),
      drawer: kMainDrawer(context),
      body: controller.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) {
                  final product = controller.products[i];
                  return ProductGridItem(
                    product: product,
                    addToList: () => controller.addToList(product),
                    toggleFavorite: () =>
                        controller.toggleFavoriteProduct(product),
                    undoAddToList: () => controller.undoAddToList(product),
                  );
                },
                itemCount: controller.products.length,
              ),
            ),
    );
  }
}
