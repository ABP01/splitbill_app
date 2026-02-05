// lib/models/group_model.dart
// Modèle représentant un groupe de partage de dépenses

import 'member_model.dart';
import 'expense_model.dart';

class Group {
  final String id;
  final String name;
  final String? description;
  final List<Member> members;
  final List<Expense> expenses;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.members,
    required this.expenses,
    required this.createdAt,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<Member>? members,
    List<Expense>? expenses,
    DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      expenses: expenses ?? this.expenses,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Calcule le total des dépenses du groupe
  double getTotalExpenses() {
    double total = 0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // BUG #3: Calcule le solde d'un membre (combien il doit ou on lui doit)
  // La logique de calcul est incorrecte
  double getMemberBalance(Member member) {
    double balance = 0;

    for (var expense in expenses) {
      // Ce que le membre a payé
      if (expense.paidBy == member) {
        balance += expense.amount;
      }

      // Ce que le membre doit (sa part)
      if (expense.splitBetween.contains(member)) {
        balance -= expense.getSharePerPerson(); // BUG: Devrait être -= (soustraction)
      }
    }

    return balance;
  }

  // Calcule les remboursements nécessaires
  List<Map<String, dynamic>> calculateReimbursements() {
    List<Map<String, dynamic>> reimbursements = [];
    
    // Créer une copie des balances
    Map<String, double> balances = {};
    for (var member in members) {
      balances[member.id] = getMemberBalance(member);
    }

    // Trouver qui doit à qui
    List<Member> debtors = members.where((m) => balances[m.id]! < 0).toList();
    List<Member> creditors = members.where((m) => balances[m.id]! > 0).toList();

    for (var debtor in debtors) {
      double amountToRepay = -balances[debtor.id]!;

      for (var creditor in creditors) {
        if (amountToRepay <= 0) break;
        
        double creditorBalance = balances[creditor.id]!;
        if (creditorBalance <= 0) continue;

        double reimbursement = amountToRepay < creditorBalance 
            ? amountToRepay 
            : creditorBalance;

        if (reimbursement > 0) {
          reimbursements.add({
            'from': debtor,
            'to': creditor,
            'amount': reimbursement,
          });

          balances[debtor.id] = balances[debtor.id]! + reimbursement;
          balances[creditor.id] = balances[creditor.id]! - reimbursement;
          amountToRepay -= reimbursement;
        }
      }
    }

    return reimbursements;
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, members: ${members.length}, expenses: ${expenses.length})';
  }
}
