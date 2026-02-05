// lib/services/data_service.dart
// Service de gestion des données (simulation)

import 'package:uuid/uuid.dart';
import '../models/member_model.dart';
import '../models/expense_model.dart';
import '../models/group_model.dart';

class DataService {
  static final _uuid = Uuid();

  // Génère des données de démonstration
  static Group generateSampleGroup() {
    // Créer les membres
    final alice = Member(id: _uuid.v4(), name: 'Alice');
    final bob = Member(id: _uuid.v4(), name: 'Bob');
    final charlie = Member(id: _uuid.v4(), name: 'Charlie');
    final diana = Member(id: _uuid.v4(), name: 'Diana');

    final members = [alice, bob, charlie, diana];

    // Créer les dépenses
    final expenses = [
      Expense(
        id: _uuid.v4(),
        title: 'Restaurant Le Gourmet',
        amount: 120.0,
        paidBy: alice,
        splitBetween: [alice, bob, charlie, diana],
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      Expense(
        id: _uuid.v4(),
        title: 'Courses supermarché',
        amount: 85.50,
        paidBy: bob,
        splitBetween: [alice, bob, charlie],
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      Expense(
        id: _uuid.v4(),
        title: 'Essence trajet',
        amount: 45.0,
        paidBy: charlie,
        splitBetween: [alice, bob, charlie, diana],
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      Expense(
        id: _uuid.v4(),
        title: 'Billets cinéma',
        amount: 32.0,
        paidBy: alice,
        splitBetween: [alice, diana],
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    return Group(
      id: _uuid.v4(),
      name: 'Week-end à Paris',
      description: 'Dépenses du voyage entre amis',
      members: members,
      expenses: expenses,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
    );
  }

  // Génère un nouvel ID unique
  static String generateId() {
    return _uuid.v4();
  }
}
