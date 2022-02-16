class Pack {
  final int? id;
  final String titre;
  final String? adrenaline;
  final String description;
  final String? photoCoverture;
  final String dateDebut;
  final String dateFin;

  final int nbPlaceMax;
  final int nbPlaceDispo;
  final int nbPlaceRemise;
  final String urlVideo;

  final int adminAgenceId;
  final int? villeId;

  Pack({
    this.id,
    required this.titre,
    required this.description,
    this.photoCoverture,
    required this.dateDebut,
    required this.dateFin,
    this.adrenaline,
    required this.nbPlaceMax,
    required this.nbPlaceDispo,
    required this.nbPlaceRemise,
    required this.urlVideo,
    required this.adminAgenceId,
    this.villeId,
  });

  static Pack fromDocument(dynamic json) {
    return Pack(
      adminAgenceId: json["admin_agence_id"],
      adrenaline: json["adrenaline"],
      dateDebut: json["date_deb"],
      dateFin: json["date_fin"],
      description: json["description"],
      nbPlaceDispo: json["nb_place_dispo"],
      nbPlaceMax: json["nb_place_max"],
      nbPlaceRemise: json["nb_place_remise"],
      titre: json["titre"],
      urlVideo: json["url_video"],
      villeId: json["ville_id"],
      id: json["id"],
      photoCoverture: json["image_couverture"],
    );
  }
}
