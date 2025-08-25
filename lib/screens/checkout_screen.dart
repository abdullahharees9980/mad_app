import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final TextEditingController _contactController = TextEditingController();
//Landscape
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 600;

    Widget inputSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Information:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _contactController,
          decoration: InputDecoration(
            labelText: 'Contact Number',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );

    Widget summarySection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Price:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              
            ),
           
          ],
        ),
        
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _addressController.text.isNotEmpty &&
                _contactController.text.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order Placed Successfully')
                ),
              );
              
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill in all fields')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: Text(
            'Place Order',
            style: TextStyle(fontSize: 16),
            
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: delivery inputs
                  Expanded(child: inputSection),
                  SizedBox(width: 20),
                  // Right side: total + button
                  Expanded(child: summarySection),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputSection,
                  SizedBox(height: 20),
                  summarySection,
                ],
              ),
      ),
    );
  }
}
