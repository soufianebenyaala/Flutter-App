class Hebergement {
  final int? id;
  final String nom;
  final int villeId;
  final int nbrVoyageur;
  final int nbrPlacesDisp;
  final int nbrChambresDisp;
  final int nbrChambresIndiv;
  final int nbrChambresDeux;
  final int nbrChambresTrois;
  final double prixAdulte;
  final double prixEnfantMoin4;
  final double prixEnfantPlus4;
  final String categorie;
  final String adresse;
  final String options;
  final String disponibilite;
  final double longitude;
  final double latitude;
  final List<String>? photos;
  final String? photoCoverture;
  final String description;
  final String dateDebut;
  final String dateFin;
  final int proprietaireId;

  Hebergement({
    this.id,
    required this.nom,
    required this.villeId,
    required this.nbrVoyageur,
    required this.nbrPlacesDisp,
    required this.nbrChambresDisp,
    required this.nbrChambresIndiv,
    required this.nbrChambresDeux,
    required this.nbrChambresTrois,
    required this.prixAdulte,
    required this.prixEnfantMoin4,
    required this.prixEnfantPlus4,
    required this.categorie,
    required this.options,
    required this.disponibilite,
    required this.adresse,
    required this.longitude,
    required this.latitude,
    this.photos,
    this.photoCoverture,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.proprietaireId,
  });

  static List<Hebergement> exampleHebergements = [
    Hebergement(
      id: 1,
      nom: "Semarang, Indonesia",
      villeId: 1,
      nbrVoyageur: 20,
      nbrPlacesDisp: 50,
      nbrChambresDisp: 60,
      nbrChambresIndiv: 30,
      nbrChambresDeux: 20,
      nbrChambresTrois: 10,
      prixAdulte: 30,
      prixEnfantMoin4: 10,
      prixEnfantPlus4: 20,
      categorie: "Categorie",
      disponibilite: "123",
      options: "Wifi, ...",
      adresse: "test",
      longitude: 7.0051,
      latitude: 110.4381,
      photos: [
        "https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80",
        "https://images.unsplash.com/photo-1577791465485-b80039b4d69a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80",
        "https://images.unsplash.com/photo-1577404699057-04440b45986f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=752&q=80",
        "https://images.unsplash.com/photo-1549973890-38d08b229439?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=642&q=80",
        "https://images.unsplash.com/photo-1622263096760-5c79f72884af?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80"
      ],
      photoCoverture:
          "https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80",
      description:
          "Semarang City is the capital city of Central Java Province, Indonesia as well as the fifth largest metropolitan city in Indonesia",
      dateDebut: "2018-10-10",
      dateFin: "2018-10-10",
      proprietaireId: 1,
    ),
  ];

  static List<Hebergement> exampleNewHebergements = [
    Hebergement(
      id: 1,
      nom: "New Hotel",
      villeId: 1,
      nbrVoyageur: 20,
      nbrPlacesDisp: 50,
      nbrChambresDisp: 60,
      nbrChambresIndiv: 30,
      nbrChambresDeux: 20,
      nbrChambresTrois: 10,
      prixAdulte: 30,
      prixEnfantMoin4: 10,
      prixEnfantPlus4: 20,
      adresse: "test",
      categorie: "Categorie",
      disponibilite: "123",
      options: "Wifi, ...",
      longitude: 7.0051,
      latitude: 110.4381,
      photos: [
        "https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80",
        "https://images.unsplash.com/photo-1577791465485-b80039b4d69a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80",
        "https://images.unsplash.com/photo-1577404699057-04440b45986f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=752&q=80",
        "https://images.unsplash.com/photo-1549973890-38d08b229439?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=642&q=80",
        "https://images.unsplash.com/photo-1622263096760-5c79f72884af?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80"
      ],
      photoCoverture:
          "https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80",
      description:
          "Semarang City is the capital city of Central Java Province, Indonesia as well as the fifth largest metropolitan city in Indonesia",
      dateDebut: "2018-10-10",
      dateFin: "2018-10-10",
      proprietaireId: 1,
    ),
  ];

  static fromDocument(dynamic json, List<String> imgs) {
    return Hebergement(
      id: json['id'],
      nom: json['nom'],
      villeId: json['ville_id'],
      nbrVoyageur: json['nbr_voyageurs'],
      nbrPlacesDisp: json['nbr_place_dispo'],
      nbrChambresDisp: json['nbr_chambre_dispo'],
      nbrChambresIndiv: json['chambre_individuel'],
      nbrChambresDeux: json['chambre_a_deux'],
      nbrChambresTrois: json['chambre_a_trois'],
      prixAdulte: double.parse(json['prix_adulte'].toString()),
      prixEnfantMoin4: double.parse(json['prix_enfant_moin4'].toString()),
      prixEnfantPlus4: double.parse(json['prix_enfant_plus4'].toString()),
      categorie: json['categorie'],
      options: json['options'],
      disponibilite: json["disponibilite"],
      adresse: json["adresse"],
      longitude: double.parse(json['longitude'].toString()),
      latitude: double.parse(json['latitude'].toString()),
      photos: imgs,
      photoCoverture: json['image_couverture'],
      description: json['description'],
      dateDebut: "2020-01-01",
      dateFin: "2020-02-02",
      proprietaireId: json['proprietaire_id'],
    );
  }
}
