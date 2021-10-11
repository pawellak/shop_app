import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-product';
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) {
            return UserProductItem(
                title: productsData.items[i].title,
                imageUrl: productsData.items[i].imageUrl);
          },
        ),
      ),
    );
  }
}
