import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
      {Key? key,
      required this.id,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          padding: const EdgeInsets.all(15),
          color: Theme.of(context).errorColor,
          child: const Icon(
            Icons.delete,
            size: 40,
          ),
          alignment: Alignment.centerRight),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to remove the item from cart?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'))
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
