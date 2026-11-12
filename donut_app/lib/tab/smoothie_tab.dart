import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class SmoothieTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  SmoothieTab({super.key, this.onAddToCart});

  final List smoothiesOnSale = [
    [
      'Naranja Fresca',
      '60',
      Colors.orange,
      'assets/images/smoothie_naranja.png',
      'JugoBar',
    ],
    [
      'Blueberry Bomb',
      '85',
      Colors.blue,
      'assets/images/smoothie_blueberry.png',
      'Starbucks',
    ],
    [
      'Fresa Natural',
      '70',
      Colors.pink,
      'assets/images/smoothie_fresa.png',
      'Oxxo',
    ],
    [
      'Mango Manía',
      '75',
      Colors.amber,
      'assets/images/smoothie_mango.png',
      'JugoBar',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: smoothiesOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.65,
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          donutFlavor: smoothiesOnSale[index][0],
          donutPrice: smoothiesOnSale[index][1],
          donutColor: smoothiesOnSale[index][2],
          donutImagePath: smoothiesOnSale[index][3],
          donutProvider: smoothiesOnSale[index][4],
          onAddToCart: () {
            if (onAddToCart != null) {
              onAddToCart!(
                smoothiesOnSale[index][0],
                smoothiesOnSale[index][1],
                smoothiesOnSale[index][3],
              );
            }
          },
        );
      },
    );
  }
}
