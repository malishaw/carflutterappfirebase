import 'package:flutter/material.dart';
import 'product.dart';

class FavoritePage extends StatelessWidget {
  final List<Product> favorites;

  FavoritePage({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favorites[index].name),
            subtitle: Text('LKR ${favorites[index].price.toStringAsFixed(2)}'), // Change currency to LKR
          );
        },
      ),
    );
  }
}
