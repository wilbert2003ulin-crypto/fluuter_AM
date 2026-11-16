import 'package:flutter/material.dart';
import 'package:donut_app/utils/donut_tile.dart';

class PancakeTab extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  PancakeTab({super.key, this.onAddToCart});

  static const String _supabaseStorageUrl =
      'https://abvvllqgpqpbawkaqzlz.supabase.co/storage/v1/object/public/productos';

  final List pancakesOnSale = [
    [
      'Miel Exquisita',
      '85',
      Colors.amber,
      '$_supabaseStorageUrl/pancake_miel.png',
      'IHOP',
    ],
    [
      'Mantequilla Extra',
      '75',
      Colors.orange,
      '$_supabaseStorageUrl/pancake_mantequilla.png',
      'Sanborns',
    ],
    [
      'Frutas del Bosque',
      '110',
      Colors.pink,
      '$_supabaseStorageUrl/pancake_frutas.png',
      'IHOP',
    ],
    [
      'Fresa Suprema',
      '95',
      Colors.red,
      '$_supabaseStorageUrl/pancake_fresa.png',
      'Vips',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pancakesOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.9,
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          donutFlavor: pancakesOnSale[index][0],
          donutPrice: pancakesOnSale[index][1],
          donutColor: pancakesOnSale[index][2],
          donutImagePath: pancakesOnSale[index][3],
          donutProvider: pancakesOnSale[index][4],
          fallbackAsset: 'assets/icons/pancakes.png',
          onAddToCart: () {
            if (onAddToCart != null) {
              onAddToCart!(
                pancakesOnSale[index][0],
                pancakesOnSale[index][1],
                pancakesOnSale[index][3],
              );
            }
          },
        );
      },
    );
  }
}
