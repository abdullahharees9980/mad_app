import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad_app/providers/app_provider.dart';
import 'package:mad_app/providers/connectivity_provider.dart';
import 'checkout_screen.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // ✅ Main cart content
          Consumer<AppProvider>(
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
                                subtitle:
                                    Text('${item['quantity']} x ${item['price']}'),
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

          //block interaction and show offline message
          if (!isOnline)
            Container(
              color: Colors.black.withOpacity(0.7),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.wifi_off, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
