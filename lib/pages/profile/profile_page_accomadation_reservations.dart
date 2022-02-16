import 'package:etnafes/models/accomadation_reservation_model.dart';
import 'package:etnafes/pages/profile/update_reservation.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';

class ProfilePageAccomadationsReservations extends StatefulWidget {
  const ProfilePageAccomadationsReservations({Key? key}) : super(key: key);

  @override
  _ProfilePageAccomadationsReservationsState createState() =>
      _ProfilePageAccomadationsReservationsState();
}

class _ProfilePageAccomadationsReservationsState
    extends State<ProfilePageAccomadationsReservations> {
  List<AccomadationReservationData>? userReservations;

  bool _loadedReservations = false;

  @override
  void initState() {
    super.initState();
    fetchUserReservations();
  }

  fetchUserReservations() async {
    userReservations = await UserManager.getUserAccomadationReservation(
        UserManager.currentUser!.id);

    setState(() {
      _loadedReservations = true;
    });
  }

  buildSingleReservation(AccomadationReservationData reservation) {
    return GestureDetector(
      onTap: () {
        buildReservationPopup(reservation);
      },
      child: ListTile(
        title: Text(reservation.accomadation!.nom),
        subtitle: Text(
            DateFormat('yyyy-MM-dd – kk:mm').format(reservation.createdAt!)),
        leading: const Icon(Icons.hotel),
        trailing: Icon(Icons.check,
            color: reservation.canceled == 0 ? Colors.green : Colors.red),
      ),
    );
  }

  buildReservationPopup(AccomadationReservationData reservation) async {
    await NDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(reservation.accomadation!.nom,
                  style: GoogleFonts.lato(fontSize: 100.sp)),
              const Divider(),
              Text(
                  "${LocalizationsManager.getAdultLabel(context)} : ${reservation.nbrAdults}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getKidLess4Label(context)}: ${reservation.nbrChildrenUnder4}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getKidMore4Label(context)} : ${reservation.nbrChildrenOver4}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getStartDateLabel(context)} : ${reservation.startDate}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getEndDateLabel(context)} : ${reservation.endDate}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
              Text(
                  "${LocalizationsManager.getPaymentMethodeLabel(context)} : ${reservation.payment}",
                  style: GoogleFonts.lato(fontSize: 50.sp)),
            ],
          ),
        ),
      ),
      actions: reservation.canceled == 0
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
                          ReservationUpdate(reservation: reservation),
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

  List<Widget> buildUserReservations() {
    List<Widget> reservs = [];
    for (var element in userReservations!) {
      reservs.add(buildSingleReservation(element));
    }
    return reservs;
  }

  confirmCancelPopup(AccomadationReservationData reservation) async {
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

  cancelReservation(AccomadationReservationData reservation) async {
    Navigator.pop(context);
    Navigator.pop(context);
    context.loaderOverlay.show();
    var r = await UserManager.cancelReservation(reservation);
    if (r) {
      setState(() {
        _loadedReservations = false;
        fetchUserReservations();
      });
      context.loaderOverlay.hide();
    }
    context.loaderOverlay.hide();
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
