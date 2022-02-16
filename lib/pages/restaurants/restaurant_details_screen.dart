import 'package:cached_network_image/cached_network_image.dart';
import 'package:etnafes/models/restaurant.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  RestaurantDetailsScreen({Key? key, required this.restaurant})
      : super(key: key);

  final Restaurant restaurant;

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  bool _loadedMap = false;
  late CameraPosition _initialPosition;
  Set<Marker> markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
      zoom: 14.4746,
    );

    markers.add(Marker(
        markerId: const MarkerId("location"),
        position:
            LatLng(widget.restaurant.latitude, widget.restaurant.longitude)));

    setState(() {
      _loadedMap = true;
    });
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

  buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 28.8),
      child: Text(
        widget.restaurant.nom,
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
            children: List.generate(
              widget.restaurant.photos!.length,
              (index) => CachedNetworkImage(
                  imageUrl: widget.restaurant.photos![index],
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
            widget.restaurant.description,
            style: GoogleFonts.lato(fontSize: 70.sp),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        buildPageHeader(),
        buildSinglePack(),
        buildHotelDescription(),
        if (_loadedMap)
          Padding(
            padding: const EdgeInsets.all(10),
            child: buildMap(),
          ),
      ],
    )));
  }
}
