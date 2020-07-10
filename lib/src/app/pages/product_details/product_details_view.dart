import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/product_details/product_details_controller.dart';
import 'package:food_travel/src/app/widgets/badge.dart';
import 'package:food_travel/src/app/widgets/colored_tab_bar.dart';
import 'package:food_travel/src/app/widgets/comments_list_item.dart';
import 'package:food_travel/src/data/repositories/product_repository_data.dart';
import 'package:food_travel/src/data/repositories/shopping_repository_data.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductDetailsView extends View {
  final Product product;

  ProductDetailsView(this.product);

  final productRepositoryData = ProductRepositoryData();

  @override
  State<StatefulWidget> createState() =>
      _ProductDetailsViewState(ProductDetailsController(
        productRepositoryData,
        ShoppingRepositoryData(),
        productRepositoryData,
        product,
      ));
}

class _ProductDetailsViewState
    extends ViewState<ProductDetailsView, ProductDetailsController> {
  _ProductDetailsViewState(ProductDetailsController controller)
      : super(controller);

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
                      height: screenHeight * 0.27,
                    )
                  : Container(
                      width: screenWidth,
                      color: kPrimaryWhiteColor,
                      height: screenHeight * 0.27,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.network(
                          controller.imageUrl,
                        ),
                      ),
                    ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: screenHeight * 0.23,
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth - 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: kGrey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: screenHeight * 0.24,
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth - 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: kPrimaryWhiteColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: TabBarView(
                          children: <Widget>[
                            overallTab(),
                            ingredientsTab(),
                            commentsTab(),
                          ],
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

  Widget commentsTab() {
    return Container(
      child: controller.reviews == null || controller.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                if (!controller.commenting)
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.reviews.length,
                      itemBuilder: (ctx, i) {
                        if(controller.reviews[i].comment.length == 0) {
                          return Container();
                        }
                        return CommentsListItem(controller.reviews[i]);
                      },
                    ),
                  ),
                if (controller.commenting)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SmoothStarRating(
                      color: kCommentStarColor,
                      size: 30,
                      allowHalfRating: false,
                      onRated: (rating) => controller.commentRating = rating,
                    ),
                  ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kGrey,
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(20, 30)),
                            border: Border.all(
                              color: kPrimaryColor,
                            ),
                          ),
                          child: TextField(
                            controller: controller.commentController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              border: InputBorder.none,
                              hintText: 'Yorum',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryColor,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send),
                          color: kPrimaryWhiteColor,
                          onPressed: controller.addReview,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
