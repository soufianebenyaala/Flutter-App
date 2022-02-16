import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LottieWidget {
  // Loading image error
  static Widget errorLoadingImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        LottieBuilder.asset(
          "assets/lottie/error.json",
          repeat: true,
          alignment: Alignment.center,
        ),
        const Text(
          "Error loading image",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  /// Not logged in

  static Widget errorLoginSignup() {
    return Column(children: [
      LottieBuilder.asset(
        "assets/lottie/login_signup.json",
        repeat: true,
      ),
      Text(
        "Please login or signup first",
        style: GoogleFonts.lato(fontSize: 25),
      )
    ]);
  }

  /// Favorites is empty

  static Widget errorEmptyFavorites() {
    return Column(children: [
      LottieBuilder.asset(
        "assets/lottie/empty_favorites_screen.json",
        repeat: true,
      ),
      Text(
        "No favorite items",
        style: GoogleFonts.lato(fontSize: 25),
      )
    ]);
  }

  /// Searching

  static Widget searchLoading() {
    return Column(children: [
      LottieBuilder.asset(
        "assets/lottie/searching.json",
        repeat: true,
      ),
      Text(
        "Searching, please wait",
        style: GoogleFonts.lato(fontSize: 25),
      )
    ]);
  }

  /// Settings animation

  static Widget settingsAnimation() {
    return Column(children: [
      LottieBuilder.asset(
        "assets/lottie/settings.json",
        height: 150,
        repeat: true,
      ),
    ]);
  }

  static Widget loadingPaperplaneAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        LottieBuilder.asset(
          "assets/lottie/loading_paperplane.json",
          repeat: true,
          alignment: Alignment.center,
        ),
        const Text(
          "Loading",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  static Widget lastStepRegister() {
    return Column(children: [
      LottieBuilder.asset(
        "assets/lottie/register.json",
        repeat: true,
        fit: BoxFit.scaleDown,
      ),
    ]);
  }

  static Widget heartAnimated() {
    return Column(children: [
      LottieBuilder.asset(
        "assets/lottie/heart.json",
        repeat: true,
        reverse: true,
        fit: BoxFit.scaleDown,
      ),
    ]);
  }

  static Widget breifCaseAnimation() {
    return LottieBuilder.asset(
      "assets/lottie/briefcase.json",
      repeat: true,
      reverse: true,
      fit: BoxFit.contain,
    );
  }

  static Widget noItemsAnimation() {
    return LottieBuilder.asset(
      "assets/lottie/empty_items.json",
      repeat: true,
      reverse: true,
      fit: BoxFit.contain,
    );
  }

  static Widget successAnimation() {
    return LottieBuilder.asset(
      "assets/lottie/success.json",
      repeat: true,
      reverse: true,
      fit: BoxFit.contain,
    );
  }
  static Widget failedAnimation() {
    return LottieBuilder.asset(
      "assets/lottie/failed.json",
      repeat: true,
      reverse: true,
      fit: BoxFit.contain,
    );
  }
}
