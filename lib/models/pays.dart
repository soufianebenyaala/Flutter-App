class Pays {
  final int id;
  final int code;
  final String alpha2;
  final String alpha3;
  final String nomGb;
  final String nomFr;

  Pays({
    required this.id,
    required this.code,
    required this.alpha2,
    required this.alpha3,
    required this.nomGb,
    required this.nomFr,
  });

  static List<Pays> examplePays = [
    Pays(
        id: 1,
        code: 10,
        alpha2: "pa",
        alpha3: "pay",
        nomFr: "pays",
        nomGb: "Country"),
    Pays(
        id: 2,
        code: 20,
        alpha2: "sq",
        alpha3: "sqr",
        nomFr: "pays2",
        nomGb: "Country2"),
    Pays(
        id: 3,
        code: 30,
        alpha2: "az",
        alpha3: "aze",
        nomFr: "pays3",
        nomGb: "Country3"),
  ];

  static fromDocument(dynamic json) {
    return Pays(
      id: json["id"],
      code: json["code"],
      alpha2: json["alpha2"],
      alpha3: json["alpha3"],
      nomGb: json["nom_en_gb"],
      nomFr: json["nom_fr_fr"],
    );
  }
}
