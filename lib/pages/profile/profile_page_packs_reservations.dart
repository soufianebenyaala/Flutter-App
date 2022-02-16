import 'package:etnafes/models/pack_reservation.dart';
import 'package:etnafes/pages/profile/update_pack_reservation.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';

class ProfilePagePacksReservation extends StatefulWidget {
  ProfilePagePacksReservation({Key? key}) : super(key: key);

  @override
  _ProfilePagePacksReservationState createState() =>
      _ProfilePagePacksReservationState();
}

class _ProfilePagePacksReservationState
    extends State<ProfilePagePacksReservation> {
  bool _loadedReservations = false;
  List<PackReservation>? userReservations;

  @override
  void initState() {
    super.initState();
    fetchUserPacksReservations();
  }

  fetchUserPacksReservations() async {
    userReservations = await UserManager.getAllUserPacks();
    setState(() {
      _loadedReservations = true;
    });
  }

  buildSingleReservation(PackReservation reservation) {
    return GestureDetector(
      onTap: () {
        buildReservationPopup(reservation);
      },
      child: ListTile(
        title: Text("Date"),
        subtitle: Text(
          reservation.date,
        ),
        leading: const Icon(Icons.hotel),
        trailing: Icon(Icons.check,
            color: reservation.annule == 0 ? Colors.green : Colors.red),
      ),
    );
  }

  buildReservationPopup(PackReservation reservation) async {
    await NDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Reservation : " + reservation.id.toString(),
                  style: GoogleFonts.lato(fontSize: 100.sp)),
              const Divider(),
              Text(
                  "${LocalizationsManager.getAdultLabel(context)} : ${reservation.nbrAdultes}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getKidLess4Label(context)}: ${reservation.nbrEnfantMoin4}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getKidMore4Label(context)} : ${reservation.nbrEnfantPlus4}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getStartDateLabel(context)} : ${reservation.date}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getPaymentMethodeLabel(context)} : ${reservation.paye}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
            ],
          ),
        ),
      ),
      actions: reservation.annule == 0
          ? [
              TextButton.icon(
                  onPressed: () {
                    confirmCancelPopup(reservation);
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  label: Text(LocalizationsManager.getCancelLabel(context))),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdatePackReservation(reservation: reservation),
                    ),
                  );
                },
                icon: const Icon(Icons.update),
                label: Text(
                  LocalizationsManager.getUpdateLabel(context),
                ),
              ),
            ]
          : [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
              )
            ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  confirmCancelPopup(PackReservation reservation) async {
    await NDialog(
      title:
          Text(LocalizationsManager.getReservationConfirmationLabel(context)),
      actions: [
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.cancel, color: Colors.green),
            label: Text(LocalizationsManager.getCancelLabel(context))),
        TextButton.icon(
            onPressed: () {
              cancelReservation(reservation);
            },
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: Text(LocalizationsManager.getConfirmLabel(context))),
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  cancelReservation(PackReservation reservation) async {
    Navigator.pop(context);
    Navigator.pop(context);
    context.loaderOverlay.show();
    var r = await UserManager.cancelPackReservation(reservation);
    if (r) {
      setState(() {
        _loadedReservations = false;
        fetchUserPacksReservations();
      });
      context.loaderOverlay.hide();
    }
    context.loaderOverlay.hide();
  }

  List<Widget> buildUserReservations() {
    List<Widget> reservs = [];
    for (var element in userReservations!) {
      reservs.add(buildSingleReservation(element));
    }
    return reservs;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: ListView(
        children: [if (_loadedReservations) ...buildUserReservations()],
      ),
    );
  }
}
