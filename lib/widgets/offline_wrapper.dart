import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineWrapper extends StatefulWidget {
  final Widget child;

  const OfflineWrapper({super.key, required this.child});

  @override
  State<OfflineWrapper> createState() => _OfflineWrapperState();
}

class _OfflineWrapperState extends State<OfflineWrapper> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((result) => result != ConnectivityResult.none);
      setState(() {
        _isOnline = hasConnection;
      });
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final hasConnection = results.any((result) => result != ConnectivityResult.none);
    setState(() {
      _isOnline = hasConnection;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isOnline)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.85), // full black overlay
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.white, size: 80),
                    SizedBox(height: 20),
                    Text(
                      'No Internet Connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please check your connection.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
