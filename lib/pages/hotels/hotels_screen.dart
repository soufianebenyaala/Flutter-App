import 'dart:math';
import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/constants/constants.dart';
import 'package:etnafes/models/beach_model.dart';
import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/models/popular_model.dart';
import 'package:etnafes/models/recommended_model.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/widgets/custom_tab_indicator.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';
import 'package:quiver/collection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'hotel_info_screen.dart';

class HotelsScreen extends StatefulWidget {
  HotelsScreen({Key? key}) : super(key: key);

  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final _topHotelsListController = PageController(viewportFraction: 0.877);
  final _recentHotelsController = PageController(viewportFraction: 0.877);
  final _textController = TextEditingController();

  List<Hebergement> recentHebergements = [];
  List<Hebergement> allAccomadations = [];
  List<Hebergement> onScreenAccomadations = [];

  String currentSearch = "";

  String? currentCategory;
  bool _loadedAccomadations = false;
  bool _loadedOnScreenAccomadations = false;

  List<Widget> searchWidgets = [];
  bool _searchingForItems = true;
  @override
  void initState() {
    super.initState();
    _textController.addListener((handleSearchInputChange));

    fetchAccomadations();
  }

  handleSearchInputChange() async {
    setState(() {
      currentSearch = _textController.text;
      _searchingForItems = true;
    });
    var rslt = await ApiManager.getSearchedAccomadations(currentSearch);
    await buildSearchResults(rslt);
    setState(() {
      _searchingForItems = false;
    });
  }

  buildSearchResults(List<Hebergement> lst) async {
    searchWidgets = [];
    for (int i = 0; i < lst.length; i++) {
      searchWidgets.add(ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HotelInfoScreen(hebergement: lst[i])));
        },
        leading: Icon(Icons.hotel),
        title: Text(lst[i].nom),
      ));
    }
  }

  fetchAccomadations() async {
    _loadedAccomadations = false;

    var acc = await ApiManager.getAllAcoomadations();

    setState(() {
      recentHebergements = acc.sublist(0, acc.length > 10 ? 10 : acc.length);
      allAccomadations = acc;
      onScreenAccomadations = acc;
      _loadedAccomadations = true;
      _loadedOnScreenAccomadations = true;
    });
  }

  buildNavigationAndSearchBar() {
    return Container(
      height: 57.6,
      margin: EdgeInsets.only(top: 28.8, left: 28.8, right: 28.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimSearchBar(
            width: MediaQuery.of(context).size.width * 0.6,
            color: Theme.of(context).primaryColor,
            textController: _textController,
            style: GoogleFonts.lato(fontSize: 60.sp, color: Colors.white),
            helpText: LocalizationsManager.getHotelsSearchLabel(context),
            autoFocus: true,
            onSuffixTap: () {
              setState(
                () {
                  _textController.clear();
                },
              );
            },
          ),
          /*  GestureDetector(
            onTap: () {
              buildFiltersDialogue();
            },
            child: Container(
              height: 200.sp,
              width: 200.sp,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.6),
                  color: Theme.of(context).primaryColor),
              child: SvgPicture.asset("assets/svg/icon_drawer.svg"),
            ),
          ),*/
        ],
      ),
    );
  }

  buildSearchPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${LocalizationsManager.getHotelsCurrentSearchLabel(context)} : $currentSearch",
          style: GoogleFonts.lato(fontSize: 22),
        ),
        if (_searchingForItems) LottieWidget.searchLoading(),
        if (!_searchingForItems && searchWidgets.isNotEmpty) ...searchWidgets,
        if (!_searchingForItems && searchWidgets.isEmpty)
          LottieWidget.noItemsAnimation(),
      ],
    );
  }

  buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 48, left: 28.8),
      child: Text(
        LocalizationsManager.getAccomadationsLabel(context),
        style: GoogleFonts.playfairDisplay(
            fontSize: 100.sp, fontWeight: FontWeight.w700),
      ),
    );
  }

  buildSingleAccomadation(Hebergement h) {
    Color txtColor = Colors.white;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HotelInfoScreen(hebergement: h)));
      },
      child: Container(
          height: 218.4,
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              PageView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                dragStartBehavior: DragStartBehavior.start,
                children: List.generate(
                  h.photos!.length,
                  (index) => Container(
                    child: CachedNetworkImage(
                        imageUrl: h.photos![index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return LottieWidget.loadingPaperplaneAnimation();
                        },
                        errorWidget: (context, url, error) {
                          return LottieWidget.errorLoadingImage();
                        }),
                  ),
                ),
              ),
              Positioned(
                bottom: 19.2,
                left: 19.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaY: 19.2,
                      sigmaX: 19.2,
                    ),
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.only(left: 16.72, right: 14.4),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/icon_location.svg'),
                          SizedBox(width: 9),
                          Text(
                            h.nom,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              color: txtColor,
                              fontSize: 16.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  buildAllAccomadations() {
    List<Widget> lst = [];
    for (var item in onScreenAccomadations) {
      lst.add(buildSingleAccomadation(item));
    }
    if (lst.isEmpty) {
      return [LottieWidget.noItemsAnimation()];
    }
    return lst;
  }

  handleCategorieChanges() async {
    setState(() {
      _loadedOnScreenAccomadations = false;
    });
    if (currentCategory == null) {
      setState(() {
        onScreenAccomadations = allAccomadations;
        _loadedOnScreenAccomadations = true;
      });
    } else {
      var acc =
          await ApiManager.getAllAccomadationsWithCategory(currentCategory!);

      setState(() {
        onScreenAccomadations = acc;
        _loadedOnScreenAccomadations = true;
      });
    }
  }

  buildRecentHotelsText() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8, right: 28.8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              LocalizationsManager.getAccomadationsLabel(context),
              style: GoogleFonts.playfairDisplay(
                fontSize: 80.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              LocalizationsManager.getHotelsShowAll(context),
              style: GoogleFonts.lato(
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
    );
  }

  buildRecentHotels() {
    return Container(
      height: 600.sp,
      margin: EdgeInsets.only(top: 16),
      child: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _recentHotelsController,
        children: List.generate(
          recentHebergements.length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelInfoScreen(
                    hebergement: recentHebergements[index],
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 28.8),
              width: 400.sp,
              height: 200.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.6),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(ApiManager.filesAddress +
                        (recentHebergements[index].photoCoverture ?? "")),
                    fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 19.2,
                    left: 19.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 19.2,
                          sigmaX: 19.2,
                        ),
                        child: Container(
                          height: 36,
                          padding: EdgeInsets.only(left: 16.72, right: 14.4),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/svg/icon_location.svg'),
                              SizedBox(width: 9),
                              Text(
                                recentHebergements[index].nom,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 16.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildAttractionsText() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8, right: 28.8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              LocalizationsManager.getCategoriesLabel(context),
              style: GoogleFonts.playfairDisplay(
                fontSize: 50.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (currentCategory != null)
              Text(
                currentCategory!,
                style: GoogleFonts.lato(
                  fontSize: 16.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  currentCategory = null;
                  handleCategorieChanges();
                });
              },
              child: Text(
                LocalizationsManager.getClearLabel(context),
                style: GoogleFonts.lato(
                  fontSize: 16.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]),
    );
  }

  buildAttractionsCategory() {
    return Container(
      margin: EdgeInsets.only(top: 33.6),
      height: 45.6,
      child: ListView.builder(
        itemCount: Constants.categories.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 28.8, right: 9.6),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 19.2),
            height: 45.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.6),
              color: Color(categoriesColors[Random().nextInt(4)]),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentCategory = Constants.categories[index];
                  handleCategorieChanges();
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 19.2),
                  Text(Constants.categories[index]),
                  SizedBox(width: 19.2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> handlePageItems() {
    if (currentSearch == "") {
      return <Widget>[
        // buildCustomTabBar(),
        buildRecentHotels(),
        buildAttractionsText(),
        buildAttractionsCategory(),
        if (_loadedOnScreenAccomadations) ...buildAllAccomadations(),
        if (!_loadedOnScreenAccomadations) LottieWidget.searchLoading(),
        //  buildDotsIndicator(),
        // buildRecentHotelsText(),

        SizedBox(height: 200.sp),
      ];
    } else {
      return <Widget>[buildSearchPage()];
    }
  }

  DateTime? startDate;
  DateTime? endDate;
  buildFiltersDialogue() async {
    await NDialog(
      title: Text("Filters"),
      content: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Start date"),
                  IconButton(
                      onPressed: () async {
                        startDate = await displayTimePicker();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.calendar_today)),
                  startDate == null
                      ? Text("None")
                      : Text(
                          "${startDate!.year}-${startDate!.month}-${startDate!.day}"),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("End date"),
                  IconButton(
                      onPressed: () async {
                        endDate = await displayTimePicker();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.calendar_today)),
                  endDate == null
                      ? Text("None")
                      : Text(
                          "${endDate!.year}-${endDate!.month}-${endDate!.day}"),
                ],
              ),
            ],
          ),
        ),
      ),
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  Future<DateTime?> displayTimePicker() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime(2020, 11, 17),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          //Navigation and search button
          buildNavigationAndSearchBar(),
          //Title
          buildTitle(),
          if (_loadedAccomadations)
            //Custom tab bar
            ...handlePageItems(),
          if (!_loadedAccomadations) LottieWidget.searchLoading(),
        ],
      )),
    );
  }
}
