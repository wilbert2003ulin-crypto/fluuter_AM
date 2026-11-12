import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Función para aumentar la cantidad de un producto en el carrito
  void _incrementItem(int index) {
    setState(() {
      // Como guardamos objetos individuales, duplicamos el item para sumarlo al total y cantidad
      final item = widget.cartItems[index];
      widget.cartItems.add({
        'name': item['name'],
        'price': item['price'],
        'image': item['image'],
      });
    });
  }

  // Función para disminuir/eliminar un producto del carrito
  void _decrementItem(String itemName) {
    setState(() {
      // Buscamos y removemos una ocurrencia de ese producto
      final index = widget.cartItems.indexWhere(
        (item) => item['name'] == itemName,
      );
      if (index != -1) {
        widget.cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Agrupamos los elementos únicos para mostrarlos en la lista con su respectiva cantidad
    final Map<String, Map<String, dynamic>> groupedItems = {};
    for (var item in widget.cartItems) {
      final name = item['name'];
      if (groupedItems.containsKey(name)) {
        groupedItems[name]!['quantity'] += 1;
      } else {
        groupedItems[name] = {
          'name': name,
          'price': item['price'],
          'image': item['image'],
          'quantity': 1,
        };
      }
    }
    final uniqueItemsList = groupedItems.values.toList();

    // Calcular el precio total general sumando todos los elementos de la lista original
    double total = widget.cartItems.fold(
      0,
      (sum, item) => sum + double.parse(item['price'].toString()),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: uniqueItemsList.isEmpty
                ? const Center(
                    child: Text(
                      'Tu carrito está vacío 🛒',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: uniqueItemsList.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final item = uniqueItemsList[index];
                      // Encontramos el índice real en la lista general para modificarlo
                      final originalIndex = widget.cartItems.indexWhere(
                        (element) => element['name'] == item['name'],
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Imagen del producto
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset(item['image']),
                            ),
                            const SizedBox(width: 16),
                            // Descripción y precio unitario
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item['price']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botones interactivos de Cantidad (+ y -)
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _incrementItem(originalIndex),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.pink[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    '${item['quantity']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _decrementItem(item['name']),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Sección inferior con Total y Botón de Order Now
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      '\$$total',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC21235),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: widget.cartItems.isEmpty
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('¡Pedido Exitoso!'),
                                content: const Text(
                                  'Tu orden ha sido procesada con éxito.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          },
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
