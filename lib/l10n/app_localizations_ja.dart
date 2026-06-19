// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabStore => '願いストア';

  @override
  String get tabDex => '願い図鑑';

  @override
  String get tabArchive => 'わたしの記録';

  @override
  String get homeStatusEmpty => '新しい四つ葉のクローバーを始めましょう。\n4つの善い行いで葉が満ちます。';

  @override
  String get homeStatusComplete => '四つ葉のクローバーが完成しました！🍀';

  @override
  String homeStatusProgress(int leaves, int remaining) {
    return '葉が$leaves枚集まりました。\nあと$remaining回の善い行いでクローバーが完成します！';
  }

  @override
  String get homeRecordButton => '今日の善い行いを記録する';

  @override
  String get recordTitle => 'どんな善い行いをしましたか？';

  @override
  String get recordSubtitle => '小さな行いも、クローバーの葉になります。';

  @override
  String get recordHint => '例：エレベーターのドアを押さえてあげました。';

  @override
  String get recordSubmit => '記録して葉を満たす';

  @override
  String get toastCloverComplete => '四つ葉のクローバーが完成しました 🍀';

  @override
  String get toastLeafFilled => '葉を満たしました';

  @override
  String get archiveTitle => 'わたしの善行記録';

  @override
  String get archiveStatLeaves => '満たした葉';

  @override
  String get archiveStatClovers => '生まれたクローバー';

  @override
  String get archiveStatWishes => '叶えた願い';

  @override
  String get archiveTimeline => 'タイムライン';

  @override
  String get archiveCalendar => 'カレンダー';

  @override
  String get archiveEmpty => 'まだ記録がありません。';

  @override
  String historyWishDone(String text) {
    return '［願い成就］$text';
  }

  @override
  String historyLeafDelta(int count) {
    return '🍃 葉 +$count';
  }

  @override
  String historyCloverDelta(int count) {
    return '🍀 クローバー -$count';
  }

  @override
  String get storeTitle => '願いストア';

  @override
  String get storeOwnedLabel => '保有クローバー';

  @override
  String storeCloverCount(int count) {
    return '$count個';
  }

  @override
  String get storeAddWish => '+ 自分だけの願いを追加';

  @override
  String get storeWishHint => '叶えたい自分の願い';

  @override
  String get storeRequiredClovers => '必要なクローバー';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get storeAddWishConfirm => '願いを追加';

  @override
  String get storeDepositFull => '完了';

  @override
  String get storeDeposit => 'クローバーを入れる';

  @override
  String get storeNotEnough => 'クローバー不足';

  @override
  String get depositTitleComplete => '願いを叶えますか？';

  @override
  String get depositTitle => 'クローバーを入れますか？';

  @override
  String get depositDescComplete => 'このクローバーを入れると願いが叶います。';

  @override
  String get depositDesc => 'クローバーを1つ入れます。入れたクローバーは元に戻せません。';

  @override
  String get depositConfirmComplete => '叶える';

  @override
  String get depositConfirm => '入れる';

  @override
  String get dexTitle => '願い図鑑';

  @override
  String get dexSubtitle => '叶えた願いがここに集まります';

  @override
  String get dexEmptyTitle => 'まだ叶えた願いがありません。';

  @override
  String get dexEmptyDesc => 'クローバーを集めて願いを叶えると、ここに収められます。';

  @override
  String get dexDelivered => 'お届け完了';

  @override
  String get dexTalismanLabel => 'お守り';

  @override
  String get grantTitle => '願いを届けてまいります。';

  @override
  String get toastWishDelivered => '願いを届けました・図鑑に収めました 🍀';

  @override
  String get talismanTitle => '幸運のお守り';

  @override
  String get talismanPortrait => '縦型';

  @override
  String get talismanSquare => '正方形';

  @override
  String get talismanSave => 'アルバムに保存';

  @override
  String get talismanShare => 'シェアする';

  @override
  String get toastSavedToAlbum => '写真アルバムに保存しました 🍀';

  @override
  String get talismanSaveFail => '保存するには写真へのアクセス許可が必要です。';

  @override
  String get talismanRetry => 'しばらくしてからもう一度お試しください。';

  @override
  String get talismanShareText =>
      'わたしの願いが叶いました 🍀\nこの幸運があなたにも届きますように。\n\nooloo — 善い行いで満たす四つ葉のクローバー';

  @override
  String get talismanLabel => '願い成就のお守り';

  @override
  String get talismanCenterLine => 'この願いが叶いました';

  @override
  String get talismanTagline => '善い行いで満たす四つ葉のクローバー';

  @override
  String get languageSheetTitle => '言語';

  @override
  String get languageSystem => 'システム設定に従う';
}
