import 'package:shopping_app/models/item.dart';

class Order {
  final String? id;
  final String userId;
	final List<Item> items;
  final double totalAmount;
  final String shippingAddress;
  final DateTime createdAt;

  Order({
    this.id,
    required this.userId,
		required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.createdAt,
  });
}