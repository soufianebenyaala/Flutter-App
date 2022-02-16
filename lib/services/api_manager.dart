import 'dart:convert';

import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/models/pack.dart';
import 'package:etnafes/models/pays.dart';
import 'package:etnafes/models/restaurant.dart';
import 'package:etnafes/models/ville.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ApiManager {

  
  static const String apiAddress = "http://192.168.206.247:8000/api/";

  static const String filesAddress = "http://192.168.206.247:8000/";

  static const String allCountriesLink = "pays";
  static const String allCitiesLink = "ville/";

  static const String userRegisterLink = "register";

  static const String userMailExist = "user/check/";
  static const String proprietaireSearch = "prop/";

  static const String allAcoomadations = "pubhebergement";
  static const String allAcoomadationImages = "pubhebergementimages/";
  static const String allAccomadationsCategory = "pubhebergement/category/";
  static const String searchAccomadations = "pubhebergement/search/";
  static const String getAccomadationById = "pubhebergement/byid/";
  static const String getUserAccomadations = "pubhebergement/byuserid/";

  static const String registerRestaurantOwner = "proprietairerestaurant";
  static const String findRestaurantOwner = "pubrestaurantowner/";
  static const String getAllRestaurants = "pubrestaurant";
  static const String getAllRestaurantsImages = "pubrestaurantimages/";
  static const String searchRestaurants = "pubrestaurant/search/";
  static const String getUserRestaurants = "pubrestaurant/byuserid/";

  //Reservation
  static const String accomadationReservation = "reservation_hebergement";
  static const String myReservations = "reservation_hebergement_private/";
  static const String updateReservation = "update_reservation_hebergement";

  //Agency
  static const String agencyAdmin = "adminagence";
  static const String agencyAdminSearch = "adminagencesearch/";
  static const String agncyUpdateCard = "admineagencecard";
  static const String agencyUpdatePresentation = "admineagencepresentation";

  // packs
  static const String addPack = "pack";
  static const String getPacks = "pubpacks";
  static const String reservePack = "reservationpack";
  static const String updatePackReservation = "update_pack_reservation";
  static const String getUserPacks = "pubpacks/byuserid/";

  static Future<List<Pays>> getAllCountries() async {
    List<Pays> countries = [];

    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + allCountriesLink);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (var i = 0; i < data.length; i++) {
      Pays p = Pays.fromDocument(data[i]);
      countries.add(p);
    }
    return countries;
  }

  static Future<List<Hebergement>> getAllAcoomadations() async {
    List<Hebergement> accomadations = [];

    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + allAcoomadations);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (var i = 0; i < data.length; i++) {
      List<String>? imgs = [];
      var file2 = await DefaultCacheManager().getSingleFile(
          apiAddress + allAcoomadationImages + "${data[i]['id']}");
      var res2 = await file2.readAsString();
      var json2 = jsonDecode(res2);
      var data2 = json2["data"];
      for (var j = 0; j < data2.length; j++) {
        imgs.add(filesAddress + data2[j]["url_image"]);
      }
      Hebergement h = Hebergement.fromDocument(data[i], imgs);
      accomadations.add(h);
    }
    return accomadations;
  }

  static Future<List<Hebergement>> getAllAccomadationsWithCategory(
      String category) async {
    List<Hebergement> accomadations = [];
    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + allAccomadationsCategory + category);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];

    for (var i = 0; i < data.length; i++) {
      List<String>? imgs = [];
      var file2 = await DefaultCacheManager().getSingleFile(
          apiAddress + allAcoomadationImages + "${data[i]['id']}");
      var res2 = await file2.readAsString();
      var json2 = jsonDecode(res2);
      var data2 = json2["data"];
      for (var j = 0; j < data2.length; j++) {
        imgs.add(filesAddress + data2[j]["url_image"]);
      }
      Hebergement h = Hebergement.fromDocument(data[i], imgs);
      accomadations.add(h);
    }

    return accomadations;
  }

  static Future<List<Hebergement>> getSearchedAccomadations(String name) async {
    List<Hebergement> accomadations = [];
    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + searchAccomadations + name);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];

    for (var i = 0; i < data.length; i++) {
      List<String>? imgs = [];
      var file2 = await DefaultCacheManager().getSingleFile(
          apiAddress + allAcoomadationImages + "${data[i]['id']}");
      var res2 = await file2.readAsString();
      var json2 = jsonDecode(res2);
      var data2 = json2["data"];
      for (var j = 0; j < data2.length; j++) {
        imgs.add(filesAddress + data2[j]["url_image"]);
      }

      Hebergement h = Hebergement.fromDocument(data[i], imgs);
      accomadations.add(h);
    }

    return accomadations;
  }

  static Future<List<Restaurant>> getAllRestaurant() async {
    List<Restaurant> rst = [];

    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + getAllRestaurants);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];

    for (var i = 0; i < data.length; i++) {
      List<String>? imgs = [];
      var file2 = await DefaultCacheManager().getSingleFile(
          apiAddress + getAllRestaurantsImages + "${data[i]['id']}");
      var res2 = await file2.readAsString();
      var json2 = jsonDecode(res2);
      var data2 = json2["data"];
      for (var j = 0; j < data2.length; j++) {
        imgs.add(filesAddress + data2[j]["image_url"]);
      }
      Restaurant r = Restaurant.fromDocument(data[i], imgs);
      rst.add(r);
    }

    return rst;
  }

  static Future<List<Restaurant>> getSearchedRestaurants(String name) async {
    List<Restaurant> lst = [];
    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + searchRestaurants + name);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (var i = 0; i < data.length; i++) {
      List<String>? imgs = [];
      var file2 = await DefaultCacheManager().getSingleFile(
          apiAddress + getAllRestaurantsImages + "${data[i]['id']}");
      var res2 = await file2.readAsString();
      var json2 = jsonDecode(res2);
      var data2 = json2["data"];
      for (var j = 0; j < data2.length; j++) {
        imgs.add(filesAddress + data2[j]["image_url"]);
      }
      Restaurant r = Restaurant.fromDocument(data[i], imgs);
      lst.add(r);
    }

    return lst;
  }

  static Future<List<Ville>> getAllCities(int countryId) async {
    List<Ville> cities = [];
    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + allCitiesLink + "$countryId");
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    for (var i = 0; i < data.length; i++) {
      cities.add(Ville.fromDocument(data[i]));
    }
    return cities;
  }

  //Get all packs !

  static Future<List<Pack>> getAllPacks() async {
    List<Pack> packs = [];
    var file = await DefaultCacheManager().getSingleFile(apiAddress + getPacks);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    print(data);
    for (var i = 0; i < data.length; i++) {
      packs.add(Pack.fromDocument(data[i]));
    }
    return packs;
  }

  static Future<bool> doesMailExist(String email) async {
    var file = await DefaultCacheManager()
        .getSingleFile(apiAddress + userMailExist + email);
    var res = await file.readAsString();
    var json = jsonDecode(res);
    var data = json["data"];
    return data.length > 0;
  }
}
