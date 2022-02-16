class User {
  final int id;
  final String firstname;
  final String lastname;
  final String login;
  final String email;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? civilite;
  final String? telephone;
  final String? photo;
  final int? villeId;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.login,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.civilite,
    required this.telephone,
    required this.photo,
    required this.villeId,
  });

  static fromDocument(dynamic json) {
    return User(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      login: json["login"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"] != null
          ? DateTime.parse(json["email_verified_at"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
      civilite: json["civilité"],
      telephone: json["telephone"],
      photo: json["photo"],
      villeId: json["ville_id"],
    );
  }
}
