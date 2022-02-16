import 'dart:convert';
import 'package:etnafes/models/accomadation_reservation_model.dart';
import 'package:etnafes/models/admin_agence.dart';
import 'package:etnafes/models/pack.dart';
import 'package:etnafes/models/pack_reservation.dart';
import 'package:etnafes/models/programme.dart';
import 'package:etnafes/models/proprietaire_resto.dart';
import 'package:etnafes/models/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/models/proprietaire.dart';
import 'package:etnafes/models/user.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/shared_prefes_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserManager {
  static bool _loggedIn = false;

  static Proprietaire? proprietaire;
  static PropiretaireResto? proprietaireResto;
  static AdminAgence? admineAgence;
  static String token = "";
  static User? currentUser;

  static Dio dio = Dio();

  //Initial setup of the class

  static initialize() async {
    token = SharedPrefsManager.getUserToken();
    try {
      if (token != "none") {
        var r = await http.get(Uri.parse("${ApiManager.apiAddress}user"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'accept': 'application/json',
              'Authorization': 'Bearer $token'
            });
        var js = jsonDecode(r.body);
        if (js["message"] != null) {
          print("Not logged in");
          _loggedIn = false;
        } else {
          _loggedIn = true;
          currentUser = User.fromDocument(js);
        }
      }
    } catch (e) {
      print("Could not connect !!!!");
      print(e);
    }
  }

  // Fetching related owner data

  static fetchProprietaireData() async {
    if (currentUser != null) {
      var r = await http.get(
          Uri.parse(ApiManager.apiAddress +
              ApiManager.proprietaireSearch +
              "${currentUser!.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'accept': 'application/json',
          });
      var js = jsonDecode(r.body);
      if ((js["data"] as List).isNotEmpty) {
        proprietaire = Proprietaire.fromDocument(js["data"][0]);
      }
    }
  }

  //Fetching admin agence info
  static fetchAdminAgenceData() async {
    if (currentUser != null) {
      var r = await http.get(
          Uri.parse(ApiManager.apiAddress +
              ApiManager.agencyAdminSearch +
              "${currentUser!.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'accept': 'application/json',
          });
      var js = jsonDecode(r.body);
      if ((js["data"] as List).isNotEmpty) {
        admineAgence = AdminAgence.fromDocument(js["data"][0]);
      }
    }
  }
  //Fetching related restaurant owner data

  static fetchProprietaireRestoData() async {
    if (currentUser != null) {
      var r = await http.get(
          Uri.parse(ApiManager.apiAddress +
              ApiManager.findRestaurantOwner +
              "${currentUser!.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'accept': 'application/json',
          });
      var js = jsonDecode(r.body);
      if ((js["data"] as List).isNotEmpty) {
        proprietaireResto = PropiretaireResto.fromDocument(js["data"][0]);
      }
    }
  }

  //Logout

  static logoutUser() async {
    await http.post(Uri.parse("${ApiManager.apiAddress}logout"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    _loggedIn = false;
    token = "";
    currentUser = null;
    SharedPrefsManager.setUserToken("none");
  }

  // Login

  static Future<String> loginUser(
      {required String email, required String password}) async {
    try {
      var r = await http.post(
        Uri.parse("${ApiManager.apiAddress}login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      var js = jsonDecode(r.body);
      if (js["errors"] != null) {
        if (js["errors"]["email"] != null) {
          return "Wrong credintials";
        }
      }

      token = js["access_token"];
      currentUser = User.fromDocument(js["user"]);
      _loggedIn = true;
      await fetchProprietaireData();

      SharedPrefsManager.setUserToken(token);
      return "";
    } catch (e) {
      return "Error connecting, please try again later";
    }
  }

  // Register new user

  static Future<http.Response> signUpUser({
    required String login,
    required String email,
    required String pass,
    required String firstName,
    required String lastName,
    required int villeId,
  }) {
    return http.post(
      Uri.parse("${ApiManager.apiAddress}register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'login': login,
        'email': email,
        'password': pass,
        'password_confirmation': pass,
        'firstname': firstName,
        'lastname': lastName,
        'ville_id': villeId.toString(),
      }),
    );
  }

  //Check if logged in

  static bool isLoggedIn() {
    return _loggedIn;
  }

  // Register as accomadation owner

  static Future<bool> registerAsHotelOwner(
      {required String cin, required String postCode}) async {
    var r = await http.post(
      Uri.parse("${ApiManager.apiAddress}proprietaire"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'cin': cin,
        'code_postal': postCode,
      }),
    );
    var js = jsonDecode(r.body);
    return js["message"] == "success";
  }

  static Future<bool> registerAsRestaurantOwner(
      {required String cin, required String phone}) async {
    var r = await http.post(
      Uri.parse(ApiManager.apiAddress + ApiManager.registerRestaurantOwner),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'cin': cin,
        'telephone': phone,
      }),
    );
    var js = jsonDecode(r.body);
    print(js);
    print("DOne ");
    return js["message"] == "success";
  }

  //Register as agency owner

  static Future<bool> registerAsAgencyOwner(
      {required String presentation, required XFile carte}) async {
    var r = await http.post(
      Uri.parse(ApiManager.apiAddress + ApiManager.agencyAdmin),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'carte_professionnel_agence': jsonEncode(await toBase64(carte)),
        'presentation': presentation,
      }),
    );
    var js = jsonDecode(r.body);

    return true;
  }

  static Future<bool> updateAgencyCard(XFile? img) async {
    var r = await http.post(
      Uri.parse(ApiManager.apiAddress + ApiManager.agncyUpdateCard),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'carte_professionnel_agence': jsonEncode(await toBase64(img!)),
        'image_name': admineAgence!.carteProfessionnelAgence,
      }),
    );
    return true;
  }

  static Future<bool> updateAgencyPresentation(String presentation) async {
    var r = await http.post(
      Uri.parse(ApiManager.apiAddress + ApiManager.agencyUpdatePresentation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'presentation': presentation,
        'id': admineAgence!.id.toString(),
      }),
    );
    await fetchAdminAgenceData();
    return true;
  }

  //Add a new restaurant

  static Future<bool> addRestaurant(
      {required Restaurant restaurant, required List<XFile> images}) async {
    List<Map> attch = [];
    for (int i = 0; i < images.length; i++) {
      attch.add(await toBase64(images[i]));
    }
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("${ApiManager.apiAddress}restaurant"));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      print(restaurant.longitude);
      Map<String, String> fields = {
        "nom": restaurant.nom,
        "description": restaurant.description,
        "longitude": restaurant.longitude.toString(),
        "latitude": restaurant.latitude.toString(),
        "ville_id": restaurant.villeId.toString(),
        "photos": jsonEncode(attch),
      };

      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());
      print(resp);
    } catch (e) {
      print("Failed");

      return false;
    }

    return true;
  }

  // add a new hotel

  static Future<bool> addHotel(
      {required Hebergement hebergement,
      required XFile coverImage,
      required List<XFile> images}) async {
    List<Map> attch = [];
    for (int i = 0; i < images.length; i++) {
      attch.add(await toBase64(images[i]));
    }

    Map<String, String> fields = {
      "nom": hebergement.nom,
      "nbr_voyageurs": hebergement.nbrVoyageur.toString(),
      "nbr_place_dispo": hebergement.nbrPlacesDisp.toString(),
      "nbr_chambre_dispo": hebergement.nbrChambresDisp.toString(),
      "description": hebergement.description,
      "adresse": hebergement.adresse,
      "chambre_individuel": hebergement.nbrChambresIndiv.toString(),
      "chambre_a_deux": hebergement.nbrChambresDeux.toString(),
      "chambre_a_trois": hebergement.nbrChambresTrois.toString(),
      "disponibilite": hebergement.disponibilite,
      "latitude": hebergement.latitude.toString(),
      "longitude": hebergement.longitude.toString(),
      "prix_adulte": hebergement.prixAdulte.toString(),
      "prix_enfant_moin4": hebergement.prixEnfantMoin4.toString(),
      "prix_enfant_plus4": hebergement.prixEnfantPlus4.toString(),
      "categorie": hebergement.categorie,
      "options": hebergement.options,
      "date[0][date_deb]": hebergement.dateDebut,
      "date[0][date_fin]": hebergement.dateFin,
      "ville_id": hebergement.villeId.toString(),
      "image_couverture": jsonEncode(await toBase64(coverImage)),
      "photos": jsonEncode(attch),
    };

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("${ApiManager.apiAddress}hebergement"));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());

      return resp["success"];
    } catch (e) {
      return false;
    }
  }

  // Make an accomadation reservation

  static Future<bool> reserveAccomadation(
      AccomadationReservationData reservationData) async {
    Map<String, String> fields = {
      "du": reservationData.startDate,
      "au": reservationData.endDate,
      "paye": reservationData.payment,
      "annule": reservationData.canceled.toString(),
      "nb_place": reservationData.nbrPlaces.toString(),
      "nb_adulte": reservationData.nbrAdults.toString(),
      "nb_enfant_plus4": reservationData.nbrChildrenOver4.toString(),
      "nb_enfant_moin4": reservationData.nbrChildrenUnder4.toString(),
      "hebergement_id": reservationData.accomadationId.toString(),
    };
    try {
      var request = http.MultipartRequest(
          "POST",
          Uri.parse(
              ApiManager.apiAddress + ApiManager.accomadationReservation));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());
      return resp["message"] == "success";
    } catch (e) {
      return false;
    }
  }

  // fetch all user made accomadations

  static Future<List<Hebergement>> getUserAccomadations() async {
    List<Hebergement> accomadations = [];
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress +
          ApiManager.getUserAccomadations +
          proprietaire!.id.toString(),
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];

    for (int i = 0; i < data.length; i++) {
      List<String>? imgs = [];
      var file3 = await DefaultCacheManager().getSingleFile(
          ApiManager.apiAddress +
              ApiManager.allAcoomadationImages +
              data[i]["hebergement_id"].toString());
      var res3 = await file3.readAsString();
      var json3 = jsonDecode(res3);
      var data3 = json3["data"];
      for (var j = 0; j < data3.length; j++) {
        imgs.add(ApiManager.filesAddress + data3[j]["url_image"]);
      }

      accomadations.add(Hebergement.fromDocument(data[i], imgs));
    }
    return accomadations;
  }

  //get user restaurants
  static Future<List<Restaurant>> getUserRestaurants() async {
    List<Restaurant> lst = [];
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress +
          ApiManager.getUserRestaurants +
          proprietaireResto!.id.toString(),
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (int i = 0; i < data.length; i++) {
      lst.add(Restaurant.fromDocument(data[i], []));
    }
    return lst;
  }

  // Delete a single accomadation

  static Future<bool> removeAccomadation(Hebergement h) async {
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress + "delhebergmenets/${h.id}",
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );
    var res = await file.readAsString();
    var json = jsonDecode(res);

    return (json["data"] == 1);
  }

  // Delete a single restaurant
  static Future<bool> removeRestaurant(Restaurant r) async {
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress + "delrestaurant/${r.id}",
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );
    var res = await file.readAsString();
    var json = jsonDecode(res);

    return (json["data"] == 1);
  }

  // Fetch all user packs

  static Future<List<Pack>> getAgencyAdminPacks() async {
    List<Pack> lst = [];
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress +
          ApiManager.getUserPacks +
          admineAgence!.id.toString(),
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (int i = 0; i < data.length; i++) {
      lst.add(Pack.fromDocument(data[i]));
    }
    return lst;
  }

  // Remove single pack
  static Future<bool> removePack(Pack pack) async {
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress + "delPack/${pack.id}",
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );
    var res = await file.readAsString();
    var json = jsonDecode(res);

    return (json["data"] == 1);
  }

  //Fetch all user accomadation reservations reservations !

  static Future<List<AccomadationReservationData>>
      getUserAccomadationReservation(var userId) async {
    List<AccomadationReservationData> rslt = [];

    // Fetching all user reservations
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress + ApiManager.myReservations + userId.toString(),
      headers: {
        "accept": "application/json",
        "Authorization": 'Bearer $token',
      },
      key: DateTime.now().toString(),
    );

    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (int i = 0; i < data.length; i++) {
      // Fetching single reservation details
      var file2 = await DefaultCacheManager().getSingleFile(
          ApiManager.apiAddress +
              ApiManager.getAccomadationById +
              data[i]["hebergement_id"].toString());
      var res2 = await file2.readAsString();
      var json2 = jsonDecode(res2);

      // Getting reservation images
      List<String>? imgs = [];
      var file3 = await DefaultCacheManager().getSingleFile(
          ApiManager.apiAddress +
              ApiManager.allAcoomadationImages +
              data[i]["hebergement_id"].toString());
      var res3 = await file3.readAsString();
      var json3 = jsonDecode(res3);
      var data3 = json3["data"];
      for (var j = 0; j < data3.length; j++) {
        imgs.add(ApiManager.filesAddress + data3[j]["url_image"]);
      }

      Hebergement h = Hebergement.fromDocument(json2["data"][0], imgs);

      rslt.add(AccomadationReservationData.fromDocument(data[i], h));
    }

    return rslt;
  }

  // Cancel user reservation !

  static Future<bool> cancelReservation(
      AccomadationReservationData reservation) async {
    try {
      var r = await http.get(
          Uri.parse(ApiManager.apiAddress +
              "cancel_reservation_hebergement/${reservation.id}"),
          headers: {
            "accept": "application/json",
            "Authorization": 'Bearer $token',
          });
      var resp = jsonDecode(r.body);
      return resp["message"] == "success";
    } catch (e) {
      return false;
    }
  }

  // update reservation
  static Future<bool> updateReservaion(
      AccomadationReservationData reservation) async {
    Map<String, String> fields = {
      "id": reservation.id.toString(),
      "du": reservation.startDate,
      "au": reservation.endDate,
      "paye": reservation.payment,
      "annule": reservation.canceled.toString(),
      "nb_place": reservation.nbrPlaces.toString(),
      "nb_adulte": reservation.nbrAdults.toString(),
      "nb_enfant_plus4": reservation.nbrChildrenOver4.toString(),
      "nb_enfant_moin4": reservation.nbrChildrenUnder4.toString(),
      "hebergement_id": reservation.accomadationId.toString(),
    };

    try {
      var request = http.MultipartRequest("POST",
          Uri.parse(ApiManager.apiAddress + ApiManager.updateReservation));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());
      return resp["message"] == "success";
    } catch (e) {
      return false;
    }
  }

  // add a pack

  static Future<bool> addPack(Pack p, List<Programme> programs,
      List<String> activities, XFile img) async {
    var convImg = jsonEncode(await toBase64(img));
    List<Map<String, String>> progs = [];
    programs.forEach((element) {
      progs.add(Programme.toMap(element));
    });

    Map<String, String> fields = {
      "titre": p.titre,
      "date_deb": p.dateDebut,
      "date_fin": p.dateFin,
      "description": p.description,
      "url_video": "test url",
      "nb_place_max": p.nbPlaceMax.toString(),
      "nb_place_dispo": p.nbPlaceDispo.toString(),
      "nb_place_remise": p.nbPlaceRemise.toString(),
      "adrenaline": p.adrenaline!,
      "ville_id": p.villeId!.toString(),
      "admin_agence_id": p.adminAgenceId.toString(),
      "image_couverture": convImg,
      "programmes": jsonEncode(progs),
      "activities": jsonEncode(activities),
    };

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(ApiManager.apiAddress + ApiManager.addPack));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());

      return resp["message"] == "success";
    } catch (e) {
      return false;
    }
  }

  static Future<bool> reservePack(PackReservation pack) async {
    Map<String, String> fields = {
      "agence_id": pack.agenceId.toString(),
      "pack_id": pack.packId.toString(),
      "date": pack.date,
      "paye": pack.paye,
      "nbr_place": pack.nbrPlaces.toString(),
      "nb_adulte": pack.nbrAdultes.toString(),
      "nb_enfant_plus4": pack.nbrEnfantPlus4.toString(),
      "nb_enfant_moin4": pack.nbrEnfantMoin4.toString(),
      "user_id ": pack.userId.toString(),
    };
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(ApiManager.apiAddress + ApiManager.reservePack));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());
      print(resp);
      return resp["message"] == "success";
    } catch (e) {
      return false;
    }
  }

  // Get all packs reservations
  static Future<List<PackReservation>> getAllUserPacks() async {
    List<PackReservation> lst = [];
    var file = await DefaultCacheManager().getSingleFile(
      ApiManager.apiAddress + ApiManager.getPacks + "/5",
      headers: {
        "accept": "application/json",
      },
      key: DateTime.now().toString(),
    );

    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (int i = 0; i < data.length; i++) {
      lst.add(PackReservation.fromDocument(data[i]));
    }
    return lst;
  }

  // Cancel pack reservation

  static Future<bool> cancelPackReservation(PackReservation reservation) async {
    try {
      var r = await http.get(
          Uri.parse(ApiManager.apiAddress +
              "cancel_pack_reservation/${reservation.id}"),
          headers: {
            "accept": "application/json",
            "Authorization": 'Bearer $token',
          });
      var resp = jsonDecode(r.body);
      print(resp);
      return resp["message"] == "success";
    } catch (e) {
      return false;
    }
  }

  // update pack reservation
  static Future<bool> updatePackReservation(PackReservation reservation) async {
    //update_pack_reservation

    Map<String, String> fields = {
      "id": reservation.id.toString(),
      "date": reservation.date,
      "paye": reservation.paye,
      "nbr_place": reservation.nbrPlaces.toString(),
      "nb_adulte": reservation.nbrAdultes.toString(),
      "nb_enfant_plus4": reservation.nbrEnfantPlus4.toString(),
      "nb_enfant_moin4": reservation.nbrEnfantPlus4.toString(),
    };

    try {
      var request = http.MultipartRequest("POST",
          Uri.parse(ApiManager.apiAddress + ApiManager.updatePackReservation));
      request.headers["accept"] = "application/json";
      request.headers["Authorization"] = 'Bearer $token';
      request.fields.addAll(fields);
      var r = await request.send();
      var resp = jsonDecode(await r.stream.bytesToString());
      print(resp);
      return resp["message"] == "success";
    } catch (e) {
      return false;
    }

    return false;
  }

  // Convert an image to base 64 string to be sent to server and decoded

  static Future<Map> toBase64(XFile file) async {
    Map a = {
      'fileName': file.name,
      'encoded': base64Encode(await file.readAsBytes())
    };
    return a;
  }
}
