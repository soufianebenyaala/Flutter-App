import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsManager {

  /// App title
  static String getTitle(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.app_title;
  }

  ///
  ///General texts
  ///

  static String getFirstNameLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.first_name_label;
  }

  static String getLastNameLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.last_name_label;
  }

  static String getNameLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.name_label;
  }

  static String getDescriptionLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.description_label;
  }

  static String getPreviousLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.previous_label;
  }

  static String getCountriesLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.countries_label;
  }

  static String getCitiesLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.cities_label;
  }

  static String getOptionsLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.options_label;
  }

  static String getGeneralInfoLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.general_info_label;
  }

  static String getNextButtonLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.next_button_label;
  }

  static String getBackButtonLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.back_button_label;
  }

  static String getClearLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.clear_label;
  }

  static String getAccomadationFullLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.accomadation_full_label;
  }

  static String getUpdateLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.update_label;
  }

  static String getCancelLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.cancel_label;
  }

  static String getReservationConfirmationLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.confirm_reservation_cancel_label;
  }

  static String getConfirmLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.confirm_label;
  }

  static String getSuccessLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.success_label;
  }

  static String getFailedLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.failed_label;
  }

  ///
  ///Errors
  ///
  static String getInvalidDateChoice(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.invalid_date_chioice;
  }

  static String getInvalidNumberOfPeople(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.invalid_number_of_people;
  }

  ///
  /// Bottom nav bar
  ///

  static String getBottomAccomadationsLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.bottom_bar_hotels;
  }

  static String getBottomBarAccount(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.bottom_bar_account;
  }

  static String getBottomBarAgencies(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.bottom_bar_agencies;
  }

  static String getBottomBarPacks(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.bottom_bar_packs;
  }

  static String getBottomBarSettings(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.bottom_bar_settings;
  }

  /// Intro page

  static String getPage1Title(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.intro_page1_title;
  }

  static String getPage1Description(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.intro_page1_description;
  }

  static String getPage2Title(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.intro_page2_title;
  }

  static String getPage2Description(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.intro_page2_description;
  }

  static String getDoneButtonLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.done_button_label;
  }

  static String getSkipButtonLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.skip_button_label;
  }

  /// Hotel page

  static String getAccomadationsLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.accomadations_label;
  }

  static String getCategoriesLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.categories_label;
  }

  static String getHotelsSearchLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_search;
  }

  static String getHotelsCurrentSearchLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_current_search_label;
  }

  static String getHotelsTabBarRecommended(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_tab_bar_recommended;
  }

  static String getHotelsTabBarPopular(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_tab_bar_popular;
  }

  static String getHotelsTabBarNewest(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_tab_bar_newest;
  }

  static String getHotelsRecentHotels(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_recent_hotels;
  }

  static String getHotelsShowAll(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_show_all;
  }

  static String getHotelsPopularAttractions(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotels_page_popular_attractions;
  }

  /// Hotel details

  static String getHotelInfoPrice(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotel_info_page_price;
  }

  static String getHotelInfoPriceCurrency(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotel_info_page_price_currency;
  }

  static String getHotelInfoMoreInfo(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hotel_info_page_more_info;
  }

  static String getAdultLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.adult_label;
  }

  static String getKidLess4Label(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.kid_less_4_label;
  }

  static String getKidMore4Label(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.kid_more_4_label;
  }

  ///
  ///Booking page
  ///

  static String getPaymentMethodeLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.payment_method_label;
  }

  static String getBookingLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.confirm_booking_label;
  }

  static String getBookingSuccessLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.booked_success_label;
  }

  static String getBookingFailedLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.booked_failed_label;
  }

  ///
  /// Settings page
  ///

  static String getLanguageLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.language_label;
  }

  static String getThemeLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.theme_mode_label;
  }

  static String getSettingsPageLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.settings_page_label;
  }

  ///Signup page
  ///
  ///
  static String getSignupLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.signup_label;
  }

  ///
  ///Profile
  ///

  ///
  ///Account managment
  ///

  static String getRegisterAsHotelOwnerLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.register_as_hotel_owner_label;
  }

  static String getRegisterAsAgencyOwner(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.register_as_agency_label;
  }

  static String getRegisterAsRestaurantOwner(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.register_as_restaurant_owner_label;
  }

  static String getAlreadyRestaurantOwnerLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.already_restaurant_owner_label;
  }

  static String getAlreadyHotelOwnerLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.already_hotel_owner_label;
  }

  static String getLareadyAgencyOwnerLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.already_agency_owner_label;
  }

  ///
  ///Add hotel page
  ///
  static String getNbrTravelersLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.nbr_travelers_label;
  }

  static String getNbrPlacesAvailableLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.nbr_places_available_label;
  }

  static String getNbrRoomsAvailableLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.nbr_of_rooms_available_label;
  }

  static String getNbrSingleRoomsAvailableLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.nbr_single_rooms_label;
  }

  static String getNbrDoubleRoomsAvailableLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.nbr_double_room_label;
  }

  static String getNbrRoomsThreeAvailableLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.nbr_room_for_three_label;
  }

  static String getAdultPriceLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.adult_price_label;
  }

  static String getChildrenLess4Price(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.price_children_less_4_label;
  }

  static String getChildrenMore4Price(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.price_children_more_4_label;
  }

  static String getAcoomadationLocationLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.accommodation_location_label;
  }

  static String getCurrentLocationLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.current_location_label;
  }

  static String getMapHoldHint(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.hold_on_map_hint;
  }

  static String getCoverPhotoLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.cover_image_label;
  }

  static String getImagesLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.images_label;
  }

  static String getMoreDetailsLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.more_details_label;
  }

  static String getStartDateLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.start_date_label;
  }

  static String getEndDateLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.end_date_label;
  }

  // Restaurant page
  static String getRestaurantLabel(BuildContext appContext) {
    return AppLocalizations.of(appContext)!.restaurant_label;
  }
}
