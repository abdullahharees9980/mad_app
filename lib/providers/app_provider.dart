import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mad_app/auth_service.dart';   

class AppProvider extends ChangeNotifier {
  List<dynamic> _products = [];
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  Timer? _realtimeTimer;

  List<dynamic> get products => _products;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  AppProvider() {
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
      _fetchProducts(silent: true);
    });
  }

  Future<void> _fetchProducts({bool silent = false}) async {
    if (!silent) _isLoading = true;
    notifyListeners(); 

    try {
      final response = await AuthService().getProductsRaw();
      if (response.statusCode == 200) {
        final products = await compute(jsonDecode, response.body) as List<dynamic>;
        _products = products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {

    } finally {
      if (!silent) _isLoading = false;
      notifyListeners();  
    }
  }

  void addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();  
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
