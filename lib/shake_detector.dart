import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../screens/about_us_screen.dart';

class ShakeDetectorWidget extends StatefulWidget {
  final Widget child;

  const ShakeDetectorWidget({required this.child, Key? key}) : super(key: key);

  @override
  _ShakeDetectorWidgetState createState() => _ShakeDetectorWidgetState();
}

class _ShakeDetectorWidgetState extends State<ShakeDetectorWidget> {
  static const int shakeCooldownMs = 1000;
  int lastShakeTime = 0;


  double lastX = 0;
  double lastY = 0;
  double lastZ = 0;

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((event) {
      double deltaX = (event.x - lastX).abs();
      double deltaY = (event.y - lastY).abs();
      double deltaZ = (event.z - lastZ).abs();

      lastX = event.x;
      lastY = event.y;
      lastZ = event.z;

   
      const hardShakeThreshold = 20.0; 
      if (deltaX > hardShakeThreshold ||
          deltaY > hardShakeThreshold ||
          deltaZ > hardShakeThreshold) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastShakeTime > shakeCooldownMs) {
          lastShakeTime = now;
          _onShake();
        }
      }
    });
  }

  void _onShake() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AboutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
