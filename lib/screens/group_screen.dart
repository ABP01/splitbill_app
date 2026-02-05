// lib/screens/group_screen.dart
// Écran principal affichant les détails d'un groupe

import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/expense_model.dart';
import '../models/member_model.dart';
import '../services/data_service.dart';
import '../widgets/expense_card.dart';
import '../widgets/member_avatar.dart';
import 'add_expense_screen.dart';
import 'balance_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late Group _group;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _group = DataService.generateSampleGroup();
  }

  void _addExpense(Expense expense) {
    setState(() {
      _group = _group.copyWith(
        expenses: [..._group.expenses, expense],
      );
    });
  }

  // BUG #4: La suppression d'une dépense ne fonctionne pas correctement
  void _deleteExpense(String expenseId) {
    setState(() {
      _group = _group.copyWith(
        expenses: _group.expenses.where((e) => e.id != expenseId).toList(),
      );
    });
  }

  void _navigateToAddExpense() async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(members: _group.members),
      ),
    );

    if (result != null) {
      _addExpense(result);
    }
  }

  void _navigateToBalances() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BalanceScreen(group: _group),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(_group.name),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: _navigateToBalances,
            tooltip: 'Voir les soldes',
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec résumé
          _buildHeader(),
          // Onglets
          _buildTabBar(),
          // Contenu selon l'onglet
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildExpensesList()
                : _buildMembersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddExpense,
        icon: Icon(Icons.add),
        label: Text('Dépense'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Total des dépenses',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${_group.getTotalExpenses().toStringAsFixed(2)} €',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.receipt_long,
                value: '${_group.expenses.length}',
                label: 'Dépenses',
              ),
              _buildStatItem(
                icon: Icons.people,
                value: '${_group.members.length}',
                label: 'Membres',
              ),
              _buildStatItem(
                icon: Icons.person,
                value: '${(_group.getTotalExpenses() / _group.members.length).toStringAsFixed(0)} €',
                label: 'Par personne',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              title: 'Dépenses',
              index: 0,
              icon: Icons.receipt,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              title: 'Membres',
              index: 1,
              icon: Icons.people,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    if (_group.expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'Aucune dépense',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ajoutez votre première dépense',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80),
      itemCount: _group.expenses.length,
      itemBuilder: (context, index) {
        final expense = _group.expenses[index];
        return ExpenseCard(
          expense: expense,
          onDelete: () => _deleteExpense(expense.id),
          onTap: () {
            // TODO: Navigation vers le détail
          },
        );
      },
    );
  }

  Widget _buildMembersList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: _group.members.length,
      itemBuilder: (context, index) {
        final member = _group.members[index];
        final balance = _group.getMemberBalance(member);

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              MemberAvatar(member: member, size: 48),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getBalanceDescription(balance),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${balance >= 0 ? '+' : ''}${balance.toStringAsFixed(2)} €',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: balance >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getBalanceDescription(double balance) {
    if (balance > 0) {
      return 'Doit recevoir';
    } else if (balance < 0) {
      return 'Doit rembourser';
    }
    return 'Équilibré';
  }
}
