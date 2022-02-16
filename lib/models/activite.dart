class Activite {
  final int id;
  final String nomActivite;

  Activite({
    required this.id,
    required this.nomActivite,
  });

  static fromDocument(dynamic json) {
    return Activite(
      id: json["id"],
      nomActivite: json["nom"],
    );
  }
}
