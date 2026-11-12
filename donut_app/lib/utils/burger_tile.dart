import 'package:flutter/material.dart';

class BurgerTile extends StatelessWidget {
  final String burgerFlavor;
  final String burgerPrice;
  final dynamic burgerColor;
  final String burgerImagePath;
  final String burgerProvider;

  const BurgerTile({
    super.key,
    required this.burgerFlavor,
    required this.burgerPrice,
    this.burgerColor,
    required this.burgerImagePath,
    required this.burgerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: burgerColor[100],
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
                    color: burgerColor[200],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    '\$$burgerPrice',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: burgerColor[800],
                    ),
                  ),
                ),
              ],
            ),
            //Imagen de la Dona
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Image.asset(burgerImagePath),
            ),
            //Nombre de la Dona
            Text(
              burgerFlavor,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            //Espacio entre textos
            const SizedBox(height: 4),
            //Nombredel proveedor
            Text(burgerProvider, style: TextStyle(color: Colors.grey[1600])),
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
