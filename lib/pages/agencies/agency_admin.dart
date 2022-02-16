import 'package:etnafes/pages/agencies/agency_admin_add_packs.dart';
import 'package:etnafes/pages/agencies/agency_admin_general_details.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'agency_my_packs.dart';

class AgencyAdmin extends StatefulWidget {
  AgencyAdmin({Key? key}) : super(key: key);

  @override
  _AgencyAdminState createState() => _AgencyAdminState();
}

class _AgencyAdminState extends State<AgencyAdmin>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(UserManager.currentUser!.login),
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left_rounded)),
      bottom: TabBar(
        controller: _controller,
        isScrollable: true,
        labelStyle: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600),
        tabs: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.favorite),
              Text("General details"),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.account_circle),
              Text("Add packs"),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.account_circle),
              Text("My packs"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          AgencyAdminGeneralDetails(),
          AgencyAdminAddPacks(),
          AgencyMyPacks(),
        ],
      ),
    );
  }
}
