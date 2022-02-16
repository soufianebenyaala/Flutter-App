import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:etnafes/models/hebergement.dart';
import 'package:etnafes/models/pack.dart';
import 'package:etnafes/models/pays.dart';
import 'package:etnafes/models/programme.dart';
import 'package:etnafes/models/ville.dart';
import 'package:etnafes/services/api_manager.dart';
import 'package:etnafes/services/localizations_manager.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart' as locationManager;
import 'package:ndialog/ndialog.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AgencyAdminAddPacks extends StatefulWidget {
  AgencyAdminAddPacks({Key? key}) : super(key: key);

  @override
  _AgencyAdminAddPacksState createState() => _AgencyAdminAddPacksState();
}

class _AgencyAdminAddPacksState extends State<AgencyAdminAddPacks>
    with AutomaticKeepAliveClientMixin {
  String titre = "";
  String description = "";
  DateTime? dateDeb;
  DateTime? dateFin;
  String adrenaline = "";
  String urlVideo = "";
  XFile? imageCouverture;

  int paysId = -1;
  int villeId = -1;

  String countryName = "";
  String cityName = "";
  bool _loadedCountries = false;
  bool _loadedCities = false;
  late List<DropdownMenuItem<Pays>> countries;
  late List<DropdownMenuItem<Ville>> cities;

  String? selectedLocation;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  LatLng? currentlyPressed;
  late GoogleMapController _controller;

  final TextEditingController _nbrPlacesMaxController = TextEditingController();

  final TextEditingController _nbrPlacesDispoController =
      TextEditingController();
  final TextEditingController _nbrPlacesRemiseController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Image? _coverPreview;

  Set<Marker> markers = <Marker>{};

  bool _serviceEnabled = false;
  locationManager.PermissionStatus _permissionGranted =
      locationManager.PermissionStatus.denied;

  locationManager.Location location = locationManager.Location();

  bool _loadedHebergements = false;
  List<Hebergement>? hebergements;
  List<Hebergement> selectedHebergements = [];

  List<Programme> programs = [];

  @override
  void initState() {
    super.initState();
    _nbrPlacesMaxController.text = "0";
    _nbrPlacesDispoController.text = "0";
    _nbrPlacesRemiseController.text = "0";
    fetchHebergements();
    fetchCountries();
  }

  fetchHebergements() async {
    hebergements = await ApiManager.getAllAcoomadations();

    setState(() {
      _loadedHebergements = true;
    });
  }

  PageController _recentHotelsController = PageController();

  buildHebergementsTab() {
    return Container(
      height: 600.sp,
      margin: EdgeInsets.only(top: 16, left: 10),
      child: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _recentHotelsController,
        children: List.generate(
          hebergements!.length,
          (index) => Container(
            margin: EdgeInsets.only(right: 28.8),
            width: 400.sp,
            height: 200.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.6),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(ApiManager.filesAddress +
                      (hebergements![index].photoCoverture ?? "")),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      if (selectedHebergements.contains(hebergements![index])) {
                        Fluttertoast.showToast(msg: "Removed");
                        setState(() {
                          selectedHebergements.remove(hebergements![index]);
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Added");

                        setState(() {
                          selectedHebergements.add(hebergements![index]);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 100.sp,
                      color: selectedHebergements.contains(hebergements![index])
                          ? Colors.green
                          : Colors.red,
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
                        padding: EdgeInsets.only(left: 16.72, right: 14.4),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/svg/icon_location.svg'),
                            SizedBox(width: 9),
                            Text(
                              hebergements![index].nom,
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
          titre = val;
        },
      ),
    );
  }

  buildUrlField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.video_collection_rounded),
            hintText: "Url",
            labelText: "Url"),
        onChanged: (val) {
          urlVideo = val;
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

  buildDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2010, 01, 01),
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3560)),
    );
    return picked;
  }

  buildAdrenalinField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.sports_handball_rounded),
            hintText: "Adrenaline",
            labelText: "Adrenaline"),
        onChanged: (val) {
          adrenaline = val;
        },
      ),
    );
  }

  buildUrlVideoField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.person),
            hintText: "Adrenaline",
            labelText: "Adrenaline"),
        onChanged: (val) {
          urlVideo = val;
        },
      ),
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

  buildCoverImagePicker() {
    return Column(
      children: [
        TextButton.icon(
            onPressed: () async {
              imageCouverture =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (imageCouverture != null) {
                _coverPreview =
                    Image.memory(await imageCouverture!.readAsBytes());
              } else {
                _coverPreview = null;
              }
              setState(() {});
            },
            icon: Icon(Icons.image),
            label: Text(LocalizationsManager.getCoverPhotoLabel(context))),
        imageCouverture != null
            ? displayPickedCoverImage()
            : Text("Choose a pic first"),
      ],
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
        ),
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

  List<String> acts = [];

  buildAcitivitiesInput() {
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
        textFieldStyler:
            TextFieldStyler(hintText: "Activities", helperText: ""),
        onTag: (tag) {
          acts.add(tag);
        },
        onDelete: (tag) {
          acts.remove(tag);
        },
      ),
    );
  }

  buildProgramsInput() {
    var actTitle = "";
    var actDesc = "";
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descController = TextEditingController();
    return Column(children: [
      TextFormField(
        controller: _nameController,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.person),
            hintText: LocalizationsManager.getNameLabel(context),
            labelText: LocalizationsManager.getNameLabel(context)),
        onChanged: (val) {
          actTitle = val;
        },
      ),
      TextFormField(
        controller: _descController,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            icon: Icon(Icons.person),
            hintText: "Description",
            labelText: "Description"),
        onChanged: (val) {
          actDesc = val;
        },
      ),
      TextButton.icon(
          onPressed: () {
            _descController.text = "";
            _nameController.text = "";
            setState(() {
              programs.add(Programme(
                description: actDesc,
                titre: actTitle,
              ));
            });
          },
          icon: Icon(Icons.add),
          label: Text("Add"))
    ]);
  }

  buildAddedPrograms() {
    List<Widget> progs = [];
    for (var element in programs) {
      progs.add(ListTile(
        title: Text(element.titre),
        subtitle: Text(element.description),
        trailing: IconButton(
            onPressed: () {
              setState(() {
                programs.remove(element);
              });
            },
            icon: Icon(Icons.cancel)),
      ));
    }
    return progs;
  }

  buildAddPackButton() {
    return TextButton.icon(
      onPressed: () {
        handleAddPack();
      },
      icon: Icon(Icons.plus_one),
      label: Text("Add pack"),
    );
  }

  handleAddPack() async {
    Pack p = Pack(
      adminAgenceId: UserManager.admineAgence!.id,
      adrenaline: adrenaline,
      dateDebut: "${dateDeb!.year}-${dateDeb!.month}-${dateDeb!.day}",
      dateFin: "${dateFin!.year}-${dateFin!.month}-${dateFin!.day}",
      description: description,
      nbPlaceDispo: int.parse(_nbrPlacesDispoController.text),
      nbPlaceMax: int.parse(_nbrPlacesMaxController.text),
      nbPlaceRemise: int.parse(_nbrPlacesRemiseController.text),
      titre: titre,
      urlVideo: urlVideo,
      villeId: villeId,
    );

    if (adrenaline.isEmpty) {
      Fluttertoast.showToast(msg: "Adrenaline is empty");
      return;
    }
    if (dateDeb == null) {
      Fluttertoast.showToast(msg: "Didn't select start time");
      return;
    }
    if (dateFin == null) {
      Fluttertoast.showToast(msg: "Didn't select end time");
      return;
    }
    if (description.isEmpty) {
      Fluttertoast.showToast(msg: "Description is empty");
      return;
    }
    if (titre.isEmpty) {
      Fluttertoast.showToast(msg: "title is empty");
      return;
    }

    if (urlVideo.isEmpty) {
      Fluttertoast.showToast(msg: "Video url is empty");
      return;
    }

    if (villeId < 0) {
      Fluttertoast.showToast(msg: "Didn't select a city");
      return;
    }

    context.loaderOverlay.show();
    var r = await UserManager.addPack(p, programs, acts, imageCouverture!);
    context.loaderOverlay.hide();
    if (r) {
      showSuccessDialog();
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

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildNameField(),
            buildDescriptionField(),
            buildAdrenalinField(),
            buildUrlField(),
            Divider(),
            buildCoverImagePicker(),
            Divider(),
            buildStartDatePicker(),
            buildEndDatePicker(),
            Divider(),
            buildAcitivitiesInput(),
            Divider(),
            ...buildAddedPrograms(),
            buildProgramsInput(),
            Divider(),
            if (_loadedHebergements) buildHebergementsTab(),
            Divider(),
            buildNumberInputRow("Places dispo", _nbrPlacesDispoController),
            buildNumberInputRow("Max places", _nbrPlacesMaxController),
            buildNumberInputRow("Places remise", _nbrPlacesRemiseController),
            Divider(),
            if (_loadedCountries) buildCountriesDropDown(),
            if (_loadedCities) buildCitiesDropDown(),
            buildMap(),
            Divider(),
            buildAddPackButton(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
