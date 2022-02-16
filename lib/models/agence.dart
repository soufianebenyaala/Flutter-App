class Agence {
  final int id;
  final String nomAgence;
  final String adresse;
  final String telephone;
  final String email;
  final int villeId;
  final String photos;

  Agence({
    required this.id,
    required this.nomAgence,
    required this.adresse,
    required this.telephone,
    required this.email,
    required this.villeId,
    required this.photos,
  });

  static fromDocument(dynamic json) {
    return Agence(
      id: json["id"],
      nomAgence: json["id"],
      adresse: json["id"],
      telephone: json["id"],
      email: json["id"],
      villeId: json["id"],
      photos: json["id"],
    );
  }
}
