import 'package:colours/colours.dart';
import 'package:etnafes/pages/agencies/agencies_scree.dart';
import 'package:etnafes/pages/agencies/agency_admin.dart';
import 'package:etnafes/pages/hotels/hotels_screen.dart';
import 'package:etnafes/pages/hotels/owner_page.dart';
import 'package:etnafes/pages/login_signup/login_signup_page.dart';
import 'package:etnafes/pages/packs/packs_screen.dart';
import 'package:etnafes/pages/profile/profile_main_page.dart';
import 'package:etnafes/pages/restaurants/restaurant_owner_page.dart';
import 'package:etnafes/pages/settings_page.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'restaurants/restaurants_screen.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _ptabController = PersistentTabController();

  final List<Widget> _buildScreens = [
    HotelsScreen(),
    ResturantsScreen(),
    PacksScreen(),
  ];

  buildListItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          LineIcons.hotel,
          size: 28,
        ),
        title: LocalizationsManager.getBottomAccomadationsLabel(context),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          LineIcons.building,
          size: 28,
        ),
        title: "Restaurants",
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.collections_outlined,
          size: 28,
        ),
        title: LocalizationsManager.getBottomBarPacks(context),
      ),
    ];
  }

  buildAdvancedBottomBar() {
    return PersistentTabView(
      context,
      controller: _ptabController,
      screens: _buildScreens,
      items: buildListItems(context),
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 500),
      ),
      navBarStyle:
          NavBarStyle.style9, // Choose the nav bar style with this property.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etnaffes"),
        leading: IconButton(
            onPressed: () {
              UserManager.isLoggedIn()
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileMainPage()))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginSignupPage()));
            },
            icon: const Icon(LineIcons.user)),
        actions: [
          if (UserManager.admineAgence != null)
            IconButton(
                icon: const Icon(LineIcons.building),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AgencyAdmin()));
                }),
          if (UserManager.proprietaireResto != null)
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantOwnerPage()));
              },
              icon: const Icon(Icons.restaurant),
            ),
          if (UserManager.proprietaire != null)
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HotelOwnerPage()));
              },
              icon: const Icon(LineIcons.hotel),
            ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: buildAdvancedBottomBar(),
    );
  }
}
