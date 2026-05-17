import 'package:flutter/material.dart';
import 'home_page.dart';
import 'components/news.dart';
import 'components/cart_page.dart';
import 'models/product_model.dart';

class MainPage extends StatefulWidget {
  final String? username;

  const MainPage({super.key, this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<ProductModel> _cartItems = [];

  void _addToCart(ProductModel product) {
    setState(() {
      _cartItems.add(product);
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(username: widget.username, onAddToCart: _addToCart),
      const News(),
      CartPage(items: _cartItems, onRemoveItem: _removeFromCart),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Haberler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
