import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'mock_clients_store.dart';

class ContractsFirestoreService {
  static final _contractsRef = FirebaseFirestore.instance.collection(
    'contracts',
  );

  /// Guarda un contrato nuevo en Firestore
  static Future<void> createContract(ClientContract contract) async {
    await _contractsRef.add({
      'name': contract.name,
      'town': contract.town,
      'colony': contract.colony,
      'reference': contract.reference,
      'routeName': contract.routeName,
      'collectionDays': contract.collectionDays,
      'phone': contract.phone,
      'productName': contract.productName,
      'quantity': contract.quantity,
      'totalSale': contract.totalSale,
      'downPayment': contract.downPayment,
      'creditBalance': contract.creditBalance,
      'installmentsCount': contract.installmentsCount,
      'installmentAmount': contract.installmentAmount,
      'isWeekly': contract.isWeekly,
      'createdAt': Timestamp.fromDate(contract.createdAt),
      'nextPaymentDate': Timestamp.fromDate(contract.nextPaymentDate),
    });
  }

  /// Escucha los contratos en tiempo real desde Firestore
  static Stream<List<ClientContract>> watchContracts() {
    return _contractsRef.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          final createdTs = data['createdAt'] as Timestamp?;
          final nextPaymentTs = data['nextPaymentDate'] as Timestamp?;

          return ClientContract(
            name: (data['name'] ?? '') as String,
            town: (data['town'] ?? '') as String,
            colony: (data['colony'] ?? '') as String,
            reference: (data['reference'] ?? '') as String,
            routeName: (data['routeName'] ?? '') as String,
            collectionDays: (data['collectionDays'] ?? '') as String,
            phone: (data['phone'] ?? '') as String,
            productName: (data['productName'] ?? '') as String,
            quantity: (data['quantity'] ?? 1) as int,
            totalSale: (data['totalSale'] ?? 0).toDouble(),
            downPayment: (data['downPayment'] ?? 0).toDouble(),
            creditBalance: (data['creditBalance'] ?? 0).toDouble(),
            installmentsCount: (data['installmentsCount'] ?? 1) as int,
            installmentAmount: (data['installmentAmount'] ?? 0).toDouble(),
            isWeekly: (data['isWeekly'] ?? true) as bool,
            createdAt: createdTs?.toDate() ?? DateTime.now(),
            nextPaymentDate: nextPaymentTs?.toDate() ?? DateTime.now(),
            avatarBg: const Color(0xFFE6F4EE),
            avatarText: const Color(0xFF15803D),
          );
        }).toList();
      },
    );
  }
}
