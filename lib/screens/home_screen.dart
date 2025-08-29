import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mad_app/auth_service.dart';
import 'package:mad_app/shake_detector.dart';
import 'package:mad_app/widgets/offline_wrapper.dart';
import 'package:mad_app/widgets/bottom_navbar.dart';
import 'package:mad_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:mad_app/providers/connectivity_provider.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _products = [];
  bool _isLoading = true;
  Timer? _realtimeTimer;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _startRealtimeUpdates();
  }

  @override
  void dispose() {
    _realtimeTimer?.cancel();
    super.dispose();
  }

  void _startRealtimeUpdates() {
    _realtimeTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        _fetchProducts(silent: true);
      }
    });
  }

  Future<void> _fetchProducts({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final response = await AuthService().getProductsRaw();
      if (response.statusCode == 200) {
        final products =
            await compute(jsonDecode, response.body) as List<dynamic>;
        setState(() {
          _products = products;
          if (!silent) _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      if (!silent) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  int columns = screenWidth > 600 ? 3 : 2;

  return ShakeDetectorWidget(
    child: Scaffold(
      appBar: AppBar(
        title: Text('Latest Products'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _fetchProducts(),
          ),
        ],
      ),
      body: OfflineWrapper(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            name: product['pro_name'],
                            image: product['image'],
                            price: 'Rs ${product['price']}',
                            description: product['description'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: product['image'] != null
                                ? Image.network(
                                    product['image'],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error),
                                  )
                                : Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product['pro_name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Rs ${product['price']}',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    ),
  );
}
}
