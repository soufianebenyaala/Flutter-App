import 'dart:typed_data';

import 'package:circle_flags/circle_flags.dart';
import 'package:etnafes/models/pays.dart';
import 'package:etnafes/models/restaurant.dart';
import 'package:etnafes/models/ville.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:location/location.dart' as locationManager;

class RestaurantOwnerAdd extends StatefulWidget {
  RestaurantOwnerAdd({Key? key}) : super(key: key);

  @override
  _RestaurantOwnerAddState createState() => _RestaurantOwnerAddState();
}

class _RestaurantOwnerAddState extends State<RestaurantOwnerAdd>
    with AutomaticKeepAliveClientMixin {
  String nom = "";
  String description = "";

  double latitude = 0.0;
  double longitude = 0.0;

  int paysId = -1;
  int villeId = -1;

  List<XFile>? photos;

  String countryName = "";
  String cityName = "";
  bool _loadedCountries = false;
  bool _loadedCities = false;
  late List<DropdownMenuItem<Pays>> countries;
  late List<DropdownMenuItem<Ville>> cities;

  bool _serviceEnabled = false;
  locationManager.PermissionStatus _permissionGranted =
      locationManager.PermissionStatus.denied;

  locationManager.Location location = locationManager.Location();

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.person),
            hintText: LocalizationsManager.getNameLabel(context),
            labelText: LocalizationsManager.getNameLabel(context)),
        onChanged: (val) {
          nom = val;
        },
      ),
    );
  }

  buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
      child: TextFormField(
        maxLines: null,
        minLines: null,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.description),
            hintText: LocalizationsManager.getDescriptionLabel(context),
            labelText: LocalizationsManager.getDescriptionLabel(context)),
        onChanged: (val) {
          description = val;
        },
      ),
    );
  }

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  LatLng? currentlyPressed;
  late GoogleMapController _controller;

  String? selectedLocation;
  addCurrentPosMarker() async {
    context.loaderOverlay.show();
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId("Position"),
        position: currentlyPressed!,
      ),
    );
    var loc = (await GeocodingPlatform.instance.placemarkFromCoordinates(
            currentlyPressed!.latitude, currentlyPressed!.longitude))
        .first;
    selectedLocation =
        "${loc.name} - ${loc.locality} - ${loc.administrativeArea} - ${loc.country}";

    setState(() {
      context.loaderOverlay.hide();
    });
  }

  Set<Marker> markers = <Marker>{};

  buildMapLabel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                getCurrentLocation();
              },
              icon: Icon(Icons.location_history),
              label:
                  Text(LocalizationsManager.getCurrentLocationLabel(context)),
            ),
          ],
        ),
        selectedLocation != null
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10, top: 10),
                child: Text(selectedLocation!),
              )
            : Text(LocalizationsManager.getMapHoldHint(context)),
      ],
    );
  }

  buildMap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              getCurrentLocation();
            },
            markers: markers,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            mapType: MapType.hybrid,
            initialCameraPosition: _initialPosition,
            onLongPress: (val) async {
              currentlyPressed = val;
              addCurrentPosMarker();
            }),
      ),
    );
  }

  getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locationManager.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != locationManager.PermissionStatus.granted) {
        return;
      }
    }

    var _locationData = await location.getLocation();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_locationData.latitude!, _locationData.longitude!),
            zoom: 15),
      ),
    );
  }

  fetchCountries() async {
    _loadedCountries = false;
    var ctrs = await ApiManager.getAllCountries();
    countries = [];
    for (var i = 0; i < ctrs.length; i++) {
      countries.add(
        DropdownMenuItem(
          child: ListTile(
            title: Text(ctrs[i].nomGb),
            leading: CircleFlag(
              ctrs[i].alpha2,
              size: 25,
            ),
          ),
          value: ctrs[i],
        ),
      );
    }

    setState(() {
      _loadedCountries = true;
    });
  }

  fetchCities(int countryId) async {
    _loadedCities = false;
    var cts = await ApiManager.getAllCities(countryId);
    cities = [];
    for (var i = 0; i < cts.length; i++) {
      cities.add(
        DropdownMenuItem(
          child: Text(cts[i].nom),
          value: cts[i],
        ),
      );
    }

    setState(() {
      _loadedCities = true;
    });
  }

  transitionToLocation({
    required String locationName,
    double zoomValue = 5,
  }) async {
    var loc =
        await GeocodingPlatform.instance.locationFromAddress(locationName);

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(loc[0].latitude, loc[0].longitude), zoom: zoomValue),
      ),
    );
  }

  buildCountriesDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          Text(countryName),
          DropdownButton(
            items: countries,
            isExpanded: true,
            hint: Text(LocalizationsManager.getCountriesLabel(context)),
            onChanged: (val) {
              transitionToLocation(locationName: (val as Pays).nomGb);

              setState(() {
                paysId = (val as Pays).id;

                countryName = (val as Pays).nomGb;
                fetchCities(paysId);
              });
            },
          ),
        ],
      ),
    );
  }

  buildCitiesDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          Text(cityName),
          DropdownButton(
            isExpanded: true,
            items: cities,
            hint: Text(LocalizationsManager.getCitiesLabel(context)),
            onChanged: (val) {
              transitionToLocation(
                  locationName: (val as Ville).nom, zoomValue: 12);
              setState(() {
                cityName = (val as Ville).nom;
                villeId = (val as Ville).id;
              });
            },
          ),
        ],
      ),
    );
  }

  List<XFile>? images;
  final ImagePicker _picker = ImagePicker();
  buildImagesPicker() {
    return Column(
      children: [
        TextButton.icon(
            onPressed: () async {
              images = await _picker.pickMultiImage();
              setState(() {
                if (images != null) loadCurrentImagePreview();
              });
            },
            icon: Icon(Icons.image),
            label: Text(LocalizationsManager.getImagesLabel(context))),
        ...displayPickedImages(),
      ],
    );
  }

  int currentImagesIndex = 0;
  List<Widget> displayPickedImages() {
    if (_currentlyPreviewedImage != null) {
      return [
        Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: _currentlyPreviewedImage,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: () {
                  if (currentImagesIndex > 0) {
                    setState(() {
                      currentImagesIndex--;

                      loadCurrentImagePreview();
                    });
                  }
                },
                icon: Icon(Icons.skip_previous),
                label: Text(LocalizationsManager.getNextButtonLabel(context))),
            TextButton.icon(
                onPressed: () {
                  if (currentImagesIndex < images!.length - 1) {
                    setState(() {
                      currentImagesIndex++;
                      loadCurrentImagePreview();
                    });
                  }
                },
                icon: Icon(Icons.skip_next),
                label: Text(LocalizationsManager.getPreviousLabel(context))),
          ],
        )
      ];
    } else {
      return [Text("Loading")];
    }
  }

  Image? _currentlyPreviewedImage;
  loadCurrentImagePreview() async {
    Uint8List ints = await images![currentImagesIndex].readAsBytes();
    setState(() {
      _currentlyPreviewedImage = Image.memory(ints);
    });
  }

  handleFormSubmit() async {
    if (nom.isEmpty) {
      Fluttertoast.showToast(msg: "Enter a name");
      return;
    }

    if (description.isEmpty) {
      Fluttertoast.showToast(msg: "Enter a description");
      return;
    }

    Restaurant r = Restaurant(
      description: description,
      latitude: currentlyPressed!.latitude,
      longitude: currentlyPressed!.longitude,
      nom: nom,
      proprietaireId: UserManager.proprietaireResto!.id,
      villeId: villeId,
    );
    print("Adding restaurant");
    await UserManager.addRestaurant(restaurant: r, images: images!);
    print("DOne ! ");
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            buildNameField(),
            buildDescriptionField(),
            Divider(),
            buildImagesPicker(),
            SizedBox(height: 20),
            buildMapLabel(),
            if (_loadedCountries) buildCountriesDropDown(),
            if (_loadedCities) buildCitiesDropDown(),
            buildMap(),
            TextButton.icon(
                onPressed: () {
                  handleFormSubmit();
                },
                icon: Icon(Icons.add),
                label: Text("Add restaurant")),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
