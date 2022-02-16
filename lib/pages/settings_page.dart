import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:enhanced_drop_down/enhanced_drop_down.dart';
import 'package:etnafes/constants/constants.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/main.dart';
import 'package:etnafes/services/shared_prefes_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedValue = SharedPrefsManager.getCurrentLanguage();

  List<DropdownMenuItem<String>> get languages {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("English"), value: "en"),
      DropdownMenuItem(child: Text("Francais"), value: "fr"),
    ];
    return menuItems;
  }

  buildDropDownButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButton(
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
            MyApp.of(context)!.setLocale(selectedValue);
          });
        },
        items: languages,
      ),
    );
  }

  buildThemeChanger() {
    return Column(
      children: [
        Text(
          LocalizationsManager.getThemeLabel(context),
          style: GoogleFonts.lato(fontSize: 20),
        ),
        const SizedBox(height: 20),
        DayNightSwitcher(
          isDarkModeEnabled: SharedPrefsManager.isDarkMode(),
          onStateChanged: (isDarkModeEnabled) {
            MyApp.of(context)!.setThemeMode(isDarkModeEnabled);
          },
        ),
      ],
    );
  }

  buildAboutPopUpButton() {
    return TextButton.icon(
        onPressed: () => showAboutPopUp(),
        icon: Icon(Icons.info),
        label: Text("About us"));
  }

  showAboutPopUp() async {
    await NDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  "Etnafes est une plateforme pour rechercher et trouver un logement rapidement"),
              TextButton.icon(
                  onPressed: () {
                    launch("https://www.facebook.com/ETNAFES/");
                  },
                  icon: Icon(LineIcons.facebook),
                  label: Text("Facebook")),
              TextButton.icon(
                  onPressed: () {
                    launch("https://www.instagram.com/etnafes.tn/");
                  },
                  icon: Icon(LineIcons.instagram),
                  label: Text("Instagram")),
              TextButton.icon(
                  onPressed: () {
                    launch("https://www.etnafes.com/");
                  },
                  icon: Icon(LineIcons.globe),
                  label: Text("Website")),
            ],
          ),
        ),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  buildAppBar() {
    return AppBar(
      title: Text(LocalizationsManager.getSettingsPageLabel(context)),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieWidget.settingsAnimation(),
              const Divider(),
              buildDropDownButton(),
              const Divider(),
              buildThemeChanger(),
              const Divider(),
              buildAboutPopUpButton(),
            ],
          ),
        ));
  }
}
