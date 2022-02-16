import 'package:etnafes/models/restaurant.dart';
import 'package:etnafes/services/user_manager.dart';
import 'package:etnafes/widgets/lottie_widgets.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class RestaurantOwnerMyRestaurants extends StatefulWidget {
  RestaurantOwnerMyRestaurants({Key? key}) : super(key: key);

  @override
  _RestaurantOwnerAddState createState() => _RestaurantOwnerAddState();
}

class _RestaurantOwnerAddState extends State<RestaurantOwnerMyRestaurants> {
  List<Restaurant> myRestaurants = [];
  bool _loadedRestaurants = false;

  @override
  void initState() {
    super.initState();
    fetchUserRestaurants();
  }

  fetchUserRestaurants() async {
    _loadedRestaurants = false;
    myRestaurants = await UserManager.getUserRestaurants();
    setState(() {
      _loadedRestaurants = true;
    });
  }

  buildAllRestaurants() {
    List<Widget> lst = [];
    for (var item in myRestaurants) {
      lst.add(GestureDetector(
        onTap: () {
          restaurantPopup(item);
        },
        child: ListTile(
          title: Text(item.nom),
          subtitle: Text(item.description),
        ),
      ));
    }
    if (lst.isEmpty) {
      return [LottieWidget.noItemsAnimation()];
    }
    return lst;
  }

  restaurantPopup(Restaurant r) async {
    await NDialog(
      title: Text(r.nom + " " + r.id.toString()),
      content: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Description : " + r.description),
            SizedBox(height: 10),
          ],
        ),
      )),
      actions: [
        TextButton.icon(
          onPressed: () {
            handleRestaurantRemove(r);
          },
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          label: const Text(
            "Supprimer",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  handleRestaurantRemove(Restaurant rest) async {
    var r = await UserManager.removeRestaurant(rest);
    if (r) {
      Navigator.pop(context);
      fetchUserRestaurants();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            if (_loadedRestaurants) ...buildAllRestaurants(),
          ],
        ),
      ),
    );
  }
}
