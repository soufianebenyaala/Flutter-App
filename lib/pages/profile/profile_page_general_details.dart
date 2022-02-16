import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePageGeneralDetails extends StatefulWidget {
  ProfilePageGeneralDetails({Key? key}) : super(key: key);

  @override
  _ProfilePageGeneralDetailsState createState() =>
      _ProfilePageGeneralDetailsState();
}

class _ProfilePageGeneralDetailsState extends State<ProfilePageGeneralDetails> {
  buildNameField() {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(
          "${UserManager.currentUser!.firstname} ${UserManager.currentUser!.lastname}",
          style: GoogleFonts.lato(fontSize: 20),
        ),
        subtitle: Text("Name"));
  }

  buildEmailField() {
    return ListTile(
        leading: Icon(Icons.email),
        title: Text(
          UserManager.currentUser!.email,
          style: GoogleFonts.lato(fontSize: 20),
        ),
        subtitle: Text("Email"));
  }

  buildJoinDate() {
    return ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text(
          "${UserManager.currentUser!.createdAt!.year}-${UserManager.currentUser!.createdAt!.month}-${UserManager.currentUser!.createdAt!.day}",
          style: GoogleFonts.lato(fontSize: 20),
        ),
        subtitle: Text("Join date"));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildNameField(),
        buildEmailField(),
        buildJoinDate(),
      ],
    );
  }
}
