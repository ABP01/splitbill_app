// lib/widgets/expense_card.dart
// Widget d'affichage d'une dépense - À REFACTORER (Partie B)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';

// PARTIE B - REFACTORING : Ce widget est mal structuré et contient du code répétitif
// L'étudiant doit l'améliorer selon les consignes du sujet

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
  });

  Widget _infoRow({
    required String label,
    required String value,
    required Color color,
    IconData? icon,
    String? leadingText,
    String? trailingText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 14, color: color)
                  : Text(
                      leadingText ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 8),
          if (label.isNotEmpty)
            Text(
              '$label ',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec titre et montant
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titre de la dépense
                    Expanded(
                      child: Text(
                        expense.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Montant
                    Text(
                      '${expense.amount.toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Ligne "Payé par"
                _infoRow(
                  label: 'Payé par',
                  value: expense.paidBy.name,
                  color: Colors.green.shade700,
                  leadingText: expense.paidBy.name[0].toUpperCase(),
                ),
                // Ligne "Partagé entre"
                SizedBox(height: 8),
                _infoRow(
                  label: 'Partagé entre',
                  value: '${expense.splitBetween.length} personnes',
                  color: Colors.orange.shade700,
                  icon: Icons.people,
                  trailingText:
                      ' (${expense.getSharePerPerson().toStringAsFixed(2)} €/pers.)',
                ),
                _infoRow(
                  label: '', //
                  value: DateFormat(
                    'dd MMM yyyy',
                    'fr_FR',
                  ).format(expense.createdAt),
                  color: Colors.purple.shade700,
                  icon: Icons.calendar_today,
                ),
                // Bouton de suppression
                if (onDelete != null) ...[
                  SizedBox(height: 12),
                  Divider(height: 1),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete_outline, size: 18),
                        label: Text('Supprimer'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
