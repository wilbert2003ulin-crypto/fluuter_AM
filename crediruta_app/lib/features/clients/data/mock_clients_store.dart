import 'package:flutter/material.dart';

class ClientContract {
  final String name;
  final String town;
  final String colony;
  final String reference;
  final String routeName;
  final String collectionDays;
  final String phone;
  final String productName;
  final int quantity;
  final double totalSale;
  final double downPayment;
  final double creditBalance;
  final int installmentsCount;
  final double installmentAmount;
  final bool isWeekly;
  final DateTime createdAt;
  final DateTime nextPaymentDate;
  final Color avatarBg;
  final Color avatarText;

  ClientContract({
    required this.name,
    required this.town,
    required this.colony,
    required this.reference,
    required this.routeName,
    required this.collectionDays,
    required this.phone,
    required this.productName,
    required this.quantity,
    required this.totalSale,
    required this.downPayment,
    required this.creditBalance,
    required this.installmentsCount,
    required this.installmentAmount,
    required this.isWeekly,
    required this.createdAt,
    required this.nextPaymentDate,
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

  /// Calcula automáticamente el estado comparando la fecha de cobro con hoy
  String get statusType {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      nextPaymentDate.year,
      nextPaymentDate.month,
      nextPaymentDate.day,
    );

    if (due.isBefore(today)) return 'overdue';
    if (due.isAtSameMomentAs(today)) return 'due_today';
    return 'up_to_date';
  }

  String get statusLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      nextPaymentDate.year,
      nextPaymentDate.month,
      nextPaymentDate.day,
    );

    final diffDays = today.difference(due).inDays;
    if (diffDays > 0) {
      return diffDays == 1 ? 'Atrasado 1 día' : 'Atrasado $diffDays días';
    }
    if (diffDays == 0) {
      return 'Vence hoy';
    }
    final remainingDays = due.difference(today).inDays;
    return 'Al corriente · en $remainingDays d';
  }
}

class MockClientsStore {
  // Inicia vacío: solo se llena con las ventas reales registradas en el formulario
  static final ValueNotifier<List<ClientContract>> clientsNotifier =
      ValueNotifier<List<ClientContract>>([]);

  static void addClient(ClientContract client) {
    clientsNotifier.value = [client, ...clientsNotifier.value];
  }
}
