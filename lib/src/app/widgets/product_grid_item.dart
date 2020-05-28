import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;
  final Function toggleFavorite;
  final Function addToList;
  final Function undoAddToList;

  ProductGridItem({
    @required this.product,
    @required this.toggleFavorite,
    @required this.addToList,
    @required this.undoAddToList,
  });

  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  final _firebaseStorage = FirebaseStorage.instance;

  String url;

  void prepareUrl() async {
    final ref = _firebaseStorage.ref().child(widget.product.imageUrl);
    url = await ref.getDownloadURL();
    setState(() {});
  }

  @override
  void initState() {
    prepareUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(1.5, 1.5),
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                //TODO
              },
              child: url == null
                  ? Container()
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
            ),
            header: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                widget.product.title,
                style: TextStyle(color: Colors.white),
              ),
              color: kPrimaryColorLight,
            ),
            footer: GridTileBar(
              backgroundColor: kPrimaryColorLightest,
              leading: IconButton(
                icon: Icon(widget.product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: widget.toggleFavorite,
                color: kPrimaryColor,
              ),
              title: Text(
                "\$${widget.product.price}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  widget.addToList();
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Alışveriş listesine eklendi',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "Geri al",
                        onPressed: widget.undoAddToList,
                      ),
                    ),
                  );
                },
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
