import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/product_details/product_details_controller.dart';
import 'package:food_travel/src/app/widgets/badge.dart';
import 'package:food_travel/src/app/widgets/colored_tab_bar.dart';
import 'package:food_travel/src/data/repositories/product_repository_data.dart';
import 'package:food_travel/src/data/repositories/shopping_repository_data.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductDetailsView extends View {
  final Product product;

  ProductDetailsView(this.product);

  @override
  State<StatefulWidget> createState() =>
      _ProductDetailsViewState(ProductDetailsController(
        ProductRepositoryData(),
        ShoppingRepositoryData(),
        product,
      ));
}

class _ProductDetailsViewState
    extends ViewState<ProductDetailsView, ProductDetailsController> {
  _ProductDetailsViewState(ProductDetailsController controller)
      : super(controller);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPage() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        key: globalKey,
        appBar: kAppBarWithBackButton(
          context,
          'Ürün Detayları',
          bottom: ColoredTabBar(
            kPrimaryWhiteColor,
            TabBar(
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              indicatorColor: kPrimaryColorLight,
              labelColor: kPrimaryColor,
              tabs: <Widget>[
                Tab(
                  child: Text('GENEL'),
                ),
                Tab(
                  child: Text('İÇERİK'),
                ),
                Tab(
                  child: Text('YORUMLAR'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Badge(
              child: IconButton(
                icon: Icon(Icons.list),
                onPressed: controller.openListPage,
              ),
              value: '${controller.itemCountOnList}',
              noBadge: controller.itemCountOnList == null ||
                  controller.itemCountOnList == 0,
            ),
          ],
        ),
        body: Container(
          color: kGrey,
          width: screenWidth,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              controller.imageUrl == null
                  ? Container(
                      height: screenHeight * 0.4,
                    )
                  : Container(
                      color: kPrimaryWhiteColor,
                      height: screenHeight * 0.4,
                      child: Image.network(
                        controller.imageUrl,
                      ),
                    ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: screenHeight * 0.35,
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth - 60,
                      color: kGrey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: screenHeight * 0.37,
                  ),
                  Expanded(
                    child: Card(
                      elevation: 15,
                      child: Container(
                        width: screenWidth - 30,
                        color: kPrimaryWhiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: TabBarView(
                            children: <Widget>[
                              overallTab(),
                              ingredientsTab(),
                              Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget overallTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            controller.product.title,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SmoothStarRating(
            color: kCommentStarColor,
            isReadOnly: true,
            rating: controller.product.avgRate,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            top: 10.0,
          ),
          child: Text(
            '\$ ${controller.product.price}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget ingredientsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Allerjenler',
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          controller.product.allergensString,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'İçindekiler',
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: 7,
        ),
        Text(controller.product.ingredientsString,
            style: TextStyle(
              fontSize: 16,
            ))
      ],
    );
  }
}
