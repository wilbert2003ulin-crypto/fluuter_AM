import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class BurgerTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  BurgerTab({super.key, this.onAddToCart});

  final List burgersOnSale = [
    [
      'Pollo Crispy',
      '120',
      Colors.orange,
      'assets/images/burger_pollo.png',
      'McDonalds',
    ],
    [
      'Doble Tocino',
      '145',
      Colors.brown,
      'assets/images/burger_tocino.png',
      'Burger King',
    ],
    [
      'Burger Jr',
      '65',
      Colors.yellow,
      'assets/images/burger_jr.png',
      'Carl s Jr',
    ],
    [
      'Triple Carne',
      '180',
      Colors.red,
      'assets/images/burger_triple.png',
      'Wendy s',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: burgersOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.65,
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          donutFlavor: burgersOnSale[index][0],
          donutPrice: burgersOnSale[index][1],
          donutColor: burgersOnSale[index][2],
          donutImagePath: burgersOnSale[index][3],
          donutProvider: burgersOnSale[index][4],
          onAddToCart: () {
            if (onAddToCart != null) {
              onAddToCart!(
                burgersOnSale[index][0],
                burgersOnSale[index][1],
                burgersOnSale[index][3],
              );
            }
          },
        );
      },
    );
  }
}
