class Ville {
  final int id;
  final String nom;
  final String description;
  final int payId;
  final String photo;

  static List<Ville> exampleVille = [
    Ville(
        id: 1,
        nom: "Ville 1",
        description: "Ville 1",
        payId: 1,
        photo: "photo 1"),
    Ville(
        id: 2,
        nom: "Ville 2",
        description: "Ville 2",
        payId: 2,
        photo: "photo 2"),
    Ville(
        id: 3,
        nom: "Ville 3",
        description: "Ville 3",
        payId: 3,
        photo: "photo 3"),
  ];

  Ville({
    required this.id,
    required this.nom,
    required this.description,
    required this.payId,
    required this.photo,
  });

  static fromDocument(dynamic json) {
    return Ville(
      description: json["description"] ?? "description",
      id: json["id"],
      nom: json["nom"],
      payId: json["pays_id"],
      photo: json["image"],
    );
  }
}
