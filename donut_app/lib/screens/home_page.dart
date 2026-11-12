import 'package:flutter/material.dart';
import 'package:donut_app/screens/cart_screen.dart';
import 'package:donut_app/tab/burger_tab.dart';
import 'package:donut_app/tab/donut_tab.dart';
import 'package:donut_app/tab/pancake_tab.dart';
import 'package:donut_app/tab/pizza_tab.dart';
import 'package:donut_app/tab/smoothie_tab.dart';
import 'package:donut_app/utils/my_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _cartItems = [];

  void addToCart(String flavor, String price, String imagePath) {
    setState(() {
      _cartItems.add({'name': flavor, 'price': price, 'image': imagePath});
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$flavor añadido al carrito'),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.pink[400],
      ),
    );
  }

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += double.parse(item['price'].toString());
    }
    return total;
  }

  final List<Widget> myTabs = [
    const MyTab(iconPath: 'assets/icons/donut.png', iconName: 'Donuts'),
    const MyTab(iconPath: 'assets/icons/burger.png', iconName: 'Burgers'),
    const MyTab(iconPath: 'assets/icons/smoothie.png', iconName: 'Smoothies'),
    const MyTab(iconPath: 'assets/icons/pancakes.png', iconName: 'Pancakes'),
    const MyTab(iconPath: 'assets/icons/pizza.png', iconName: 'Pizzas'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Icon(Icons.menu, color: Colors.grey),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: const [
                  Text('I want to ', style: TextStyle(fontSize: 24)),
                  Text(
                    'Eat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: myTabs,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DonutTab(
                    onAddToCart: (flavor, price, image) =>
                        addToCart(flavor, price, image),
                  ),
                  BurgerTab(
                    onAddToCart: (flavor, price, image) =>
                        addToCart(flavor, price, image),
                  ),
                  SmoothieTab(
                    onAddToCart: (flavor, price, image) =>
                        addToCart(flavor, price, image),
                  ),
                  PancakeTab(
                    onAddToCart: (flavor, price, image) =>
                        addToCart(flavor, price, image),
                  ),
                  PizzaTab(
                    onAddToCart: (flavor, price, image) =>
                        addToCart(flavor, price, image),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_cartItems.length} items | \$$totalPrice',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Delivery Charges Included',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartScreen(cartItems: _cartItems),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400],
                    ),
                    child: const Text(
                      "View Cart",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
