import 'package:flutter/material.dart';
import 'package:shopping_app/data/favourite_items.dart';
import 'package:shopping_app/data/product_data.dart';
import 'package:shopping_app/widgets/product_card.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        elevation: 0,
      ),
      body: GridView.builder(
				padding: const EdgeInsets.all(8),
				gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
					crossAxisCount: 2,
					childAspectRatio: 0.65,
					crossAxisSpacing: 12,
					mainAxisSpacing: 12,
				),
				itemCount: favouriteItems.length,
				itemBuilder: (context, index) {
					final productId = favouriteItems.elementAt(index);
					final product = products.firstWhere((product) => product.id == productId);
					return ProductCard(product: product);
				},
			),
    );
  }
}