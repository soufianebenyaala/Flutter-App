
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @accomadation_full_label.
  ///
  /// In en, this message translates to:
  /// **'Accommodation full'**
  String get accomadation_full_label;

  /// No description provided for @accomadations_label.
  ///
  /// In en, this message translates to:
  /// **'Accomadations'**
  String get accomadations_label;

  /// No description provided for @accommodation_location_label.
  ///
  /// In en, this message translates to:
  /// **'Accommodation location'**
  String get accommodation_location_label;

  /// No description provided for @adult_label.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get adult_label;

  /// No description provided for @adult_price_label.
  ///
  /// In en, this message translates to:
  /// **'adult price'**
  String get adult_price_label;

  /// No description provided for @already_agency_owner_label.
  ///
  /// In en, this message translates to:
  /// **'Already registered as an agency owner'**
  String get already_agency_owner_label;

  /// No description provided for @already_hotel_owner_label.
  ///
  /// In en, this message translates to:
  /// **'Already registered as an accomadations owner'**
  String get already_hotel_owner_label;

  /// No description provided for @already_restaurant_owner_label.
  ///
  /// In en, this message translates to:
  /// **'Already registered as an restaurant owner'**
  String get already_restaurant_owner_label;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Etnafes'**
  String get app_title;

  /// No description provided for @back_button_label.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back_button_label;

  /// No description provided for @booked_failed_label.
  ///
  /// In en, this message translates to:
  /// **'Accommodation booking failed'**
  String get booked_failed_label;

  /// No description provided for @booked_success_label.
  ///
  /// In en, this message translates to:
  /// **'Accomadation booked'**
  String get booked_success_label;

  /// No description provided for @bottom_bar_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get bottom_bar_account;

  /// No description provided for @bottom_bar_agencies.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get bottom_bar_agencies;

  /// No description provided for @bottom_bar_hotels.
  ///
  /// In en, this message translates to:
  /// **'Accomadations'**
  String get bottom_bar_hotels;

  /// No description provided for @bottom_bar_packs.
  ///
  /// In en, this message translates to:
  /// **'Packs'**
  String get bottom_bar_packs;

  /// No description provided for @bottom_bar_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bottom_bar_settings;

  /// No description provided for @cancel_label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_label;

  /// No description provided for @categories_label.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories_label;

  /// No description provided for @cities_label.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities_label;

  /// No description provided for @clear_label.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear_label;

  /// No description provided for @confirm_booking_label.
  ///
  /// In en, this message translates to:
  /// **'Book accomadation'**
  String get confirm_booking_label;

  /// No description provided for @confirm_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm_label;

  /// No description provided for @confirm_reservation_cancel_label.
  ///
  /// In en, this message translates to:
  /// **'reservation cancellation confirmation ?'**
  String get confirm_reservation_cancel_label;

  /// No description provided for @countries_label.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries_label;

  /// No description provided for @cover_image_label.
  ///
  /// In en, this message translates to:
  /// **'Cover picture'**
  String get cover_image_label;

  /// No description provided for @current_location_label.
  ///
  /// In en, this message translates to:
  /// **'Current locaiton'**
  String get current_location_label;

  /// No description provided for @description_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description_label;

  /// No description provided for @done_button_label.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done_button_label;

  /// No description provided for @end_date_label.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get end_date_label;

  /// No description provided for @failed_label.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed_label;

  /// No description provided for @first_name_label.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get first_name_label;

  /// No description provided for @general_info_label.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get general_info_label;

  /// No description provided for @hold_on_map_hint.
  ///
  /// In en, this message translates to:
  /// **'Hold location on map to choose'**
  String get hold_on_map_hint;

  /// No description provided for @hotel_info_page_more_info.
  ///
  /// In en, this message translates to:
  /// **'Explore now'**
  String get hotel_info_page_more_info;

  /// No description provided for @hotel_info_page_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get hotel_info_page_price;

  /// No description provided for @hotel_info_page_price_currency.
  ///
  /// In en, this message translates to:
  /// **'tnd'**
  String get hotel_info_page_price_currency;

  /// No description provided for @hotels_page_current_search_label.
  ///
  /// In en, this message translates to:
  /// **'Currently searching'**
  String get hotels_page_current_search_label;

  /// No description provided for @hotels_page_popular_attractions.
  ///
  /// In en, this message translates to:
  /// **'Popular\nattractions'**
  String get hotels_page_popular_attractions;

  /// No description provided for @hotels_page_recent_hotels.
  ///
  /// In en, this message translates to:
  /// **'Recent Accomadations'**
  String get hotels_page_recent_hotels;

  /// No description provided for @hotels_page_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get hotels_page_search;

  /// No description provided for @hotels_page_show_all.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get hotels_page_show_all;

  /// No description provided for @hotels_page_tab_bar_newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get hotels_page_tab_bar_newest;

  /// No description provided for @hotels_page_tab_bar_popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get hotels_page_tab_bar_popular;

  /// No description provided for @hotels_page_tab_bar_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get hotels_page_tab_bar_recommended;

  /// No description provided for @images_label.
  ///
  /// In en, this message translates to:
  /// **'Pictures'**
  String get images_label;

  /// No description provided for @intro_page1_description.
  ///
  /// In en, this message translates to:
  /// **'Etnafes is a platform for searching and finding accommodations on your phone'**
  String get intro_page1_description;

  /// No description provided for @intro_page1_title.
  ///
  /// In en, this message translates to:
  /// **'Etnafes'**
  String get intro_page1_title;

  /// No description provided for @intro_page2_description.
  ///
  /// In en, this message translates to:
  /// **'Find all relative information and dates easily and quickly'**
  String get intro_page2_description;

  /// No description provided for @intro_page2_title.
  ///
  /// In en, this message translates to:
  /// **'Simplicity'**
  String get intro_page2_title;

  /// No description provided for @invalid_date_chioice.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get invalid_date_chioice;

  /// No description provided for @invalid_number_of_people.
  ///
  /// In en, this message translates to:
  /// **'Invalid number of people'**
  String get invalid_number_of_people;

  /// No description provided for @kid_less_4_label.
  ///
  /// In en, this message translates to:
  /// **'Kids ( <4 years )'**
  String get kid_less_4_label;

  /// No description provided for @kid_more_4_label.
  ///
  /// In en, this message translates to:
  /// **'Kids ( >4 years )'**
  String get kid_more_4_label;

  /// No description provided for @language_label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_label;

  /// No description provided for @last_name_label.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get last_name_label;

  /// No description provided for @more_details_label.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get more_details_label;

  /// No description provided for @name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_label;

  /// No description provided for @nbr_double_room_label.
  ///
  /// In en, this message translates to:
  /// **'Number of double rooms'**
  String get nbr_double_room_label;

  /// No description provided for @nbr_of_rooms_available_label.
  ///
  /// In en, this message translates to:
  /// **'Number of rooms available'**
  String get nbr_of_rooms_available_label;

  /// No description provided for @nbr_places_available_label.
  ///
  /// In en, this message translates to:
  /// **'Number of places available'**
  String get nbr_places_available_label;

  /// No description provided for @nbr_room_for_three_label.
  ///
  /// In en, this message translates to:
  /// **'Number of rooms for three'**
  String get nbr_room_for_three_label;

  /// No description provided for @nbr_single_rooms_label.
  ///
  /// In en, this message translates to:
  /// **'Number of single rooms'**
  String get nbr_single_rooms_label;

  /// No description provided for @nbr_travelers_label.
  ///
  /// In en, this message translates to:
  /// **'Number of travelers'**
  String get nbr_travelers_label;

  /// No description provided for @next_button_label.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next_button_label;

  /// No description provided for @options_label.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options_label;

  /// No description provided for @payment_method_label.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get payment_method_label;

  /// No description provided for @previous_label.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous_label;

  /// No description provided for @price_children_less_4_label.
  ///
  /// In en, this message translates to:
  /// **'price for children (<4 years)'**
  String get price_children_less_4_label;

  /// No description provided for @price_children_more_4_label.
  ///
  /// In en, this message translates to:
  /// **'price for children (>4 years)'**
  String get price_children_more_4_label;

  /// No description provided for @register_as_agency_label.
  ///
  /// In en, this message translates to:
  /// **'Register as an agency owner'**
  String get register_as_agency_label;

  /// No description provided for @register_as_hotel_owner_label.
  ///
  /// In en, this message translates to:
  /// **'Register as accomadations owner'**
  String get register_as_hotel_owner_label;

  /// No description provided for @register_as_restaurant_owner_label.
  ///
  /// In en, this message translates to:
  /// **'Register as an restaurant owner'**
  String get register_as_restaurant_owner_label;

  /// No description provided for @restaurant_label.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant_label;

  /// No description provided for @settings_page_label.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_page_label;

  /// No description provided for @signup_label.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup_label;

  /// No description provided for @skip_button_label.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip_button_label;

  /// No description provided for @start_date_label.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get start_date_label;

  /// No description provided for @success_label.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success_label;

  /// No description provided for @theme_mode_label.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme_mode_label;

  /// No description provided for @update_label.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update_label;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
