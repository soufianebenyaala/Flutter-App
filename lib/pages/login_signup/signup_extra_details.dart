import 'dart:convert';

import 'package:circle_flags/circle_flags.dart';
import 'package:etnafes/models/pays.dart';
import 'package:etnafes/models/ville.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';

class SignupExtraInfos extends StatefulWidget {
  SignupExtraInfos({Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  _SignupExtraInfosState createState() => _SignupExtraInfosState();
}

class _SignupExtraInfosState extends State<SignupExtraInfos> {
  String _name = "";
  String _firstName = "";
  String _lastName = "";
  int _villeId = -1;
  int _countryId = -1;

  String countryName = "";
  String cityName = "";
  bool _loadedCountries = false;
  bool _loadedCities = false;
  late List<DropdownMenuItem<Pays>> countries;
  late List<DropdownMenuItem<Ville>> cities;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      showStartDialog();
      fetchCountries();
    });
  }

  buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Registration for : ${widget.email}",
            style: GoogleFonts.lato(fontSize: 20)),
        Text("Just one more step", style: GoogleFonts.lato(fontSize: 20)),
      ],
    );
  }

  showStartDialog() async {
    await NDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Registration for : ${widget.email}",
              style: GoogleFonts.lato(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            LottieWidget.lastStepRegister(),
            Text("Just one more step", style: GoogleFonts.lato(fontSize: 20)),
          ],
        ),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  fetchCountries() async {
    _loadedCountries = false;
    var ctrs = await ApiManager.getAllCountries();
    countries = [];
    for (var i = 0; i < ctrs.length; i++) {
      countries.add(
        DropdownMenuItem(
          child: ListTile(
            title: Text(ctrs[i].nomGb),
            leading: CircleFlag(
              ctrs[i].alpha2,
              size: 25,
            ),
          ),
          value: ctrs[i],
        ),
      );
    }

    setState(() {
      _loadedCountries = true;
    });
  }

  fetchCities(int countryId) async {
    _loadedCities = false;
    var cts = await ApiManager.getAllCities(countryId);
    cities = [];
    for (var i = 0; i < cts.length; i++) {
      cities.add(
        DropdownMenuItem(
          child: Text(cts[i].nom),
          value: cts[i],
        ),
      );
    }

    setState(() {
      _loadedCities = true;
    });
  }

  buildAppBar() {
    return AppBar(
      title: const Text("Etnaffes"),
    );
  }

  buildLoginFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.person),
          hintText: "Login",
          labelText: "Login : "),
      onChanged: (val) {
        _name = val;
      },
    );
  }

  buildFirstNameFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.person),
          hintText: "FirstName",
          labelText: "FirstName : "),
      onChanged: (val) {
        _firstName = val;
      },
    );
  }

  buildLastNameFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.person),
          hintText: "LastName",
          labelText: "LastName : "),
      onChanged: (val) {
        _lastName = val;
      },
    );
  }

  buildCountriesDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          Text(countryName),
          DropdownButton(
            items: countries,
            isExpanded: true,
            hint: const Text("Countries"),
            onChanged: (val) {
              setState(() {
                _countryId = (val as Pays).id;
                countryName = (val as Pays).nomGb;
                fetchCities(_countryId);
              });
            },
          ),
        ],
      ),
    );
  }

  buildCitiesDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          Text(cityName),
          DropdownButton(
            isExpanded: true,
            items: cities,
            hint: const Text("Cities"),
            onChanged: (val) {
              setState(() {
                cityName = (val as Ville).nom;
                _villeId = (val as Ville).id;
              });
            },
          ),
        ],
      ),
    );
  }

  signup() async {
    print("Signing up");
    print(_lastName);
    print(_firstName);
    var s = await UserManager.signUpUser(
        login: _name,
        email: widget.email,
        pass: widget.password,
        firstName: _firstName,
        lastName: _lastName,
        villeId: _villeId);
    var js = jsonDecode(s.body);
    print(js["user"]);
    if (js["errors"] != null) {
      if (js["errors"]["email"] != null) {
        Fluttertoast.showToast(msg: js["errors"]["email"][0].toString());
      }
    }
  }

  buildExtraFieldsForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          buildFirstNameFormField(),
          const SizedBox(height: 20),
          buildLastNameFormField(),
          const SizedBox(height: 20),
          buildLoginFormField(),
          const SizedBox(height: 20),
          if (_loadedCountries) buildCountriesDropDown(),
          if (_loadedCities) buildCitiesDropDown(),
          TextButton(
            onPressed: () {
              signup();
            },
            child: Text(LocalizationsManager.getSignupLabel(context),
                style: GoogleFonts.lato(fontSize: 50.sp)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: buildExtraFieldsForm(),
      ),
    );
  }
}
