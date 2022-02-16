class AdminAgence {
  final int id;
  final String carteProfessionnelAgence;
  final String presentation;
  final int userId;

  AdminAgence({
    required this.id,
    required this.carteProfessionnelAgence,
    required this.presentation,
    required this.userId,
  });

  static fromDocument(dynamic json) {
    return AdminAgence(
      id: json["id"],
      carteProfessionnelAgence: json["carte_professionnel_agence"],
      presentation: json["presentation"],
      userId: json["user_id"],
    );
  }
}
