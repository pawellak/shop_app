import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Hero(

              tag: product.id,
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavouriteStatus(auth.token!, auth.userId);
              },
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                  productId: product.id,
                  price: product.price,
                  title: product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Added item to cart',
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
