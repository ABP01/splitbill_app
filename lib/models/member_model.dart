// lib/models/member_model.dart
// Modèle représentant un membre d'un groupe de partage

class Member {
  final String id;
  final String name;
  final String? avatarUrl;

  Member({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  Member copyWith({
    String? id,
    String? name,
    String? avatarUrl,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Member && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Member(id: $id, name: $name)';
}
