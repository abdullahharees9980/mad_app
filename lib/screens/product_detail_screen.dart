import 'package:flutter/material.dart';
import 'package:mad_app/providers/app_provider.dart';
import 'package:mad_app/widgets/offline_wrapper.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String description;

  ProductDetailScreen({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() => setState(() => _quantity++);
  void _decrementQuantity() => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1);

  void _addToCart() {
    Provider.of<AppProvider>(context, listen: false).addToCart({
      'name': widget.name,
      'image': widget.image,
      'price': widget.price,
      'quantity': _quantity,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 600;

    Widget imageSection = Image.network(
      widget.image,
      height: isWide ? null : 300,
      width: isWide ? null : double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 100),
    );

    Widget detailsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isWide ? 0 : 20),
        Text(widget.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(widget.price, style: TextStyle(fontSize: 20, color: Colors.red)),
        SizedBox(height: 20),
        Text(widget.description, style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove), onPressed: _decrementQuantity),
            Text('$_quantity', style: TextStyle(fontSize: 20)),
            IconButton(icon: Icon(Icons.add), onPressed: _incrementQuantity),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text('Add to Cart', style: TextStyle(fontSize: 18)),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.name), backgroundColor: Colors.blue),
      body: OfflineWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: imageSection),
                    SizedBox(width: 20),
                    Expanded(child: SingleChildScrollView(child: detailsSection)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageSection,
                    detailsSection,
                  ],
                ),
        ),
      ),
    );
  }
}
