import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/favourite_provider.dart';
import 'package:shopping_app/services/product_service.dart';
import 'package:shopping_app/widgets/product_card.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
	final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Product>>(
				future: _productService.getAllProducts(),
				builder: (context, snapshot) {
				  if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

					if (snapshot.hasError) {
            return Center(
              child: Text('Error loading products: ${snapshot.error}'),
            );
          }

					return Consumer<FavouriteProvider>(
						builder: (context, favouriteProvider, child) {					
							// Filter products that are in favourites
							final favouriteProducts = snapshot.data!.where((product) {
								return favouriteProvider.isFavourite(product.id!);
							}).toList();
					
							return GridView.builder(
								padding: const EdgeInsets.all(8),
								gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
									crossAxisCount: 2,
									childAspectRatio: 0.65,
									crossAxisSpacing: 12,
									mainAxisSpacing: 12,
								),
								itemCount: favouriteProducts.length,
								itemBuilder: (context, index) {
									final product = favouriteProducts[index];
									return ProductCard(product: product);
								},
							);
						},
					);
				},
			),
    );
  }
}