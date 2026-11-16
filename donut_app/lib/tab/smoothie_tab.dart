import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class SmoothieTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  SmoothieTab({super.key, this.onAddToCart});

  static const String _supabaseStorageUrl =
      'https://abvvllqgpqpbawkaqzlz.supabase.co/storage/v1/object/public/productos';

  final List smoothiesOnSale = [
    [
      'Naranja Fresca',
      '60',
      Colors.orange,
      '$_supabaseStorageUrl/smoothie_naranja.png',
      'JugoBar',
    ],
    [
      'Blueberry Bomb',
      '85',
      Colors.blue,
      '$_supabaseStorageUrl/smoothie_blueberry.png',
      'Starbucks',
    ],
    [
      'Fresa Natural',
      '70',
      Colors.pink,
      '$_supabaseStorageUrl/smoothie_fresa.png',
      'Oxxo',
    ],
    [
      'Mango Manía',
      '75',
      Colors.amber,
      '$_supabaseStorageUrl/smoothie_mango.png',
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
          fallbackAsset: 'assets/icons/smoothie.png',
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
