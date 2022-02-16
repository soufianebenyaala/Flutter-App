import 'package:colours/colours.dart';
import 'package:etnafes/pages/intro_pages.dart';
import 'package:etnafes/pages/main_page.dart';
import 'package:etnafes/services/shared_prefes_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsManager.initializeSharedPrefs();
  await UserManager.initialize();
  await UserManager.fetchProprietaireData();
  await UserManager.fetchProprietaireRestoData();
  await UserManager.fetchAdminAgenceData();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale =
      Locale.fromSubtags(languageCode: SharedPrefsManager.getCurrentLanguage());

  bool isDarkMode = SharedPrefsManager.isDarkMode();
  bool seenStartUpScreen = SharedPrefsManager.didSeeStartScreen();

  void setLocale(String code) {
    setState(() {
      _locale = Locale.fromSubtags(languageCode: code);
      SharedPrefsManager.setCurrentLanguage(code);
    });
  }

  void setThemeMode(bool isDark) {
    setState(() {
      isDarkMode = isDark;
      SharedPrefsManager.setDarkMode(isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2400),
        builder: () => MaterialApp(
              locale: _locale,
              localizationsDelegates: const [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
                Locale('fr', ''),
              ],
              title: 'Etnafes',
              debugShowCheckedModeBanner: false,
              darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  textTheme: TextTheme(
                    subtitle1: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  )
                  /* dark theme settings */
                  ),
              theme: ThemeData(
                  primarySwatch: Colours.lightSkyBlue,
                  textTheme: TextTheme(
                    subtitle1: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  )),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: seenStartUpScreen ? MainPage() : IntroPages(),
            ));
  }
}
