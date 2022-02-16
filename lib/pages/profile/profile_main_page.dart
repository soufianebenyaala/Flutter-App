import 'package:colours/colours.dart';
import 'package:etnafes/pages/login_signup/login_signup_page.dart';
import 'package:etnafes/pages/profile/account_managment.dart';
import 'package:etnafes/pages/profile/profile_page.dart';
import 'package:etnafes/pages/profile/profile_page_accomadation_reservations.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ProfileMainPage extends StatefulWidget {
  ProfileMainPage({Key? key}) : super(key: key);

  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage>
    with SingleTickerProviderStateMixin {
  bool isLoggedIn = true;
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
      actions: [
        IconButton(
            onPressed: () async {
              await UserManager.logoutUser();
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout)),
      ],
      bottom: TabBar(
        controller: _controller,
        isScrollable: true,
        labelStyle: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600),
        tabs: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.account_circle),
              Text("Profile"),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.manage_accounts),
              Text("Account managment"),
            ],
          ),
        ],
      ),
    );
  }

  buildNotLoggedinScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LottieWidget.errorLoginSignup(),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text(
            "Login/signup",
            style: GoogleFonts.lato(
              fontSize: 24,
            ),
          ),
          onPressed: () {
            Fluttertoast.showToast(msg: "Please login or signup");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginSignupPage()));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: isLoggedIn
          ? TabBarView(
              controller: _controller,
              children: [
                ProfilePage(),
                AccountManagment(),
              ],
            )
          : buildNotLoggedinScreen(),
    );
  }
}
