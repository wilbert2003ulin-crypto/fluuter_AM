import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class DonutTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  DonutTab({super.key, this.onAddToCart});

  // Reemplaza TU_URL_SUPABASE con la URL de tu proyecto (ej: https://xyzcompany.supabase.co)
  static const String _supabaseStorageUrl =
      'https://abvvllqgpqpbawkaqzlz.supabase.co/storage/v1/object/public/productos';

  final List donutsOnSale = [
    [
      'Chocolate',
      '100',
      Colors.brown,
      '$_supabaseStorageUrl/chocolate_donut.png',
      'Starbucks',
    ],
    [
      'Strawberry',
      '89',
      Colors.pink,
      '$_supabaseStorageUrl/strawberry_donut.png',
      'Krispy Kreme',
    ],
    [
      'Ice Cream',
      '95',
      Colors.blue,
      '$_supabaseStorageUrl/icecream_donut.png',
      'Dunkin Donuts',
    ],
    [
      'Grape',
      '70',
      Colors.purple,
      '$_supabaseStorageUrl/grape_donut.png',
      'Oxxo',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: donutsOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.65,
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          donutFlavor: donutsOnSale[index][0],
          donutPrice: donutsOnSale[index][1],
          donutColor: donutsOnSale[index][2],
          donutImagePath: donutsOnSale[index][3],
          donutProvider: donutsOnSale[index][4],
          fallbackAsset:
              'assets/icons/donut.png', // Imagen por defecto sin internet
          onAddToCart: () {
            if (onAddToCart != null) {
              onAddToCart!(
                donutsOnSale[index][0],
                donutsOnSale[index][1],
                donutsOnSale[index][3],
              );
            }
          },
        );
      },
    );
  }
}
