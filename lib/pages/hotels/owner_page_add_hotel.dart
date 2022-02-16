// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:circle_flags/circle_flags.dart';
import 'package:etnafes/constants/constants.dart';
import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/models/pays.dart';
import 'package:etnafes/models/ville.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as locationManager;
import 'package:textfield_tags/textfield_tags.dart';

class OwnerHotelAddPage extends StatefulWidget {
  const OwnerHotelAddPage({Key? key}) : super(key: key);

  @override
  _OwnerHotelAddPageState createState() => _OwnerHotelAddPageState();
}

class _OwnerHotelAddPageState extends State<OwnerHotelAddPage>
    with AutomaticKeepAliveClientMixin {
  String nom = "";
  String description = "";
  String disponibilite = "";
  File? imageCouverture;
  double latitude = 0.0;
  double longitude = 0.0;
  String categorie = "";
  List<File>? photos;
  DateTime? dateDeb;
  DateTime? dateFin;

  int paysId = -1;
  int villeId = -1;

  String countryName = "";
  String cityName = "";
  bool _loadedCountries = false;
  bool _loadedCities = false;
  late List<DropdownMenuItem<Pays>> countries;
  late List<DropdownMenuItem<Ville>> cities;

  final TextEditingController _nbrVoyageursController = TextEditingController();
  final TextEditingController _nbrPlacesDispoController =
      TextEditingController();
  final TextEditingController _nbrChambresDispoController =
      TextEditingController();
  final TextEditingController _chambreIndividuelController =
      TextEditingController();
  final TextEditingController _chambreAdeuxController = TextEditingController();
  final TextEditingController _chambreAtroisController =
      TextEditingController();
  final TextEditingController _prixAdulteController = TextEditingController();
  final TextEditingController _prixEnfantMoin4Controller =
      TextEditingController();
  final TextEditingController _prixEnfantPlus4Controller =
      TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  bool _serviceEnabled = false;
  locationManager.PermissionStatus _permissionGranted =
      locationManager.PermissionStatus.denied;

  locationManager.Location location = locationManager.Location();

  XFile? coverImage;
  Image? _coverPreview;
  List<XFile>? images;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nbrVoyageursController.text = "0";
    _nbrPlacesDispoController.text = "0";
    _nbrChambresDispoController.text = "0";
    _chambreIndividuelController.text = "0";
    _chambreAdeuxController.text = "0";
    _chambreAtroisController.text = "0";
    _prixAdulteController.text = "0";
    _prixEnfantMoin4Controller.text = "0";
    _prixEnfantPlus4Controller.text = "0";

    fetchCountries();
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

  buildNumberInputsFields() {
    return [
      buildNumberInputRow(LocalizationsManager.getNbrTravelersLabel(context),
          _nbrVoyageursController),
      buildNumberInputRow(
          LocalizationsManager.getNbrPlacesAvailableLabel(context),
          _nbrPlacesDispoController),
      buildNumberInputRow(
          LocalizationsManager.getNbrRoomsAvailableLabel(context),
          _nbrChambresDispoController),
      buildNumberInputRow(
          LocalizationsManager.getNbrSingleRoomsAvailableLabel(context),
          _chambreIndividuelController),
      buildNumberInputRow(
          LocalizationsManager.getNbrDoubleRoomsAvailableLabel(context),
          _chambreAdeuxController),
      buildNumberInputRow(
          LocalizationsManager.getNbrRoomsThreeAvailableLabel(context),
          _chambreAtroisController),
      buildNumberInputRow(LocalizationsManager.getAdultPriceLabel(context),
          _prixAdulteController),
      buildNumberInputRow(LocalizationsManager.getChildrenLess4Price(context),
          _prixEnfantMoin4Controller),
      buildNumberInputRow(LocalizationsManager.getChildrenMore4Price(context),
          _prixEnfantPlus4Controller),
    ];
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

  buildDisponibilityField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.person),
          hintText: "Dispo : ",
          labelText: "Dispo",
        ),
        onChanged: (val) {
          disponibilite = val;
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

  buildCategoriesDropDown() {
    return DropdownButton(
      items: Constants.categories.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text(LocalizationsManager.getCategoriesLabel(context)),
      onChanged: (val) {
        setState(() {
          categorie = val.toString();
        });
      },
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
                  if (currVal > 0) currVal--;
                  setState(() {
                    currentController.text = currVal.toString();
                  });
                },
                icon: Icon(Icons.arrow_circle_down),
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
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  int currVal = int.parse(currentController.text);
                  currVal++;
                  setState(() {
                    currentController.text = currVal.toString();
                  });
                },
                icon: Icon(Icons.arrow_circle_up),
              ),
            ],
          )
        ],
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
    _addressController.text = selectedLocation!;

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
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.location_on),
                  ),
                ),
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

  displayPickedCoverImage() {
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: _coverPreview,
      ),
    );
  }

  buildCoverImagePicker() {
    return Column(
      children: [
        TextButton.icon(
            onPressed: () async {
              coverImage = await _picker.pickImage(source: ImageSource.gallery);
              if (coverImage != null) {
                _coverPreview = Image.memory(await coverImage!.readAsBytes());
              } else {
                _coverPreview = null;
              }
              setState(() {});
            },
            icon: Icon(Icons.image),
            label: Text(LocalizationsManager.getCoverPhotoLabel(context))),
        coverImage != null
            ? displayPickedCoverImage()
            : Text("Choose a pic first"),
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

  List<String> options = [];

  buildTagsInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFieldTags(
        tagsStyler: TagsStyler(
            tagTextStyle: TextStyle(fontWeight: FontWeight.normal),
            tagDecoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(0.0),
            ),
            tagCancelIcon:
                Icon(Icons.cancel, size: 18.0, color: Colors.blue[900]),
            tagPadding: const EdgeInsets.all(6.0)),
        textFieldStyler: TextFieldStyler(
            hintText: LocalizationsManager.getOptionsLabel(context),
            helperText: ""),
        onTag: (tag) {
          options.add(tag);
        },
        onDelete: (tag) {
          options.remove(tag);
        },
      ),
    );
  }

  buildLineBreak(String text) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Text(text, style: GoogleFonts.lato(fontSize: 50.sp)),
        Expanded(child: Divider()),
      ],
    );
  }

  buildDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2010, 01, 01),
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3560)),
    );
    return picked;
  }

  buildStartDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () async {
              dateDeb = await buildDatePicker();
              setState(() {});
            },
            icon: Icon(Icons.calendar_today),
            label: Text(LocalizationsManager.getStartDateLabel(context))),
        if (dateDeb != null)
          Text("${dateDeb!.year}/${dateDeb!.month}/${dateDeb!.day}"),
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
              dateFin = await buildDatePicker();
              setState(() {});
            },
            icon: Icon(Icons.calendar_today),
            label: Text(LocalizationsManager.getEndDateLabel(context))),
        if (dateFin != null)
          Text("${dateFin!.year}/${dateFin!.month}/${dateFin!.day}"),
      ],
    );
  }

  handleFormSubmit() async {
    if (nom.isEmpty) {
      Fluttertoast.showToast(msg: "Please add a name");
      return;
    }
    if (description.isEmpty) {
      Fluttertoast.showToast(msg: "Please add a description");
      return;
    }

    if (dateFin == null || dateDeb == null) {
      Fluttertoast.showToast(msg: "Choose dates");
      return;
    }

    if (categorie.isEmpty) {
      Fluttertoast.showToast(msg: "Please choose a category");
      return;
    }

    if (options.isEmpty) {
      Fluttertoast.showToast(msg: "Please choose at least an option");
      return;
    }

    if (coverImage == null) {
      Fluttertoast.showToast(msg: "Please choose cover image");
      return;
    }

    if (images == null) {
      Fluttertoast.showToast(msg: "Please choose images");
      return;
    }

    if (villeId == -1) {
      Fluttertoast.showToast(msg: "Please choose a city");
      return;
    }
    if (currentlyPressed == null) {
      Fluttertoast.showToast(msg: "Please choose a point on the map");
      return;
    }

    context.loaderOverlay.show();
    Hebergement h = Hebergement(
      adresse: _addressController.text,
      categorie: categorie,
      dateDebut: "${dateDeb!.year}-${dateDeb!.month}-${dateDeb!.day}",
      dateFin: "${dateFin!.year}-${dateFin!.month}-${dateFin!.day}",
      description: description,
      latitude: currentlyPressed!.latitude,
      longitude: currentlyPressed!.longitude,
      nbrChambresDeux: int.parse(_chambreAdeuxController.text),
      nbrChambresTrois: int.parse(_chambreAtroisController.text),
      nbrChambresDisp: int.parse(_nbrChambresDispoController.text),
      nbrChambresIndiv: int.parse(_chambreIndividuelController.text),
      nbrPlacesDisp: int.parse(_nbrPlacesDispoController.text),
      nbrVoyageur: int.parse(_nbrVoyageursController.text),
      nom: nom,
      options: options.join(","),
      prixAdulte: double.parse(_prixAdulteController.text),
      prixEnfantMoin4: double.parse(_prixEnfantMoin4Controller.text),
      prixEnfantPlus4: double.parse(_prixEnfantPlus4Controller.text),
      proprietaireId: UserManager.proprietaire!.id,
      villeId: villeId,
      disponibilite: disponibilite,
    );
    var r = await UserManager.addHotel(
        hebergement: h, coverImage: coverImage!, images: images!);

    context.loaderOverlay.hide();
    Fluttertoast.showToast(msg: r.toString());
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 20),
          buildLineBreak(LocalizationsManager.getGeneralInfoLabel(context)),
          buildNameField(),
          buildDescriptionField(),
          buildDisponibilityField(),
          SizedBox(height: 20),
          buildStartDatePicker(),
          buildEndDatePicker(),
          buildLineBreak(LocalizationsManager.getCategoriesLabel(context)),
          buildCategoriesDropDown(),
          buildTagsInput(),
          SizedBox(height: 20),
          buildLineBreak(LocalizationsManager.getImagesLabel(context)),
          buildCoverImagePicker(),
          buildImagesPicker(),
          SizedBox(height: 20),
          buildLineBreak(LocalizationsManager.getMoreDetailsLabel(context)),
          ...buildNumberInputsFields(),
          SizedBox(height: 20),
          buildLineBreak(
              LocalizationsManager.getAcoomadationLocationLabel(context)),
          buildMapLabel(),
          if (_loadedCountries) buildCountriesDropDown(),
          if (_loadedCities) buildCitiesDropDown(),
          buildMap(),
          TextButton.icon(
              onPressed: () {
                handleFormSubmit();
              },
              icon: Icon(Icons.add),
              label: Text("Add accomadation")),
        ],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
