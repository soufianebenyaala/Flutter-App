import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/constants/constants.dart';
import 'package:etnafes/models/accomadation_reservation_model.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';

class ReservationUpdate extends StatefulWidget {
  ReservationUpdate({Key? key, required this.reservation}) : super(key: key);

  final AccomadationReservationData reservation;

  @override
  _ReservationUpdateState createState() => _ReservationUpdateState();
}

class _ReservationUpdateState extends State<ReservationUpdate> {
  DateTime? startDate;
  DateTime? endDate;

  bool _loadedMap = false;
  late CameraPosition _initialPosition;

  Set<Marker> markers = <Marker>{};

  String paymentType = "Direct";

  double finalPrice = 0.0;

  int totalPlaces = 10;
  int selectedPlaces = 0;

  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _childrenLess4Controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _adultsController.text = widget.reservation.nbrAdults.toString();
    _childrenController.text = widget.reservation.nbrChildrenOver4.toString();
    _childrenLess4Controller.text =
        widget.reservation.nbrChildrenUnder4.toString();
    totalPlaces = widget.reservation.accomadation!.nbrPlacesDisp;

    _initialPosition = CameraPosition(
      target: LatLng(widget.reservation.accomadation!.latitude,
          widget.reservation.accomadation!.longitude),
      zoom: 14.4746,
    );

    markers.add(Marker(
        markerId: const MarkerId("location"),
        position: LatLng(widget.reservation.accomadation!.latitude,
            widget.reservation.accomadation!.longitude)));

    setState(() {
      _loadedMap = true;
    });
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
            children: List.generate(
              widget.reservation.accomadation!.photos!.length,
              (index) => CachedNetworkImage(
                  imageUrl: widget.reservation.accomadation!.photos![index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return LottieWidget.loadingPaperplaneAnimation();
                  },
                  errorWidget: (context, url, error) {
                    return LottieWidget.errorLoadingImage();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  buildHotelDescription() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
          child: Text(
            widget.reservation.accomadation!.description,
            style: GoogleFonts.lato(fontSize: 70.sp),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
          child: Text(
            widget.reservation.accomadation!.adresse,
            style: GoogleFonts.lato(fontSize: 50.sp),
          ),
        ),
      ],
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

  buildEndDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () async {
              endDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)));
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(LocalizationsManager.getEndDateLabel(context))),
        endDate != null
            ? Text("${endDate!.year} - ${endDate!.month} -${endDate!.day} ")
            : Text(LocalizationsManager.getEndDateLabel(context)),
      ],
    );
  }

  buildMap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {},
          markers: markers,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          mapType: MapType.hybrid,
          initialCameraPosition: _initialPosition,
        ),
      ),
    );
  }

  updatePrice() {
    setState(() {
      finalPrice = double.parse(_childrenLess4Controller.text) *
              widget.reservation.accomadation!.prixEnfantMoin4 +
          double.parse(_childrenController.text) *
              widget.reservation.accomadation!.prixEnfantPlus4 +
          double.parse(_adultsController.text) *
              widget.reservation.accomadation!.prixAdulte;
    });
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
                  updatePrice();
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
                  if (selectedPlaces < totalPlaces) {
                    int currVal = int.parse(currentController.text);
                    currVal++;
                    selectedPlaces++;
                    setState(() {
                      currentController.text = currVal.toString();
                    });
                    updatePrice();
                  } else {
                    Fluttertoast.showToast(
                        msg: LocalizationsManager.getAccomadationFullLabel(
                            context));
                  }
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

  buildFinalPriceLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocalizationsManager.getHotelInfoPrice(context),
          style: GoogleFonts.lato(
            fontSize: 16.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "${finalPrice.toString()} ${LocalizationsManager.getHotelInfoPriceCurrency(context)}",
          style: GoogleFonts.lato(
            fontSize: 21.6,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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

  handleUpdate() async {
    AccomadationReservationData reservation = AccomadationReservationData(
      accomadationId: widget.reservation.accomadationId,
      canceled: widget.reservation.canceled,
      nbrAdults: int.parse(_adultsController.text),
      nbrChildrenOver4: int.parse(_childrenController.text),
      nbrChildrenUnder4: int.parse(_childrenLess4Controller.text),
      payment: paymentType,
      startDate: "${startDate!.year}-${startDate!.month}-${startDate!.day}",
      endDate: "${endDate!.year}-${endDate!.month}-${endDate!.day}",
      nbrPlaces: selectedPlaces,
      id: widget.reservation.id,
    );

    var r = await UserManager.updateReservaion(reservation);

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
            const SizedBox(height: 10),
            buildSinglePack(),
            buildHotelDescription(),
            const Divider(),
            if (_loadedMap)
              Padding(
                padding: const EdgeInsets.all(10),
                child: buildMap(),
              ),
            const Divider(),
            buildStartDatePicker(),
            buildEndDatePicker(),
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
            buildFinalPriceLabel(),
            buildUpdateButton(),
          ],
        ),
      ),
    );
  }
}
