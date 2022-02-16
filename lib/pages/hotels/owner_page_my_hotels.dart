import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';

class OwnerHotelMyHotels extends StatefulWidget {
  OwnerHotelMyHotels({Key? key}) : super(key: key);

  @override
  _OwnerHotelMyHotelsState createState() => _OwnerHotelMyHotelsState();
}

class _OwnerHotelMyHotelsState extends State<OwnerHotelMyHotels> {
  List<Hebergement> myHebergements = [];
  bool _loadedHebergements = false;

  @override
  void initState() {
    super.initState();
    fetchUserAccomadations();
  }

  fetchUserAccomadations() async {
    _loadedHebergements = false;
    myHebergements = await UserManager.getUserAccomadations();
    setState(() {
      _loadedHebergements = true;
    });
  }

  buildAllAccomadations() {
    List<Widget> lst = [];
    for (var item in myHebergements) {
      lst.add(GestureDetector(
        onTap: () {
          accomadationPopup(item);
        },
        child: ListTile(
          title: Text(item.nom),
          subtitle: Text(item.dateDebut + " | " + item.dateFin),
        ),
      ));
    }
    if (lst.isEmpty) {
      return [LottieWidget.noItemsAnimation()];
    }
    return lst;
  }

  accomadationPopup(Hebergement h) async {
    await NDialog(
      title: Text(h.nom),
      content: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Description : " + h.description),
            SizedBox(height: 10),
            Text("Categorie : " + h.categorie),
          ],
        ),
      )),
      actions: [
        TextButton.icon(
          onPressed: () {
            handleAccomadationRemove(h);
          },
          icon: Icon(Icons.remove_circle, color: Colors.red),
          label: Text(
            "Supprimer",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  handleAccomadationRemove(Hebergement h) async {
    var r = await UserManager.removeAccomadation(h);
    if (r) {
      Navigator.pop(context);
      fetchUserAccomadations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            if (_loadedHebergements) ...buildAllAccomadations(),
          ],
        ),
      ),
    );
  }
}
