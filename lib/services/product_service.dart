import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_app/models/product.dart';

class ProductService {
	final _auth = FirebaseAuth.instance;
	final _firestore = FirebaseFirestore.instance;

	String get currentUserId {
		final user = _auth.currentUser;
		if (user == null) {
			throw Exception('No authenticated user found.');
		}
		return user.uid;
	}

	CollectionReference get _productsCollection {
		return _firestore.collection('products');
	}

	Future<List<Product>> getAllProducts() async {
		try {
			QuerySnapshot snapshot = await _productsCollection.get();
			List<Product> products = snapshot.docs.map((product) {
				debugPrint('Product data: ${product.data()}');
				return Product.fromMap(
					product.data() as Map<String, dynamic>,
					docId: product.id,
				);
			}).toList();
			return products;
		} catch(e) {
			debugPrint('Error retrieving products: $e');
			throw Exception('Failed to get products');
		}
	}
}