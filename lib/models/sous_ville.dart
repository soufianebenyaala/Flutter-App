class SousVille {
  final int id;
  final String nom;
  final String description;
  final int villeId;
  final String photo;

  SousVille({
    required this.id,
    required this.nom,
    required this.description,
    required this.villeId,
    required this.photo,
  });

  static fromDocument(dynamic json) {
    return SousVille(
      id: json["id"],
      nom: json["id"],
      description: json["id"],
      villeId: json["id"],
      photo: json["id"],
    );
  }
}
