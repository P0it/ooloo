import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabStore.
  ///
  /// In en, this message translates to:
  /// **'Wish Store'**
  String get tabStore;

  /// No description provided for @tabDex.
  ///
  /// In en, this message translates to:
  /// **'Wish Book'**
  String get tabDex;

  /// No description provided for @tabArchive.
  ///
  /// In en, this message translates to:
  /// **'My Record'**
  String get tabArchive;

  /// No description provided for @homeStatusEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start a new four-leaf clover.\nFour good deeds fill all its leaves.'**
  String get homeStatusEmpty;

  /// No description provided for @homeStatusComplete.
  ///
  /// In en, this message translates to:
  /// **'Your four-leaf clover is complete! 🍀'**
  String get homeStatusComplete;

  /// No description provided for @homeStatusProgress.
  ///
  /// In en, this message translates to:
  /// **'{leaves} leaves gathered.\n{remaining} more good deeds to complete the clover!'**
  String homeStatusProgress(int leaves, int remaining);

  /// No description provided for @homeRecordButton.
  ///
  /// In en, this message translates to:
  /// **'Record today\'s good deed'**
  String get homeRecordButton;

  /// No description provided for @recordTitle.
  ///
  /// In en, this message translates to:
  /// **'What kind deed did you do?'**
  String get recordTitle;

  /// No description provided for @recordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Even a small deed becomes a clover leaf.'**
  String get recordSubtitle;

  /// No description provided for @recordHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. I held the elevator door for someone.'**
  String get recordHint;

  /// No description provided for @recordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save and fill a leaf'**
  String get recordSubmit;

  /// No description provided for @toastCloverComplete.
  ///
  /// In en, this message translates to:
  /// **'Your four-leaf clover is complete 🍀'**
  String get toastCloverComplete;

  /// No description provided for @toastLeafFilled.
  ///
  /// In en, this message translates to:
  /// **'You filled a leaf'**
  String get toastLeafFilled;

  /// No description provided for @archiveTitle.
  ///
  /// In en, this message translates to:
  /// **'My Good Deeds'**
  String get archiveTitle;

  /// No description provided for @archiveStatLeaves.
  ///
  /// In en, this message translates to:
  /// **'Leaves filled'**
  String get archiveStatLeaves;

  /// No description provided for @archiveStatClovers.
  ///
  /// In en, this message translates to:
  /// **'Clovers born'**
  String get archiveStatClovers;

  /// No description provided for @archiveStatWishes.
  ///
  /// In en, this message translates to:
  /// **'Wishes granted'**
  String get archiveStatWishes;

  /// No description provided for @archiveTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get archiveTimeline;

  /// No description provided for @archiveCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get archiveCalendar;

  /// No description provided for @archiveEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records yet.'**
  String get archiveEmpty;

  /// No description provided for @historyWishDone.
  ///
  /// In en, this message translates to:
  /// **'[Wish granted] {text}'**
  String historyWishDone(String text);

  /// No description provided for @historyLeafDelta.
  ///
  /// In en, this message translates to:
  /// **'🍃 Leaf +{count}'**
  String historyLeafDelta(int count);

  /// No description provided for @historyCloverDelta.
  ///
  /// In en, this message translates to:
  /// **'🍀 Clover -{count}'**
  String historyCloverDelta(int count);

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Wish Store'**
  String get storeTitle;

  /// No description provided for @storeOwnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Clovers owned'**
  String get storeOwnedLabel;

  /// No description provided for @storeCloverCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String storeCloverCount(int count);

  /// No description provided for @storeAddWish.
  ///
  /// In en, this message translates to:
  /// **'+ Add my own wish'**
  String get storeAddWish;

  /// No description provided for @storeWishHint.
  ///
  /// In en, this message translates to:
  /// **'A wish you want to come true'**
  String get storeWishHint;

  /// No description provided for @storeRequiredClovers.
  ///
  /// In en, this message translates to:
  /// **'Clovers needed'**
  String get storeRequiredClovers;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @storeAddWishConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add wish'**
  String get storeAddWishConfirm;

  /// No description provided for @storeDepositFull.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get storeDepositFull;

  /// No description provided for @storeDeposit.
  ///
  /// In en, this message translates to:
  /// **'Add clover'**
  String get storeDeposit;

  /// No description provided for @storeNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough'**
  String get storeNotEnough;

  /// No description provided for @depositTitleComplete.
  ///
  /// In en, this message translates to:
  /// **'Grant this wish?'**
  String get depositTitleComplete;

  /// No description provided for @depositTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a clover?'**
  String get depositTitle;

  /// No description provided for @depositDescComplete.
  ///
  /// In en, this message translates to:
  /// **'Adding this clover will grant your wish.'**
  String get depositDescComplete;

  /// No description provided for @depositDesc.
  ///
  /// In en, this message translates to:
  /// **'Add one clover. Added clovers can\'t be undone.'**
  String get depositDesc;

  /// No description provided for @depositConfirmComplete.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get depositConfirmComplete;

  /// No description provided for @depositConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get depositConfirm;

  /// No description provided for @dexTitle.
  ///
  /// In en, this message translates to:
  /// **'Wish Book'**
  String get dexTitle;

  /// No description provided for @dexSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Granted wishes gather here'**
  String get dexSubtitle;

  /// No description provided for @dexEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No granted wishes yet.'**
  String get dexEmptyTitle;

  /// No description provided for @dexEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Gather all the clovers and grant a wish to see it here.'**
  String get dexEmptyDesc;

  /// No description provided for @dexDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get dexDelivered;

  /// No description provided for @dexTalismanLabel.
  ///
  /// In en, this message translates to:
  /// **'Talisman'**
  String get dexTalismanLabel;

  /// No description provided for @grantTitle.
  ///
  /// In en, this message translates to:
  /// **'Off to deliver your wish.'**
  String get grantTitle;

  /// No description provided for @toastWishDelivered.
  ///
  /// In en, this message translates to:
  /// **'Your wish was delivered · saved to your book 🍀'**
  String get toastWishDelivered;

  /// No description provided for @talismanTitle.
  ///
  /// In en, this message translates to:
  /// **'Lucky Talisman'**
  String get talismanTitle;

  /// No description provided for @talismanPortrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get talismanPortrait;

  /// No description provided for @talismanSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get talismanSquare;

  /// No description provided for @talismanSave.
  ///
  /// In en, this message translates to:
  /// **'Save to album'**
  String get talismanSave;

  /// No description provided for @talismanShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get talismanShare;

  /// No description provided for @toastSavedToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Saved to your photo album 🍀'**
  String get toastSavedToAlbum;

  /// No description provided for @talismanSaveFail.
  ///
  /// In en, this message translates to:
  /// **'Photo access permission is needed to save.'**
  String get talismanSaveFail;

  /// No description provided for @talismanRetry.
  ///
  /// In en, this message translates to:
  /// **'Please try again in a moment.'**
  String get talismanRetry;

  /// No description provided for @talismanShareText.
  ///
  /// In en, this message translates to:
  /// **'My wish came true 🍀\nMay this luck reach you too.\n\nooloo — a four-leaf clover filled with good deeds'**
  String get talismanShareText;

  /// No description provided for @talismanLabel.
  ///
  /// In en, this message translates to:
  /// **'Wish-Granted Talisman'**
  String get talismanLabel;

  /// No description provided for @talismanCenterLine.
  ///
  /// In en, this message translates to:
  /// **'This wish has come true'**
  String get talismanCenterLine;

  /// No description provided for @talismanTagline.
  ///
  /// In en, this message translates to:
  /// **'a four-leaf clover filled with good deeds'**
  String get talismanTagline;

  /// No description provided for @languageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSheetTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system settings'**
  String get languageSystem;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
