import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final Connectivity _connectivity = Connectivity();

  ConnectivityProvider() {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _initConnectivity() async {
    var results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // If any result is not "none", then user is online
    _isOnline = results.any((result) => result != ConnectivityResult.none);
    notifyListeners();
  }
}
