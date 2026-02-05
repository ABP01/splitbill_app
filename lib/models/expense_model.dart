// lib/models/expense_model.dart
// Modèle représentant une dépense dans un groupe

import 'member_model.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final Member paidBy;
  final List<Member> splitBetween;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
    required this.createdAt,
  });

  // BUG #1: La méthode copyWith ne copie pas correctement le champ 'amount'
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    Member? paidBy,
    List<Member>? splitBetween,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount, // BUG: Ignore le paramètre amount passé
      paidBy: paidBy ?? this.paidBy,
      splitBetween: splitBetween ?? this.splitBetween,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Calcule la part de chaque participant
  double getSharePerPerson() {
    if (splitBetween.isEmpty) return 0;
    return amount / splitBetween.length;
  }

  // BUG #2: Vérifie si un membre participe à cette dépense (logique inversée)
  bool isMemberInvolved(Member member) {
    return splitBetween.contains(member) || paidBy == member;
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, paidBy: ${paidBy.name})';
  }
}
