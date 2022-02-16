import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ndialog/ndialog.dart';

class AccountManagment extends StatefulWidget {
  AccountManagment({Key? key}) : super(key: key);

  @override
  _AccountManagmentState createState() => _AccountManagmentState();
}

class _AccountManagmentState extends State<AccountManagment> {
  String cin = "";
  String codePostal = "";
  String telephone = "";
  String presentation = "";
  XFile? cartePro;

  buildBecomeOwnerButton() {
    return TextButton.icon(
      onPressed: () {
        buildRegisterAsOwnerForm();
      },
      icon: Icon(Icons.hotel),
      label: Text(
        LocalizationsManager.getRegisterAsHotelOwnerLabel(context),
        style: GoogleFonts.lato(
          fontSize: 20,
        ),
      ),
    );
  }

  buildRegisterAsOwnerForm() async {
    await NDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: "Cin",
                      labelText: "Cin : "),
                  onChanged: (val) {
                    cin = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: "Code postal",
                      labelText: "Code postal : "),
                  onChanged: (val) {
                    codePostal = val;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
            onPressed: () {
              submitRegisterForm();
            },
            icon: Icon(LineIcons.checkCircle),
            label: Text("Register"))
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  buildRegisterAsRestaurantOwnerForm() async {
    await NDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: "Cin",
                      labelText: "Cin : "),
                  onChanged: (val) {
                    cin = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: "Telephone",
                      labelText: "Telephone : "),
                  onChanged: (val) {
                    telephone = val;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
            onPressed: () {
              submitRestaurantForm();
            },
            icon: Icon(LineIcons.checkCircle),
            label: Text("Register"))
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  buildBecomeRestaurantOwnerButton() {
    return TextButton.icon(
      onPressed: () {
        buildRegisterAsRestaurantOwnerForm();
      },
      icon: Icon(Icons.restaurant),
      label: Text(
        LocalizationsManager.getRegisterAsRestaurantOwner(context),
        style: GoogleFonts.lato(
          fontSize: 20,
        ),
      ),
    );
  }

  submitRestaurantForm() async {
    bool result =
        await UserManager.registerAsRestaurantOwner(cin: cin, phone: telephone);

    if (!result) {
      Fluttertoast.showToast(msg: "Error occured, please try again later");
    } else {
      Fluttertoast.showToast(msg: "Registered as a hotel owner");
    }
  }

  submitRegisterForm() async {
    bool result =
        await UserManager.registerAsHotelOwner(cin: cin, postCode: codePostal);

    if (!result) {
      Fluttertoast.showToast(msg: "Error occured, please try again later");
    } else {
      Fluttertoast.showToast(msg: "Registered as a hotel owner");
    }
  }

  buildAlreadyHotelOwner() {
    return Column(
      children: [
        Container(
          height: 500.sp,
          child: LottieWidget.breifCaseAnimation(),
        ),
        Text(LocalizationsManager.getAlreadyHotelOwnerLabel(context),
            style: GoogleFonts.lato()),
      ],
    );
  }

  buildAlreadyRestaurantOwner() {
    return Column(
      children: [
        Container(
          height: 500.sp,
          child: LottieWidget.breifCaseAnimation(),
        ),
        Text(LocalizationsManager.getAlreadyRestaurantOwnerLabel(context),
            style: GoogleFonts.lato()),
      ],
    );
  }

  buildBecomeAgencyButton() {
    return TextButton.icon(
      onPressed: () {
        registerAsAgencyForm();
      },
      icon: Icon(LineIcons.building),
      label: Text(
        LocalizationsManager.getRegisterAsAgencyOwner(context),
        style: GoogleFonts.lato(
          fontSize: 20,
        ),
      ),
    );
  }

  buildAlreadyAgencyOwner() {
    return Column(
      children: [
        Container(
          height: 500.sp,
          child: LottieWidget.breifCaseAnimation(),
        ),
        Text(LocalizationsManager.getLareadyAgencyOwnerLabel(context),
            style: GoogleFonts.lato()),
      ],
    );
  }

  registerAsAgencyForm() async {
    await NDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: "presentation",
                      labelText: "presentation : "),
                  onChanged: (val) {
                    presentation = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: () async {
                    cartePro = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("carte professionnel"),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
            onPressed: () {
              submitRegisterAsAgency();
            },
            icon: const Icon(LineIcons.checkCircle),
            label: const Text("Register"))
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  submitRegisterAsAgency() async {
    if (cartePro == null) {
      Fluttertoast.showToast(msg: "No image");
      return;
    }
    bool result = await UserManager.registerAsAgencyOwner(
        carte: cartePro!, presentation: presentation);

    if (!result) {
      Fluttertoast.showToast(msg: "Error occured, please try again later");
    } else {
      Fluttertoast.showToast(msg: "Registered as a agency owner");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserManager.proprietaire == null
            ? buildBecomeOwnerButton()
            : buildAlreadyHotelOwner(),
        UserManager.proprietaireResto == null
            ? buildBecomeRestaurantOwnerButton()
            : buildAlreadyRestaurantOwner(),
        UserManager.admineAgence == null
            ? buildBecomeAgencyButton()
            : buildAlreadyAgencyOwner(),
      ],
    );
  }
}
