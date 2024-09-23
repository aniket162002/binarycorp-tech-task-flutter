import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product_model.dart';
import 'cart_page.dart';
import '../widgets/animated_button.dart';
import 'login_page.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<ProductModel> cart = [];

  final List<ProductModel> products = [
    ProductModel(
      name: 'Product 1',
      description: 'High-quality electronics product.',
      availability: 'In Stock',
      image: '../assets/images/product1.jpeg',
    ),
    ProductModel(
      name: 'Product 2',
      description: 'Stylish furniture for modern homes.',
      availability: 'In Stock',
      image: '../assets/images/product2.jpeg',
    ),
    ProductModel(
      name: 'Product 3',
      description: 'Stylish furniture for modern homes.',
      availability: 'In Stock',
      image: '../assets/images/product1.jpeg',
    ),
    ProductModel(
      name: 'Product 4',
      description: 'Stylish furniture for modern homes.',
      availability: 'In Stock',
      image: '../assets/images/product2.jpeg',
    ),
    ProductModel(
      name: 'Product 5',
      description: 'Stylish furniture for modern homes.',
      availability: 'In Stock',
      image: '../assets/images/product1.jpeg',
    ),
    // More products...
  ];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartString = prefs.getString('cart');
    if (cartString != null) {
      setState(() {
        List<dynamic> cartList = json.decode(cartString);
        cart = cartList.map((item) => ProductModel.fromMap(item)).toList();
      });
    }
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> cartList =
        cart.map((product) => product.toMap()).toList();
    await prefs.setString('cart', json.encode(cartList));
  }

  void _addToCart(ProductModel product) {
    setState(() {
      cart.add(product);
    });
    _saveCart();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${product.name} added to cart'),
    ));
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void _showProductDetails(ProductModel product) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A75A8)),
              ),
              SizedBox(height: 10),
              Text(product.description),
              SizedBox(height: 10),
              Text('Availability: ${product.availability}'),
              SizedBox(height: 20),
              AnimatedButton(
                label: 'Add to Cart',
                onPressed: () {
                  _addToCart(product);
                  Navigator.pop(context);
                },
                color: Colors.greenAccent,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CartPage(cart: cart)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        _showProductDetails(product);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16.0),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent, width: 2),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                product.image,
                height: 80,
                width: 80,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A75A8),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(product.description),
                    SizedBox(height: 5),
                    Text(
                      product.availability,
                      style: TextStyle(
                        color: product.availability == 'In Stock'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFF0A75A8)),
            ],
          ),
        ),
      ),
    );
  }
}
