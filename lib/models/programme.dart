class Programme {
  final int? id;
  final String titre;
  final String description;
  final int? packId;

  Programme({
    this.id,
    required this.titre,
    required this.description,
    this.packId,
  });

  static Map<String, String> toMap(Programme p) {
    return {
      "titre": p.titre,
      "description": p.description,
    };
  }
}
