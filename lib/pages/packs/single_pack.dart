import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/constants/constants.dart';
import 'package:etnafes/models/pack.dart';
import 'package:etnafes/models/pack_reservation.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';

class SinglePackPage extends StatefulWidget {
  SinglePackPage({Key? key, required this.pack}) : super(key: key);

  Pack pack;

  @override
  _SinglePackPageState createState() => _SinglePackPageState();
}

class _SinglePackPageState extends State<SinglePackPage> {
  int selectedPlaces = 0;

  DateTime? startDate;

  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _childrenLess4Controller =
      TextEditingController();

  String paymentType = "Direct";

  @override
  void initState() {
    super.initState();
    _adultsController.text = "0";
    _childrenController.text = "0";
    _childrenLess4Controller.text = "0";
  }

  buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8),
      child: Text(
        widget.pack.titre,
        style: GoogleFonts.playfairDisplay(
            fontSize: 45.6, fontWeight: FontWeight.w700),
      ),
    );
  }

  buildSinglePack() {
    return Container(
      height: 800.sp,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          PageView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              dragStartBehavior: DragStartBehavior.start,
              children: [
                CachedNetworkImage(
                    imageUrl:
                        ApiManager.filesAddress + widget.pack.photoCoverture!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return LottieWidget.loadingPaperplaneAnimation();
                    },
                    errorWidget: (context, url, error) {
                      return LottieWidget.errorLoadingImage();
                    }),
              ]),
        ],
      ),
    );
  }

  buildPackDescription() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
          child: Text(
            widget.pack.description,
            style: GoogleFonts.lato(fontSize: 70.sp),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
          child: Text(
            "Adrenaline : " + widget.pack.adrenaline.toString(),
            style: GoogleFonts.lato(fontSize: 50.sp),
          ),
        ),
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

  buildBookButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 15),
      child: OutlinedButton.icon(
        onPressed: () {
          handlPackReservation();
        },
        icon: const Icon(Icons.check),
        label: Text(
          LocalizationsManager.getBookingLabel(context),
        ),
      ),
    );
  }

  handlPackReservation() async {
    if (startDate == null) {
      Fluttertoast.showToast(
          msg: LocalizationsManager.getInvalidDateChoice(context));
      return;
    }
    if (selectedPlaces == 0) {
      Fluttertoast.showToast(
          msg: LocalizationsManager.getInvalidNumberOfPeople(context));
      return;
    }

    PackReservation p = PackReservation(
      agenceId: widget.pack.adminAgenceId,
      annule: 0,
      date: "${startDate!.year}-${startDate!.month}-${startDate!.day}",
      nbrEnfantMoin4: int.parse(_childrenLess4Controller.text),
      nbrEnfantPlus4: int.parse(_childrenController.text),
      nbrPlaces: selectedPlaces,
      nbrAdultes: int.parse(_adultsController.text),
      packId: widget.pack.id!,
      paye: paymentType,
      userId: UserManager.currentUser!.id,
    );

    context.loaderOverlay.show();
    bool r = await UserManager.reservePack(p);
    context.loaderOverlay.hide();

    await NDialog(
      title: Text(r
          ? LocalizationsManager.getBookingSuccessLabel(context)
          : LocalizationsManager.getBookingFailedLabel(context)),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: r
            ? LottieWidget.successAnimation()
            : LottieWidget.failedAnimation(),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildPageHeader(),
              buildSinglePack(),
              buildPackDescription(),
              const Divider(),
              buildStartDatePicker(),
              const Divider(),
              buildNumberInputRow(
                  LocalizationsManager.getKidLess4Label(context),
                  _childrenLess4Controller),
              buildNumberInputRow(
                  LocalizationsManager.getKidMore4Label(context),
                  _childrenController),
              buildNumberInputRow(LocalizationsManager.getAdultLabel(context),
                  _adultsController),
              const SizedBox(height: 10),
              buildPaymentDropDown(),
              const SizedBox(height: 10),
              buildBookButton(),
            ],
          ),
        ),
      ),
    );
  }
}
