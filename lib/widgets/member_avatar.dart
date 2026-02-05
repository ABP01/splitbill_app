// lib/widgets/member_avatar.dart
// Widget d'affichage d'un avatar de membre

import 'package:flutter/material.dart';
import '../models/member_model.dart';

class MemberAvatar extends StatelessWidget {
  final Member member;
  final double size;
  final Color? backgroundColor;

  const MemberAvatar({
    super.key,
    required this.member,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Génère une couleur basée sur le nom du membre
    final color = backgroundColor ?? _generateColor(member.name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Color _generateColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}
