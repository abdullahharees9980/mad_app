import 'package:flutter/material.dart';
import 'package:mad_app/widgets/offline_wrapper.dart'; 

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        backgroundColor: Colors.blue,
      ),
      body: OfflineWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Clothing App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Version: 1.0.0'),
              SizedBox(height: 10),
              Text('Created by: Abdullah Harees'),
              SizedBox(height: 10),
              Text(
                  'This app was developed as part of a Mobile Application Development assignment.'),
            ],
          ),
        ),
      ),
    );
  }
}
