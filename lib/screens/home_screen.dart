import 'package:flutter/material.dart';
import 'package:mad_app/widgets/bottom_navbar.dart'; 
import 'package:mad_app/screens/product_detail_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, String>> _products = [
    {
      'image': 'lib/assets/product1.jpg',
      'name': 'Product 1',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 1',
    },
    {
      'image': 'lib/assets/product2.jpg',
      'name': 'Product 2',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 2',
    },
    {
      'image': 'lib/assets/product3.jpg',
      'name': 'Product 3',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 3',
    },
     {
      'image': 'lib/assets/product1.jpg',
      'name': 'Product 1',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 1',
    },
    {
      'image': 'lib/assets/product2.jpg',
      'name': 'Product 2',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 2',
    },
    {
      'image': 'lib/assets/product3.jpg',
      'name': 'Product 3',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 3',
    },
     {
      'image': 'lib/assets/product1.jpg',
      'name': 'Product 1',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 1',
    },
    {
      'image': 'lib/assets/product2.jpg',
      'name': 'Product 2',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 2',
    },
    {
      'image': 'lib/assets/product3.jpg',
      'name': 'Product 3',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 3',
    },
     {
      'image': 'lib/assets/product1.jpg',
      'name': 'Product 1',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 1',
    },
    {
      'image': 'lib/assets/product2.jpg',
      'name': 'Product 2',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 2',
    },
    {
      'image': 'lib/assets/product3.jpg',
      'name': 'Product 3',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 3',
    },
     {
      'image': 'lib/assets/product1.jpg',
      'name': 'Product 1',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 1',
    },
    {
      'image': 'lib/assets/product2.jpg',
      'name': 'Product 2',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 2',
    },
    {
      'image': 'lib/assets/product3.jpg',
      'name': 'Product 3',
      'price': 'Rs 49.99',
      'description': 'This is a description for product 3',
    },
 
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int columns = screenWidth > 600 ? 3 : 2; // 3 columns in landscape, 2 in portrait

    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Products'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the product detail screen when a product is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          name: _products[index]['name']!,
                          image: _products[index]['image']!,
                          price: _products[index]['price']!,
                          description: _products[index]['description']!,
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
                          child: _products[index]['image'] != null
                              ? Image.asset(
                                  _products[index]['image']!,
                                  height: 180, 
                                  width: double.infinity, 
                                  fit: BoxFit.cover, 
                                )
                              : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _products[index]['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            _products[index]['price']!,
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
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex, 
        onItemTapped: _onItemTapped,   
      ),
    );
  }
}
