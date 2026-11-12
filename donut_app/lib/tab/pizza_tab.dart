import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class PizzaTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  PizzaTab({super.key, this.onAddToCart});

  final List pizzasOnSale = [
    [
      'Carne Carnívora',
      '160',
      Colors.red,
      'assets/images/pizza_carne.png',
      'Domino s',
    ],
    [
      'Mexicana Picante',
      '150',
      Colors.green,
      'assets/images/pizza_mexicana.png',
      'Pizza Hut',
    ],
    [
      'Hawaiana',
      '135',
      Colors.amber,
      'assets/images/pizza_hawaiana.png',
      'Dominos',
    ],
    [
      'Pepperoni Clásica',
      '130',
      Colors.deepOrange,
      'assets/images/pizza_peperoni.png',
      'Little Caesars',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pizzasOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.9,
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          donutFlavor: pizzasOnSale[index][0],
          donutPrice: pizzasOnSale[index][1],
          donutColor: pizzasOnSale[index][2],
          donutImagePath: pizzasOnSale[index][3],
          donutProvider: pizzasOnSale[index][4],
          onAddToCart: () {
            if (onAddToCart != null) {
              onAddToCart!(
                pizzasOnSale[index][0],
                pizzasOnSale[index][1],
                pizzasOnSale[index][3],
              );
            }
          },
        );
      },
    );
  }
}
