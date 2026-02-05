// lib/screens/add_expense_screen.dart
// Écran d'ajout d'une nouvelle dépense - PARTIE C À COMPLÉTER

import 'package:flutter/material.dart';
import '../models/member_model.dart';
import '../models/expense_model.dart';
import '../services/data_service.dart';
import '../widgets/member_avatar.dart';

class AddExpenseScreen extends StatefulWidget {
  final List<Member> members;

  const AddExpenseScreen({
    super.key,
    required this.members,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Member? _selectedPayer;
  List<Member> _selectedParticipants = [];

  @override
  void initState() {
    super.initState();
    _selectedParticipants = List.from(widget.members);
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPayer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez sélectionner qui a payé'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedParticipants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sélectionnez au moins un participant'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final expense = Expense(
        id: DataService.generateId(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        paidBy: _selectedPayer!,
        splitBetween: _selectedParticipants,
        createdAt: DateTime.now(),
      );

      Navigator.pop(context, expense);
    }
  }

  // PARTIE C - TODO: Implémenter la méthode _toggleParticipant
  // Cette méthode doit ajouter ou retirer un membre de la liste _selectedParticipants
  // Si le membre est déjà dans la liste, le retirer
  // Sinon, l'ajouter à la liste
  // Ne pas oublier d'appeler setState pour mettre à jour l'interface
  void _toggleParticipant(Member member) {
    // À COMPLÉTER PAR L'ÉTUDIANT
    setState(() {
      if (_selectedParticipants.contains(member)) {
        _selectedParticipants.remove(member);
      } else {
        _selectedParticipants.add(member);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Nouvelle dépense'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Section: Informations de base
            _buildSectionTitle('Informations'),
            _buildCard(
              child: Column(
                children: [
                  // Champ titre
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Ex: Restaurant, Courses...',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Champ montant
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Montant',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.euro),
                      suffixText: '€',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un montant';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Montant invalide';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Section: Payeur
            _buildSectionTitle('Payé par'),
            _buildCard(
              child: Column(
                children: widget.members.map((member) {
                  final isSelected = _selectedPayer == member;
                  return ListTile(
                    leading: MemberAvatar(member: member, size: 40),
                    title: Text(member.name),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.radio_button_unchecked, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _selectedPayer = member;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24),

            // Section: Participants
            _buildSectionTitle('Partagé entre'),
            _buildCard(
              child: Column(
                children: [
                  // Boutons de sélection rapide
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedParticipants = List.from(widget.members);
                            });
                          },
                          child: Text('Tous'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedParticipants = [];
                            });
                          },
                          child: Text('Aucun'),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // Liste des membres
                  ...widget.members.map((member) {
                    final isSelected = _selectedParticipants.contains(member);
                    return CheckboxListTile(
                      secondary: MemberAvatar(member: member, size: 36),
                      title: Text(member.name),
                      value: isSelected,
                      onChanged: (value) {
                        _toggleParticipant(member);
                      },
                      activeColor: Colors.blue.shade600,
                    );
                  }).toList(),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Aperçu du partage
            if (_selectedParticipants.isNotEmpty && _amountController.text.isNotEmpty) ...[
              _buildSectionTitle('Aperçu'),
              _buildPreviewCard(),
            ],

            SizedBox(height: 32),

            // Bouton de validation
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Ajouter la dépense',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  // PARTIE C - TODO: Implémenter la méthode _buildPreviewCard
  // Cette méthode doit afficher un aperçu du partage avec:
  // - Le montant total
  // - Le nombre de participants
  // - Le montant par personne (montant / nombre de participants)
  // Utiliser _amountController.text pour récupérer le montant
  // Utiliser _selectedParticipants.length pour le nombre de participants
  Widget _buildPreviewCard() {
    // À COMPLÉTER PAR L'ÉTUDIANT
    // Indice: Créer un Container avec une Card affichant les informations
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final int count = _selectedParticipants.length;
    final double share = count > 0 ? amount / count : 0.0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Montant total', style: TextStyle(color: Colors.blue.shade700)),
              Text('${amount.toStringAsFixed(2)} €', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Participants', style: TextStyle(color: Colors.blue.shade700)),
              Text('$count', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(color: Colors.blue.shade200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Part par personne', 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
              Text('${share.toStringAsFixed(2)} €', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
            ],
          ),
        ],
      ),
    );
  }
}