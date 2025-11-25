class Product {
  final String? id;
  final String name;
  final int sales;
  final double price;
  final String description;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int quantity;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.sales,
    required this.description,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.quantity,
  });
}