import 'package:flutter/material.dart';
import 'package:mad_app/widgets/offline_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:mad_app/providers/app_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blue,
      ),
      body: OfflineWrapper(
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            final cartItems = provider.cartItems;
            return Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(child: Text('Your cart is empty.'))
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return ListTile(
                              leading: Image.network(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                              title: Text(item['name']),
                              subtitle: Text(
                                  '${item['quantity']} x ${item['price']}'),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CheckoutScreen(cartItems: cartItems),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
