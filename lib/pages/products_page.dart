import 'package:flutter/material.dart';
import 'package:shopping_app/services/product_service.dart';
import '../../models/product.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
	final ProductService _productService = ProductService();
	final TextEditingController searchBarController = TextEditingController();
	List<Product> _allProducts = [];
	List<Product> _filteredProducts = [];
	bool _isLoading = true;

	@override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getAllProducts();
			if (!mounted) return;
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
			if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load products: $e')));
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

	@override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
			appBar: AppBar(
				title: TextField(
          controller: searchBarController,
          decoration: InputDecoration(
            hintText: "Search products...",
            prefixIcon: Icon(
        			Icons.search,
              color: Theme.of(context).colorScheme.secondary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
          onSubmitted: (value) {
            _filterProducts(value);
          },
        ),
			),

      body: _isLoading
			? Center(child: CircularProgressIndicator())
			: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
        children: [
					Padding(
						padding: const EdgeInsets.only(left: 16.0, top: 8.0),
						child: Text(
							"${_filteredProducts.length} Products Found",
							style: const TextStyle(
								fontWeight: FontWeight.bold
							),
						),
					),

          if (_filteredProducts.isEmpty) ...[
            const Center(
              child: Text("No products found"),
            )
          ] else ...[
      
            // ========== PRODUCTS GRID BUILDER ==========
            Expanded(
          		child: GridView.builder(
          			padding: const EdgeInsets.all(8),
          			gridDelegate:
          				const SliverGridDelegateWithFixedCrossAxisCount(
          				crossAxisCount: 2,
          				crossAxisSpacing: 8,
          				mainAxisSpacing: 8,
          				childAspectRatio: 0.65,
          			),
          			itemCount: _filteredProducts.length,
          			itemBuilder: (context, index) {
          				final product = _filteredProducts[index];
          				return ProductCard(product: product);
          			},
          		),
          	),
          ],
				]
      ),
    );
  }
}
