import 'package:etnafes/models/pack.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class AgencyMyPacks extends StatefulWidget {
  AgencyMyPacks({Key? key}) : super(key: key);

  @override
  _AgencyMyPacksState createState() => _AgencyMyPacksState();
}

class _AgencyMyPacksState extends State<AgencyMyPacks> {
  bool _loadedPacks = false;
  List<Pack> myPacks = [];

  @override
  void initState() {
    super.initState();
    fetchUserPacks();
  }

  fetchUserPacks() async {
    _loadedPacks = false;
    myPacks = await UserManager.getAgencyAdminPacks();
    setState(() {
      _loadedPacks = true;
    });
  }

  buildAllPacks() {
    List<Widget> lst = [];
    for (var item in myPacks) {
      lst.add(GestureDetector(
        onTap: () {
          packPopup(item);
        },
        child: ListTile(
          title: Text(item.titre),
          subtitle: Text(item.dateDebut + " | " + item.dateFin),
        ),
      ));
    }
    if (lst.isEmpty) {
      return [LottieWidget.noItemsAnimation()];
    }
    return lst;
  }

  packPopup(Pack pack) async {
    await NDialog(
      title: Text(pack.titre),
      content: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Description : " + pack.description),
            SizedBox(height: 10),
            Text(pack.dateDebut + " | " + pack.dateFin),
          ],
        ),
      )),
      actions: [
        TextButton.icon(
          onPressed: () {
            handlePackRemove(pack);
          },
          icon: Icon(Icons.remove_circle, color: Colors.red),
          label: Text(
            "Supprimer",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  handlePackRemove(Pack pack) async {
    var r = await UserManager.removePack(pack);
    if (r) {
      Navigator.pop(context);
      fetchUserPacks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            if (_loadedPacks) ...buildAllPacks(),
          ],
        ),
      ),
    );
  }
}
