import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () {},
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
