import 'package:flutter/material.dart';

class DonutTile extends StatelessWidget {
  final String donutFlavor;
  final String donutPrice;
  final dynamic donutColor;
  final String donutImagePath;
  final String donutProvider;
  final VoidCallback? onAddToCart;
  final String fallbackAsset; // Imagen por defecto si no hay internet

  const DonutTile({
    super.key,
    required this.donutFlavor,
    required this.donutPrice,
    this.donutColor,
    required this.donutImagePath,
    required this.donutProvider,
    this.onAddToCart,
    this.fallbackAsset =
        'assets/icons/donut.png', // Asegúrate de que exista en tus assets
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = donutImagePath.startsWith('http');

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: donutColor[100],
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          children: [
            // Etiqueta de precio
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 18.0,
                  ),
                  decoration: BoxDecoration(
                    color: donutColor[200],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    '\$$donutPrice',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: donutColor[800],
                    ),
                  ),
                ),
              ],
            ),
            // Imagen (desde Supabase con respaldo offline si es URL)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: isNetworkImage
                  ? Image.network(
                      donutImagePath,
                      height: 85,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 85,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          fallbackAsset,
                          height: 85,
                          fit: BoxFit.contain,
                        );
                      },
                    )
                  : Image.asset(donutImagePath, height: 85),
            ),
            // Nombre
            Text(
              donutFlavor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 4),
            // Proveedor
            Text(donutProvider, style: TextStyle(color: Colors.grey[700])),

            // Botón Add interactivo
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.favorite_border_outlined, color: Colors.pink[400]),
                  GestureDetector(
                    onTap: onAddToCart,
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
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
