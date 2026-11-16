import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class PizzaTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  PizzaTab({super.key, this.onAddToCart});

  static const String _supabaseStorageUrl =
      'https://abvvllqgpqpbawkaqzlz.supabase.co/storage/v1/object/public/productos';

  final List pizzasOnSale = [
    [
      'Carne Carnívora',
      '160',
      Colors.red,
      '$_supabaseStorageUrl/pizza_carne.png',
      'Domino s',
    ],
    [
      'Mexicana Picante',
      '150',
      Colors.green,
      '$_supabaseStorageUrl/pizza_mexicana.png',
      'Pizza Hut',
    ],
    [
      'Hawaiana',
      '135',
      Colors.amber,
      '$_supabaseStorageUrl/pizza_hawaiana.png',
      'Dominos',
    ],
    [
      'Pepperoni Clásica',
      '130',
      Colors.deepOrange,
      '$_supabaseStorageUrl/pizza_peperoni.png',
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
          fallbackAsset: 'assets/icons/pizza.png',
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
