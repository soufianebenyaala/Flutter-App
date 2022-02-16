class PackReservation {
  final int? id;
  final String date;
  final String paye;
  final int annule;
  final int nbrPlaces;
  final int nbrAdultes;
  final int nbrEnfantPlus4;
  final int nbrEnfantMoin4;
  final int packId;
  final int userId;
  final int agenceId;

  PackReservation({
    this.id,
    required this.date,
    required this.paye,
    required this.annule,
    required this.nbrPlaces,
    required this.nbrAdultes,
    required this.nbrEnfantPlus4,
    required this.nbrEnfantMoin4,
    required this.packId,
    required this.userId,
    required this.agenceId,
  });

  static PackReservation fromDocument(dynamic json) {
    return PackReservation(
      agenceId: json["agence_id"],
      annule: json["annule"],
      date: json["date"],
      nbrAdultes: json["nb_adulte"],
      nbrEnfantMoin4: json["nb_enfant_moin4"],
      nbrEnfantPlus4: json["nb_enfant_plus4"],
      nbrPlaces: json["nbr_place"],
      paye: json["paye"],
      packId: json["pack_id"],
      userId: json["user_id"],
      id: json["id"],
    );
  }
}
