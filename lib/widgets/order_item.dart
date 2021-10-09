import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
              title: Text('\$${order.amount}'),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {},
              ),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(order.dataTime),
              ))
        ],
      ),
    );
  }
}
