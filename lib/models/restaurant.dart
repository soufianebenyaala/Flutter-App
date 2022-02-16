class Restaurant {
  final int? id;
  final String nom;
  final String description;
  final List<String>? photos;
  final double longitude;
  final double latitude;
  final int proprietaireId;
  final int villeId;

  Restaurant({
    this.id,
    required this.nom,
    required this.description,
    this.photos,
    required this.longitude,
    required this.latitude,
    required this.proprietaireId,
    required this.villeId,
  });

  static fromDocument(dynamic json, List<String> imgs) {
    return Restaurant(
      id: json["id"],
      description: json["description"] ?? "",
      latitude: double.parse(json["latitude"].toString()),
      longitude: double.parse(json["longitude"].toString()),
      nom: json["nom"] ?? "",
      photos: imgs,
      proprietaireId: json["prop_restau_id"] ?? -1,
      villeId: json["ville_id"] ?? -1,
    );
  }
}
