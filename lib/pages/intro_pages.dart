import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/pages/main_page.dart';
import 'package:etnafes/services/shared_prefes_manager.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroPages extends StatefulWidget {
  IntroPages({Key? key}) : super(key: key);

  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        PageViewModel(
          mainImage: LottieBuilder.asset("assets/lottie/nature_travel.json"),
          pageColor: const Color(0xFF03A9F4),
          body: Text(
            LocalizationsManager.getPage1Description(context),
          ),
          title: Text(
            LocalizationsManager.getPage1Title(context),
          ),
        ),
        PageViewModel(
          mainImage: LottieBuilder.asset("assets/lottie/calendar_booking.json"),
          pageColor: const Color(0xFF03A9F4),
          body: Text(
            LocalizationsManager.getPage2Description(context),
          ),
          title: Text(
            LocalizationsManager.getPage2Title(context),
          ),
        ),
      ],
      showNextButton: true,
      showBackButton: true,
      backText: Text(LocalizationsManager.getBackButtonLabel(context)),
      nextText: Text(LocalizationsManager.getNextButtonLabel(context)),
      doneText: Text(LocalizationsManager.getDoneButtonLabel(context)),
      skipText: Text(LocalizationsManager.getSkipButtonLabel(context)),
      onTapDoneButton: () {
        SharedPrefsManager.setStartScreen();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      },
    );
  }
}
