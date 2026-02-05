// lib/screens/balance_screen.dart
// Écran affichant les soldes et remboursements

import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/member_model.dart';
import '../widgets/member_avatar.dart';

class BalanceScreen extends StatelessWidget {
  final Group group;

  const BalanceScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    final reimbursements = group.calculateReimbursements();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Soldes'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Section des soldes individuels
          _buildSectionTitle('Soldes individuels'),
          _buildBalancesCard(),

          SizedBox(height: 24),

          // Section des remboursements
          _buildSectionTitle('Remboursements suggérés'),
          if (reimbursements.isEmpty)
            _buildEmptyReimbursements()
          else
            _buildReimbursementsList(reimbursements),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildBalancesCard() {
    return Container(
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
      child: Column(
        children: group.members.map((member) {
          final balance = group.getMemberBalance(member);
          final isPositive = balance >= 0;

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: member != group.members.last ? 1 : 0,
                ),
              ),
            ),
            child: Row(
              children: [
                MemberAvatar(member: member, size: 44),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        isPositive ? 'Doit recevoir' : 'Doit payer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${balance.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyReimbursements() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Colors.green.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'Tout est équilibré !',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Aucun remboursement nécessaire',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReimbursementsList(List<Map<String, dynamic>> reimbursements) {
    return Container(
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
      child: Column(
        children: reimbursements.asMap().entries.map((entry) {
          final index = entry.key;
          final reimbursement = entry.value;
          final from = reimbursement['from'] as Member;
          final to = reimbursement['to'] as Member;
          final amount = reimbursement['amount'] as double;

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: index != reimbursements.length - 1 ? 1 : 0,
                ),
              ),
            ),
            child: Row(
              children: [
                MemberAvatar(member: from, size: 40),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        from.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'doit payer à ${to.name}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${amount.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
