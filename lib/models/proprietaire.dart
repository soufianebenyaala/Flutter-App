import 'package:etnafes/models/proprietaire_resto.dart';

class Proprietaire {
  final int id;
  final String cin;
  final String codePostal;
  final DateTime? createdAt;
  final int userId;

  Proprietaire({
    required this.id,
    required this.cin,
    required this.codePostal,
    required this.createdAt,
    required this.userId,
  });

  static fromDocument(dynamic json) {
    return Proprietaire(
      id: json["id"],
      cin: json["cin"],
      codePostal: json["code_postal"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      userId: json["user_id"],
    );
  }
}
