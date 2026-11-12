import 'package:flutter/material.dart';

class PizzaTile extends StatelessWidget {
  final String pizzasFlavor;
  final String pizzasPrice;
  final dynamic pizzasColor;
  final String pizzasImagePath;
  final String pizzasProvider;

  const PizzaTile({
    super.key,
    required this.pizzasFlavor,
    required this.pizzasPrice,
    this.pizzasColor,
    required this.pizzasImagePath,
    required this.pizzasProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: pizzasColor[100],
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          children: [
            //Etiqueta de precio
            Row(
              //Alinear a la derecha
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 18.0,
                  ),
                  decoration: BoxDecoration(
                    color: pizzasColor[200],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    '\$$pizzasPrice',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: pizzasColor[800],
                    ),
                  ),
                ),
              ],
            ),
            //Imagen de la Dona
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Image.asset(pizzasImagePath),
            ),
            //Nombre de la Dona
            Text(
              pizzasFlavor,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            //Espacio entre textos
            const SizedBox(height: 4),
            //Nombredel proveedor
            Text(pizzasProvider, style: TextStyle(color: Colors.grey[1600])),
            //Espacio entre textos
            //Iconos de fav y carrito
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.favorite_border_outlined, color: Colors.pink[400]),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
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
