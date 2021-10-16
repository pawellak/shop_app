import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Products>(context, listen: false);
    return ListTile(
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () {
                product.removeProduct(id);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
