// lib/main.dart
// Point d'entrée de l'application SplitBill

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/group_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const SplitBillApp());
}

class SplitBillApp extends StatelessWidget {
  const SplitBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitBill',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const GroupScreen(),
    );
  }
}
