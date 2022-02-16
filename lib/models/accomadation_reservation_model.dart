import 'package:etnafes/models/hebergement.dart';

class AccomadationReservationData {
  final int? id;
  final String startDate;
  final String endDate;
  final String payment;
  final int canceled;
  final int nbrPlaces;
  final int nbrAdults;
  final int nbrChildrenUnder4;
  final int nbrChildrenOver4;
  final int accomadationId;
  final Hebergement? accomadation;
  final DateTime? createdAt;

  AccomadationReservationData({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.payment,
    required this.canceled,
    required this.nbrPlaces,
    required this.nbrAdults,
    required this.nbrChildrenUnder4,
    required this.nbrChildrenOver4,
    required this.accomadationId,
    this.accomadation,
    this.createdAt,
  });

  static AccomadationReservationData fromDocument(
      dynamic json, Hebergement? acc) {
    return AccomadationReservationData(
      id: json["id"],
      accomadationId: json["hebergement_id"],
      canceled: json["annule"],
      startDate: json["du"],
      endDate: json["au"],
      nbrAdults: json["nb_adulte"],
      nbrChildrenOver4: json["nb_enfant_plus4"],
      nbrChildrenUnder4: json["nb_enfant_moin4"],
      nbrPlaces: json["nb_place"],
      payment: json["paye"],
      accomadation: acc,
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
