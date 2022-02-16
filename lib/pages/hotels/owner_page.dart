import 'package:etnafes/pages/hotels/owner_page_add_hotel.dart';
import 'package:etnafes/pages/hotels/owner_page_my_hotels.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelOwnerPage extends StatefulWidget {
  HotelOwnerPage({Key? key}) : super(key: key);

  @override
  _HotelOwnerPageState createState() => _HotelOwnerPageState();
}

class _HotelOwnerPageState extends State<HotelOwnerPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
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
              Text("Add accomadation"),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.account_circle),
              Text("My accomadations"),
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
          OwnerHotelAddPage(),
          OwnerHotelMyHotels(),
        ],
      ),
    );
  }
}
