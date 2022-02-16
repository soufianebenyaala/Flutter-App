import 'package:etnafes/constants/constants.dart';
import 'package:etnafes/models/pack_reservation.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';

class UpdatePackReservation extends StatefulWidget {
  UpdatePackReservation({Key? key, required this.reservation})
      : super(key: key);
  PackReservation reservation;
  @override
  _UpdatePackReservationState createState() => _UpdatePackReservationState();
}

class _UpdatePackReservationState extends State<UpdatePackReservation> {
  DateTime? startDate;
  int selectedPlaces = 0;

  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _childrenLess4Controller =
      TextEditingController();
  String paymentType = "Direct";

  @override
  void initState() {
    super.initState();
    _adultsController.text = widget.reservation.nbrAdultes.toString();
    _childrenController.text = widget.reservation.nbrEnfantPlus4.toString();
    _childrenLess4Controller.text =
        widget.reservation.nbrEnfantMoin4.toString();
  }

  buildStartDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () async {
              startDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)));
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(LocalizationsManager.getStartDateLabel(context))),
        startDate != null
            ? Text(
                "${startDate!.year} - ${startDate!.month} -${startDate!.day} ")
            : Text(LocalizationsManager.getStartDateLabel(context)),
      ],
    );
  }

  buildNumberInputRow(String title, TextEditingController currentController) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(fontSize: 17),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  int currVal = int.parse(currentController.text);
                  if (currVal > 0) {
                    currVal--;
                    selectedPlaces--;
                  }
                  setState(() {
                    currentController.text = currVal.toString();
                  });
                },
                icon: const Icon(Icons.arrow_circle_down),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  controller: currentController,
                  inputFormatters: <TextInputFormatter>[
                    // ignore: deprecated_member_use
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  int currVal = int.parse(currentController.text);
                  currVal++;
                  selectedPlaces++;
                  setState(() {
                    currentController.text = currVal.toString();
                  });
                },
                icon: const Icon(Icons.arrow_circle_up),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildPaymentDropDown() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "${LocalizationsManager.getPaymentMethodeLabel(context)} : ",
            style: GoogleFonts.lato(fontSize: 15),
          ),
          DropdownButton(
            onChanged: (String? newValue) {
              setState(() {
                paymentType = newValue!;
              });
            },
            items: Constants.paymentTypes.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8),
      child: Text(
        LocalizationsManager.getUpdateLabel(context),
        style: GoogleFonts.playfairDisplay(
            fontSize: 45.6, fontWeight: FontWeight.w700),
      ),
    );
  }

  buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 15),
      child: OutlinedButton.icon(
        onPressed: () {
          handleUpdate();
        },
        icon: const Icon(Icons.check),
        label: Text(
          LocalizationsManager.getUpdateLabel(context),
        ),
      ),
    );
  }

  handleUpdate() async {
    PackReservation reservation = widget.reservation;
    reservation = PackReservation(
      id: widget.reservation.id,
      agenceId: widget.reservation.agenceId,
      annule: widget.reservation.annule,
      date: "${startDate!.year}-${startDate!.month}-${startDate!.day}",
      nbrEnfantMoin4: int.parse(_childrenLess4Controller.text),
      nbrEnfantPlus4: int.parse(_childrenController.text),
      nbrPlaces: selectedPlaces,
      nbrAdultes: int.parse(_adultsController.text),
      packId: widget.reservation.packId,
      paye: paymentType,
      userId: widget.reservation.userId,
    );
    var r = await UserManager.updatePackReservation(reservation);

    if (r) {
      showSuccessDialog();
    } else {
      showFailedDialog();
    }
  }

  showSuccessDialog() async {
    await NDialog(
      title: Text(LocalizationsManager.getSuccessLabel(context)),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: LottieWidget.successAnimation(),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  showFailedDialog() async {
    await NDialog(
      title: Text(LocalizationsManager.getFailedLabel(context)),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: LottieWidget.failedAnimation(),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPageHeader(),
            buildStartDatePicker(),
            const Divider(),
            const SizedBox(height: 10),
            buildNumberInputRow(LocalizationsManager.getKidLess4Label(context),
                _childrenLess4Controller),
            buildNumberInputRow(LocalizationsManager.getKidMore4Label(context),
                _childrenController),
            buildNumberInputRow(
                LocalizationsManager.getAdultLabel(context), _adultsController),
            const SizedBox(height: 10),
            const Divider(),
            buildPaymentDropDown(),
            const SizedBox(height: 10),
            buildUpdateButton(),
          ],
        ),
      ),
    );
  }
}
