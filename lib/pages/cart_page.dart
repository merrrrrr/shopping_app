import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopping_app/data/cart_items.dart';
import 'package:shopping_app/models/item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: Column(
				children: [
					Expanded(
						child: ListView.builder(
							itemCount: cartItems.length,
							itemBuilder: (context, index) {
								Item cartItem = cartItems[index].keys.first;
								
								return _buildCartItemCard(context, index);
							},
						),
					),

					_buildCheckoutBar(context),

				],
			),
    );
  }

	Widget _buildCheckoutBar(BuildContext context) {
		return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          )
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

		  Text(
			"Total: RM ${cartItems.fold(0.0, (total, item) => total + item.keys.first.price * item.values.first).toStringAsFixed(2)}",
			style: const TextStyle(
			  fontSize: 18,
			  fontWeight: FontWeight.bold,
			),
		  ),

		  ElevatedButton(
			onPressed: cartItems.isEmpty ? null : () {
							final orderId = DateTime.now().millisecondsSinceEpoch.toString();
							cartItems.clear();

							if (!context.mounted) return;
							
              showDialog(
								context: context,
								builder: (context) {
									return AlertDialog(
										title: Text('Checkout Successful'),
										content: Text('Order placed successfully! Order ID: ${orderId.substring(0, 8)}'),
										actions: [
											TextButton(
												onPressed: () => Navigator.of(context).pop(),
												child: Text("OK"),
											),
										],
									);
								}
							);
            },
            child: const Text("Checkout"),
          )
        ],
      ),
    );
	}

	Widget _buildCartItemCard(BuildContext context, int index) {
		final cartItem = cartItems[index].keys.first;
		return Card(
      clipBehavior: Clip.hardEdge,
			margin: const EdgeInsets.symmetric(
				horizontal: 8,
				vertical: 4,
			),

			child: Slidable(
    	  endActionPane: ActionPane(
    	    motion: const BehindMotion(),
    	    extentRatio: 0.35,
    	    children: [
    	      SlidableAction(
    	        onPressed: (context) {
    	          cartItems.removeAt(index);
    	        },
    	        backgroundColor: Colors.red,
    	        foregroundColor: Colors.white,
    	        icon: Icons.delete,
    	        label: 'Delete',
    	        flex: 2,
    	      ),
    	    ]
    	  ),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cartItem.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Text(
                    cartItem.productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                	Row(
                	  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                	  children: [

                    	Text(
                    	  "RM ${cartItem.price.toStringAsFixed(2)}",
                    	  style: TextStyle(
                    	    color: Theme.of(context).colorScheme.primary,
                    	    fontWeight: FontWeight.bold,
                    	    fontSize: 16,
                    	  ),
                    	),

												// Widget: Quantity Selector
                        Row(
                          children: [
							IconButton(
							  icon: const Icon(Icons.remove_circle_outline),
							  onPressed: cartItem.quantity > 1 ? () {
								cartItems[index][cartItem] = cartItem.quantity - 1;
							  } : null,
							),

							Text(
							  cartItem.quantity.toString(),
							  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
							),

                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cartItems[index][cartItem] = cartItem.quantity + 1;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
		);
	}

	Widget _buildEmptyState(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;

    return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Icon(
						Icons.shopping_cart_outlined,
						size: 80,
						color: colorScheme.onSurface.withAlpha(77),
					),
					const SizedBox(height: 16),
					Text(
						'No items in your cart yet',
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.bold,
							color: colorScheme.onSurface,
						),
					),
					const SizedBox(height: 8),
					Text(
						'Start adding products to your cart!',
						style: TextStyle(
							color: colorScheme.onSurface.withAlpha(153),
						),
					),
				],
			),
		);
	}

}

