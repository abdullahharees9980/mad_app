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
      'name': 'POLO IN NAVY',
      'price': 'Rs 600.99',
      'description': 'MADE IN L.A. TIPPED MONTAUK -Slub-Spun Jersey -100% garment dyed cotton. -Buttonless placket. -Made in USA -Machine wash. -Style Number KN6277411',
    },
    {
      'image': 'lib/assets/product2.jpg',
      'name': 'POLO WHITE',
      'price': 'Rs 900.99',
      'description': 'A white polo shirt is a classic, versatile piece of clothing made from soft, breathable fabric. It features a collared neckline with a few buttons at the top, offering a smart-casual look. The simple design makes it suitable for various occasions, from casual outings to semi-formal settings, and it pairs easily with jeans, chinos, or shorts.',
    },
    {
      'image': 'lib/assets/product3.jpg',
      'name': 'POLO BLUE',
      'price': 'Rs 1500.99',
      'description': 'A blue polo shirt is a stylish and comfortable garment made from soft, breathable fabric, perfect for both casual and semi-formal wear. It features a classic collar and a buttoned neckline, offering a clean and polished look. The blue color adds a refreshing touch, making it easy to pair with a variety of bottoms like jeans, chinos, or shorts, adding a pop of color to any outfit.',
    },
     {
      'image': 'lib/assets/product4.jpg',
      'name': "DENIM SHIRT",
      'price': 'Rs 600.99',
      'description': 'DENIM SHIRT 100% Cotton Japanese fabric Fits similar to our other overshirts; relaxed enough to layer Genuine melamine buttons Contrast stitching reminiscent of vintage denim Machine',
    },
    {
      'image': 'lib/assets/product5.jpg',
      'name': 'CLASSIC SNEAKER',
      'price': 'Rs 500.99',
      'description': 'A checkboard sneaker is a trendy and eye-catching footwear option, featuring a distinctive pattern of alternating squares in bold, contrasting colors. Known for its playful design, the checkboard pattern adds a touch of personality and style to any casual outfit. These sneakers are typically made from comfortable materials like canvas or fabric, making them perfect for everyday wear. They pair well with jeans, shorts, or skirts, offering a fun and versatile look for all ages.',
    },
    {
      'image': 'lib/assets/product6.jpg',
      'name': 'BLUE SNEAKER',
      'price': 'Rs 700.99',
      'description': 'Original style number Vintage-inspired canvas uppers Ortholite® sockliners Higher glossed foxing tape Cotton laces',
    },
     {
      'image': 'lib/assets/product7.jpg',
      'name': 'TIMEX EXPEDITION',
      'price': 'Rs 6500.99',
      'description': 'Product: TW2V00700JR Case Width: 38 mm Case Material: Stainless Steel Band Color: Brown Buckle/Clasp: Buckle Case Color: Stainless Steel Case Finish: Brushed/Beadblast Case Shape: Round',
    },
    {
      'image': 'lib/assets/product8.jpg',
      'name': 'TIMEX MARLIN LEATHER',
      'price': 'Rs 7000.99',
      'description': 'TIMEX MARLIN LEATHER STRAP Case Material: Stainless Steel Band Color: Blue Buckle/Clasp: Buckle Case Color: Stainless Steel Case Finish: Brushed/Polished Case Shape: Round Case Size: Full Size Crystal/Lens: Acrylic Dial Color: Blue',
    },
    {
      'image': 'lib/assets/product9.jpg',
      'name': 'BLUE STRECH DENIM',
      'price': 'Rs 700.99',
      'description': ' BLUE STRECH DENIM 85.5% cotton, 13.5% polyester, 1% Elastane 12.5oz denim Slim fit Leg opening circumference: 14"(based on size 32w) Our most popular wash, a lightly faded vintage blue jean Room at the top but tailored through the leg Zipper fly',
    },
     {
      'image': 'lib/assets/product10.jpg',
      'name': 'LIGHT BLUE DENIM',
      'price': 'Rs 980.99',
      'description': 'LIGHT BLUE DENIM Room at the top but tailored through the leg Zipper fly Classic five pocket construction Antique copper rivets Chain stitching on the coin pocket Machine Wash',
    }
    
 
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
