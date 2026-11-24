import 'package:flutter/material.dart';

class ClientContract {
  final String name;
  final String town;
  final String colony;
  final String routeName;
  final String collectionDays;
  final String phone;
  final String productName;
  final double creditBalance;
  final double installmentAmount;
  final String statusLabel; // 'Vence hoy', 'Atrasado 3 días', 'Al corriente'
  final String statusType; // 'due_today', 'overdue', 'up_to_date'
  final Color avatarBg;
  final Color avatarText;

  ClientContract({
    required this.name,
    required this.town,
    required this.colony,
    required this.routeName,
    required this.collectionDays,
    required this.phone,
    required this.productName,
    required this.creditBalance,
    required this.installmentAmount,
    required this.statusLabel,
    required this.statusType,
    required this.avatarBg,
    required this.avatarText,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'CL';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class MockClientsStore {
  // Lista reactiva para que la pantalla Clientes se actualice sola al guardar un contrato
  static final ValueNotifier<List<ClientContract>> clientsNotifier =
      ValueNotifier<List<ClientContract>>([
        ClientContract(
          name: 'María López',
          town: 'Umán',
          colony: 'San Miguel',
          routeName: 'Ruta 1',
          collectionDays: 'Lunes y Sábado',
          phone: '9991234567',
          productName: 'Crema Alivio Muscular',
          creditBalance: 680,
          installmentAmount: 85,
          statusLabel: 'Vence hoy',
          statusType: 'due_today',
          avatarBg: const Color(0xFFE6F4EE),
          avatarText: const Color(0xFF15803D),
        ),
        ClientContract(
          name: 'Don José Martínez',
          town: 'Kanasín',
          colony: 'El Encinal',
          routeName: 'Ruta 2',
          collectionDays: 'Martes y Viernes',
          phone: '9992345678',
          productName: 'Kit Bienestar Integral',
          creditBalance: 1240,
          installmentAmount: 155,
          statusLabel: 'Atrasado 3 días',
          statusType: 'overdue',
          avatarBg: const Color(0xFFF3ECE4),
          avatarText: const Color(0xFF78350F),
        ),
        ClientContract(
          name: 'Ana Hernández',
          town: 'Caucel',
          colony: 'La Esperanza',
          routeName: 'Ruta 3',
          collectionDays: 'Miércoles y Sábado',
          phone: '9993456789',
          productName: 'Gel Térmico Relajante',
          creditBalance: 420,
          installmentAmount: 70,
          statusLabel: 'Al corriente',
          statusType: 'up_to_date',
          avatarBg: const Color(0xFFE8ECF4),
          avatarText: const Color(0xFF1E3A8A),
        ),
        ClientContract(
          name: 'Rosa García',
          town: 'Umán',
          colony: 'San Pedro',
          routeName: 'Ruta 1',
          collectionDays: 'Lunes y Sábado',
          phone: '9994567890',
          productName: 'Crema Alivio Muscular',
          creditBalance: 860,
          installmentAmount: 108,
          statusLabel: 'Vence hoy',
          statusType: 'due_today',
          avatarBg: const Color(0xFFF5E6E8),
          avatarText: const Color(0xFF9F1239),
        ),
      ]);

  static void addClient(ClientContract client) {
    clientsNotifier.value = [client, ...clientsNotifier.value];
  }
}
