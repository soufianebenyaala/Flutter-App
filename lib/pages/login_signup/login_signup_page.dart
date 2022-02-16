import 'package:etnafes/pages/login_signup/signup_extra_details.dart';
import 'package:etnafes/pages/main_page.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({Key? key}) : super(key: key);

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool _signedUp = false;
  String _signUpEmail = "";
  String _signUpPass = "";

  Duration get loginTime => Duration(milliseconds: 1000);

  Future<String> _authUser(LoginData data) {
    _signedUp = false;
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      String s = await UserManager.loginUser(
          email: data.name, password: data.password);
      print(s);
      return s;
    });
  }

  Future<String> _regUser(LoginData data) {
    _signedUp = true;
    _signUpEmail = data.name;
    _signUpPass = data.password;

    return Future.delayed(loginTime).then((_) async {
      if (await ApiManager.doesMailExist(_signUpEmail)) {
        return "email already exists";
      } else {
        return "";
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: "assets/images/logo_etnafes.png",
      theme: LoginTheme(
        primaryColor: Colors.blue,
        accentColor: Colors.lightBlueAccent,
        errorColor: Colors.deepOrange,
        bodyStyle: TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
      ),
      onLogin: _authUser,
      onSignup: _regUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        _signedUp
            ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SignupExtraInfos(
                  email: _signUpEmail,
                  password: _signUpPass,
                ),
              ))
            : Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MainPage(),
              ));
      },
    );
  }
}
