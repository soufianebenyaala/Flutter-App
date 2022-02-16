import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

class AgencyAdminGeneralDetails extends StatefulWidget {
  AgencyAdminGeneralDetails({Key? key}) : super(key: key);

  @override
  _AgencyAdminGeneralDetailsState createState() =>
      _AgencyAdminGeneralDetailsState();
}

class _AgencyAdminGeneralDetailsState extends State<AgencyAdminGeneralDetails> {
  buildNameField() {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(
          "${UserManager.currentUser!.firstname} ${UserManager.currentUser!.lastname}",
          style: GoogleFonts.lato(fontSize: 20),
        ),
        subtitle: Text("Name"));
  }

  buildPresentationField() {
    return ListTile(
        onTap: () {
          buildPresentationPopup();
        },
        leading: const Icon(Icons.present_to_all_outlined),
        title: Text(
          UserManager.admineAgence!.presentation,
          style: GoogleFonts.lato(fontSize: 20),
        ),
        subtitle: const Text("Presentation"));
  }

  buildCard() {
    return GestureDetector(
      onTap: () {
        buildCardPopup();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CachedNetworkImage(
          cacheKey: DateTime.now().toString(),
          imageUrl: ApiManager.filesAddress +
              UserManager.admineAgence!.carteProfessionnelAgence,
        ),
      ),
    );
  }

  buildCardPopup() async {
    await NDialog(
      content: TextButton.icon(
        onPressed: () async {
          XFile? img =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (img != null) {
            updateAgencyCard(img);
          }
        },
        icon: Icon(Icons.image),
        label: Text("Card"),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  updateAgencyCard(XFile? img) async {
    await UserManager.updateAgencyCard(img);
    Navigator.pop(context);
    setState(() {});
  }

  buildPresentationPopup() async {
    String presentation = "";
    await NDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
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
          TextButton.icon(
            onPressed: () {
              handlePresentationUpdate(presentation);
            },
            icon: Icon(Icons.update),
            label: Text("Change"),
          ),
        ],
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  handlePresentationUpdate(String pres) async {
    if (pres.isEmpty) {
      Fluttertoast.showToast(msg: "Empty text");
      return;
    }
    await UserManager.updateAgencyPresentation(pres);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildNameField(),
        buildPresentationField(),
        buildCard(),
      ],
    );
  }
}
