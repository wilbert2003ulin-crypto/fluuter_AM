import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreNotesScreen extends StatefulWidget {
  const FirestoreNotesScreen({super.key});

  @override
  State<FirestoreNotesScreen> createState() => _FirestoreNotesScreenState();
}

class _FirestoreNotesScreenState extends State<FirestoreNotesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final CollectionReference _notasRef = FirebaseFirestore.instance.collection(
    'notas',
  );

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      _nameController.text = user.displayName!;
    }
  }

  Future<void> _guardarDato() async {
    final nombre = _nameController.text.trim();
    final texto = _textController.text.trim();

    if (nombre.isEmpty || texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa tu nombre y el mensaje.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await _notasRef.add({
        'nombre': nombre,
        'texto': texto,
        'email': user?.email ?? 'Anónimo',
        'fecha': FieldValue.serverTimestamp(),
      });

      _textController.clear();
      if (mounted) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dato guardado en Cloud Firestore'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios y Notas (Firestore)'),
        backgroundColor: Colors.pink[400],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FORMULARIO DE REGISTRO
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nuevo Registro en la Nube',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tu nombre',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        labelText: 'Escribe una nota o reseña',
                        prefixIcon: const Icon(Icons.edit_note),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSaving ? null : _guardarDato,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.cloud_upload),
                      label: Text(
                        _isSaving ? 'Guardando...' : 'Guardar en Firestore',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Registros en Tiempo Real:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // LISTA EN TIEMPO REAL
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _notasRef
                    .orderBy('fecha', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar datos: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('Aún no hay registros. ¡Agrega el primero!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final nombre = data['nombre'] ?? 'Sin nombre';
                      final texto = data['texto'] ?? '';
                      final email = data['email'] ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.pink[100],
                            child: Text(
                              nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: Colors.pink[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(texto),
                              if (email.isNotEmpty)
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
