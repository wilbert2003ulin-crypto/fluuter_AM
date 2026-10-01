import 'package:donut_app/utils/my_tab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> myTabs = [
    //Donuts tab
    const MyTab(iconPath: 'assets/icons/donut.png', iconName: 'Donuts'),
    //Burgers tab
    const MyTab(iconPath: 'assets/icons/burger.png', iconName: 'Burgers'),
    //Smoothies tab
    const MyTab(iconPath: 'assets/icons/smoothie.png', iconName: 'Smoothies'),
    //Pancakes tab
    const MyTab(iconPath: 'assets/icons/pancakes.png', iconName: 'Pancakes'),
    //Pizzas tab
    const MyTab(iconPath: 'assets/icons/pizza.png', iconName: 'Pizzas'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //para el icono de la izquierda
          leading: Icon(Icons.menu, color: Colors.grey),
          //icono de la derecha
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ],
        ),
        body: Column(
          //1. Texto principal
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: [
                  Text('I want to', style: TextStyle(fontSize: 24)),
                  Text(
                    'Eat',
                    style: TextStyle(
                      //tamaño de letra
                      fontSize: 24,
                      //Negritas
                      fontWeight: FontWeight.bold,
                      //subrrayado
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            //2. Pestañas (TabBar)
            TabBar(tabs: myTabs),

            //3. Contenido de pestañas (TabBarView)

            //4. Carrito (Cart)
          ],
        ),
      ),
    );
  }
}
