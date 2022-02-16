class HebergementImage {
  final int id;
  final String urlImage;
  final int hebergementId;

  HebergementImage({
    required this.id,
    required this.urlImage,
    required this.hebergementId,
  });

  static HebergementImage fromDoc(dynamic json) {
    return HebergementImage(
        hebergementId: json["hebergement_id"],
        id: json["id"],
        urlImage: json["url_image"]);
  }
}
