// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabStore => 'Wish Store';

  @override
  String get tabDex => 'Wish Book';

  @override
  String get tabArchive => 'My Record';

  @override
  String get homeStatusEmpty =>
      'Start a new four-leaf clover.\nFour good deeds fill all its leaves.';

  @override
  String get homeStatusComplete => 'Your four-leaf clover is complete! 🍀';

  @override
  String homeStatusProgress(int leaves, int remaining) {
    return '$leaves leaves gathered.\n$remaining more good deeds to complete the clover!';
  }

  @override
  String get homeRecordButton => 'Record today\'s good deed';

  @override
  String get recordTitle => 'What kind deed did you do?';

  @override
  String get recordSubtitle => 'Even a small deed becomes a clover leaf.';

  @override
  String get recordHint => 'e.g. I held the elevator door for someone.';

  @override
  String get recordSubmit => 'Save and fill a leaf';

  @override
  String get toastCloverComplete => 'Your four-leaf clover is complete 🍀';

  @override
  String get toastLeafFilled => 'You filled a leaf';

  @override
  String get archiveTitle => 'My Good Deeds';

  @override
  String get archiveStatLeaves => 'Leaves filled';

  @override
  String get archiveStatClovers => 'Clovers born';

  @override
  String get archiveStatWishes => 'Wishes granted';

  @override
  String get archiveTimeline => 'Timeline';

  @override
  String get archiveCalendar => 'Calendar';

  @override
  String get archiveEmpty => 'No records yet.';

  @override
  String historyWishDone(String text) {
    return '[Wish granted] $text';
  }

  @override
  String historyLeafDelta(int count) {
    return '🍃 Leaf +$count';
  }

  @override
  String historyCloverDelta(int count) {
    return '🍀 Clover -$count';
  }

  @override
  String get storeTitle => 'Wish Store';

  @override
  String get storeOwnedLabel => 'Clovers owned';

  @override
  String storeCloverCount(int count) {
    return '$count';
  }

  @override
  String get storeAddWish => '+ Add my own wish';

  @override
  String get storeWishHint => 'A wish you want to come true';

  @override
  String get storeRequiredClovers => 'Clovers needed';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get storeAddWishConfirm => 'Add wish';

  @override
  String get storeDepositFull => 'Filled';

  @override
  String get storeDeposit => 'Add clover';

  @override
  String get storeNotEnough => 'Not enough';

  @override
  String get depositTitleComplete => 'Grant this wish?';

  @override
  String get depositTitle => 'Add a clover?';

  @override
  String get depositDescComplete => 'Adding this clover will grant your wish.';

  @override
  String get depositDesc => 'Add one clover. Added clovers can\'t be undone.';

  @override
  String get depositConfirmComplete => 'Grant';

  @override
  String get depositConfirm => 'Add';

  @override
  String get dexTitle => 'Wish Book';

  @override
  String get dexSubtitle => 'Granted wishes gather here';

  @override
  String get dexEmptyTitle => 'No granted wishes yet.';

  @override
  String get dexEmptyDesc =>
      'Gather all the clovers and grant a wish to see it here.';

  @override
  String get dexDelivered => 'Delivered';

  @override
  String get dexTalismanLabel => 'Talisman';

  @override
  String get grantTitle => 'Off to deliver your wish.';

  @override
  String get toastWishDelivered =>
      'Your wish was delivered · saved to your book 🍀';

  @override
  String get talismanTitle => 'Lucky Talisman';

  @override
  String get talismanPortrait => 'Portrait';

  @override
  String get talismanSquare => 'Square';

  @override
  String get talismanSave => 'Save to album';

  @override
  String get talismanShare => 'Share';

  @override
  String get toastSavedToAlbum => 'Saved to your photo album 🍀';

  @override
  String get talismanSaveFail => 'Photo access permission is needed to save.';

  @override
  String get talismanRetry => 'Please try again in a moment.';

  @override
  String get talismanShareText =>
      'My wish came true 🍀\nMay this luck reach you too.\n\nooloo — a four-leaf clover filled with good deeds';

  @override
  String get talismanLabel => 'Wish-Granted Talisman';

  @override
  String get talismanCenterLine => 'This wish has come true';

  @override
  String get talismanTagline => 'a four-leaf clover filled with good deeds';

  @override
  String get languageSheetTitle => 'Language';

  @override
  String get languageSystem => 'Follow system settings';
}
