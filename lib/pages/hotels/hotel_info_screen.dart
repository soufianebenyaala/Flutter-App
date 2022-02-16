import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colours/colours.dart';
import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/models/recommended_model.dart';
import 'package:etnafes/pages/booking/hotel_booking.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HotelInfoScreen extends StatefulWidget {
  const HotelInfoScreen({Key? key, required this.hebergement})
      : super(key: key);

  final Hebergement hebergement;

  @override
  _HotelInfoScreenState createState() => _HotelInfoScreenState();
}

class _HotelInfoScreenState extends State<HotelInfoScreen> {
  final _selectedHotelImagesPageController = PageController();

  bool _showHeart = false;

  buildImagesView() {
    return PageView(
      controller: _selectedHotelImagesPageController,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        widget.hebergement.photos!.length,
        (index) => CachedNetworkImage(
          imageUrl: widget.hebergement.photos![index],
          fit: BoxFit.cover,
          placeholder: (context, url) => const LoaderOverlay(
            child: Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              LottieWidget.errorLoadingImage(),
        ),
      ),
    );
  }

  buildCustomButtons() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 28.8, left: 28.8, right: 28.8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 200.sp,
                    width: 200.sp,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.6),
                        color: Colours.grey.shade900.withOpacity(0.4)),
                    child: SvgPicture.asset("assets/svg/icon_left_arrow.svg"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _selectedHotelImagesPageController,
                  count: widget.hebergement.photos!.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFF8a8a8a),
                    dotColor: Color(0xFFababab),
                    dotHeight: 4.8,
                    dotWidth: 6,
                    spacing: 4.8,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      popupContent();
                    },
                    icon: const Icon(
                      Icons.info,
                      color: Colours.white,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  popupContent() async {
    await NDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.sp),
                child: Text(
                  widget.hebergement.nom,
                  maxLines: 2,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 100.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 19.2),
                child: Text(
                  widget.hebergement.description,
                  maxLines: 3,
                  style: GoogleFonts.lato(
                    fontSize: 19.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 50.sp),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          LocalizationsManager.getHotelInfoPrice(context),
                          style: GoogleFonts.lato(
                            fontSize: 100.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 50.sp),
                        Text(
                          "${LocalizationsManager.getAdultLabel(context)} : ${widget.hebergement.prixAdulte.toString()} ${LocalizationsManager.getHotelInfoPriceCurrency(context)}",
                          style: GoogleFonts.lato(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 50.sp),
                        Text(
                          "${LocalizationsManager.getKidLess4Label(context)} : ${widget.hebergement.prixEnfantMoin4.toString()} ${LocalizationsManager.getHotelInfoPriceCurrency(context)}",
                          style: GoogleFonts.lato(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 50.sp),
                        Text(
                          "${LocalizationsManager.getKidMore4Label(context)} : ${widget.hebergement.prixEnfantPlus4.toString()} ${LocalizationsManager.getHotelInfoPriceCurrency(context)}",
                          style: GoogleFonts.lato(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HotelBooking(hebergement: widget.hebergement))),
            icon: Icon(Icons.more),
            label: Text("More info")),
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  buildContent() {
    return Container(
      padding: EdgeInsets.only(top: 1000.sp),
      margin: const EdgeInsets.only(left: 28.8, bottom: 20, right: 28.8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.sp),
                  child: Text(
                    widget.hebergement.nom,
                    maxLines: 2,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 100.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19.2),
                  child: Text(
                    widget.hebergement.description,
                    maxLines: 3,
                    style: GoogleFonts.lato(
                      fontSize: 19.2,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 60.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          LocalizationsManager.getHotelInfoPrice(context),
                          style: GoogleFonts.lato(
                            fontSize: 100.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${widget.hebergement.prixAdulte.toString()} (${LocalizationsManager.getAdultLabel(context)}) ${LocalizationsManager.getHotelInfoPriceCurrency(context)}",
                          style: GoogleFonts.lato(
                            fontSize: 100.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 60.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 170.sp,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.6),
                        color: Colors.white,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HotelBooking(
                                        hebergement: widget.hebergement))),
                            icon: const Icon(Icons.more),
                            label: const Text("More info")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //Images page view
          buildImagesView(),
          // Custom buttons
          buildCustomButtons(),
          //Content
          buildContent(),
        ],
      ),
    );
  }
}
