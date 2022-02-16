class PropiretaireResto {
  final int id;
  final String cin;
  final String telephone;
  final int userId;

  PropiretaireResto({
    required this.id,
    required this.cin,
    required this.telephone,
    required this.userId,
  });

  static fromDocument(dynamic json) {
    return PropiretaireResto(
      id: json["id"],
      cin: json["cin"],
      telephone: json["telephone"],
      userId: json["user_id"],
    );
  }
}
