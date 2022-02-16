import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/models/pack.dart';
import 'package:etnafes/models/recommended_model.dart';
import 'package:etnafes/pages/packs/single_pack.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PacksScreen extends StatefulWidget {
  PacksScreen({Key? key}) : super(key: key);

  @override
  _PacksScreenState createState() => _PacksScreenState();
}

class _PacksScreenState extends State<PacksScreen> {
  final _textController = TextEditingController();
  String currentSearch = "";
  PageController _featuredAgenciesController = PageController();

  List<Pack> allPacks = [];
  bool _fetchedAllPacks = false;
  @override
  void initState() {
    super.initState();
    _textController.addListener((handleSearchInputChange));
    fetchAllPacks();
  }

  fetchAllPacks() async {
    allPacks = await ApiManager.getAllPacks();
    setState(() {
      _fetchedAllPacks = true;
    });
  }

  handleSearchInputChange() {
    setState(() {
      currentSearch = _textController.text;
    });
  }

  buildNavigationAndSearchBar() {
    return Container(
      height: 57.6,
      margin: EdgeInsets.only(top: 28.8, left: 28.8, right: 28.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimSearchBar(
            width: MediaQuery.of(context).size.width * 0.8,
            color: Theme.of(context).primaryColor,
            textController: _textController,
            style: GoogleFonts.lato(fontSize: 22, color: Colors.white),
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
        ],
      ),
    );
  }

  buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 48, left: 28.8),
      child: Text(
        "Packs",
        style: GoogleFonts.playfairDisplay(
            fontSize: 45.6, fontWeight: FontWeight.w700),
      ),
    );
  }

  //Featured

  buildFeaturedPacksText() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8, right: 28.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Featured",
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildFeaturedTabs() {
    return Container(
      height: 218.4,
      margin: EdgeInsets.only(top: 16),
      child: PageView(
        physics: BouncingScrollPhysics(),
        controller: _featuredAgenciesController,
        scrollDirection: Axis.horizontal,
        children: List.generate(
          allPacks.length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SinglePackPage(pack: allPacks[index])));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 28.8, left: 10),
              width: 333.6,
              height: 218.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.6),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(ApiManager.filesAddress +
                        allPacks[index].photoCoverture!),
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
                          padding:
                              const EdgeInsets.only(left: 16.72, right: 14.4),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/svg/icon_location.svg'),
                              SizedBox(width: 9),
                              Text(
                                allPacks[index].titre,
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

  buildDotsIndicator() {
    return Padding(
      padding: EdgeInsets.only(left: 28.8, top: 28.8),
      child: SmoothPageIndicator(
        controller: _featuredAgenciesController,
        count: recommendations.length,
        effect: ExpandingDotsEffect(
          activeDotColor: Color(0xFF8a8a8a),
          dotColor: Color(0xFFababab),
          dotHeight: 4.8,
          dotWidth: 6,
          spacing: 4.8,
        ),
      ),
    );
  }

  //All pack

  buildAllPacksText() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8, right: 28.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "All packs",
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildSinglePack(Pack p) {
    List<Widget> imgsWidgets = [];
    Color txtColor = Colors.white;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SinglePackPage(pack: p)));
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
                  children: [
                    Container(
                      child: CachedNetworkImage(
                          imageUrl: ApiManager.filesAddress + p.photoCoverture!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return LottieWidget.loadingPaperplaneAnimation();
                          },
                          errorWidget: (context, url, error) {
                            return LottieWidget.errorLoadingImage();
                          }),
                    ),
                  ]),
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
                            p.titre,
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

  buildAllPacks() {
    List<Widget> lst = [];
    for (var item in allPacks) {
      lst.add(buildSinglePack(item));
    }
    return lst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            buildNavigationAndSearchBar(),
            buildTitle(),
            //Featured packs
            buildFeaturedPacksText(),
            buildFeaturedTabs(),
            buildDotsIndicator(),
            // All packs
            buildAllPacksText(),
            ...buildAllPacks(),
          ],
        ),
      ),
    );
  }
}
