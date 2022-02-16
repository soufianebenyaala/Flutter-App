import 'package:etnafes/pages/profile/profile_page_accomadation_reservations.dart';
import 'package:etnafes/pages/profile/profile_page_general_details.dart';
import 'package:etnafes/pages/profile/profile_page_packs_reservations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _profileTabController;

  @override
  void initState() {
    super.initState();
    _profileTabController = TabController(length: 3, vsync: this);
  }

  buildTabBar() {
    return TabBar(
      tabs: tabs,
      controller: _profileTabController,
      isScrollable: true,
    );
  }

  var tabs = [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Icon(Icons.account_circle),
        Text("General infos"),
      ],
    ),
    Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.hotel),
          Text("My accomadations reservations"),
        ]),
    Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.photo_album),
          Text("My packs reservations"),
        ])
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildTabBar(),
        Container(
          height: MediaQuery.of(context).size.height * 0.70,
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _profileTabController,
            children: [
              ProfilePageGeneralDetails(),
              ProfilePageAccomadationsReservations(),
              ProfilePagePacksReservation(),
            ],
          ),
        ),
      ],
    );
  }
}
