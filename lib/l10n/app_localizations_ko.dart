// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabHome => '홈';

  @override
  String get tabStore => '소원 상점';

  @override
  String get tabDex => '소원 도감';

  @override
  String get tabArchive => '나의 기록';

  @override
  String get homeStatusEmpty => '새 네잎클로버를 시작해요.\n4번의 선행이면 잎이 가득 차요.';

  @override
  String get homeStatusComplete => '네잎클로버가 완성됐어요! 🍀';

  @override
  String homeStatusProgress(int leaves, int remaining) {
    return '잎이 $leaves개 모였어요.\n$remaining번 더 선행을 베풀면 클로버가 완성돼요!';
  }

  @override
  String get homeRecordButton => '오늘의 선행 기록하기';

  @override
  String get recordTitle => '어떤 선행을 베푸셨나요?';

  @override
  String get recordSubtitle => '작은 선행도 클로버의 잎이 됩니다.';

  @override
  String get recordHint => '예: 엘리베이터 문을 잡아주었습니다.';

  @override
  String get recordSubmit => '기록 완료하고 잎 채우기';

  @override
  String get toastCloverComplete => '네잎클로버가 완성됐어요 🍀';

  @override
  String get toastLeafFilled => '잎을 채웠어요';

  @override
  String get archiveTitle => '나의 선행 기록';

  @override
  String get archiveStatLeaves => '총 채운 잎';

  @override
  String get archiveStatClovers => '탄생한 클로버';

  @override
  String get archiveStatWishes => '이룬 소원';

  @override
  String get archiveTimeline => '타임라인';

  @override
  String get archiveCalendar => '캘린더';

  @override
  String get archiveEmpty => '아직 기록이 없어요.';

  @override
  String historyWishDone(String text) {
    return '[소원 성취] $text';
  }

  @override
  String historyLeafDelta(int count) {
    return '🍃 잎 +$count';
  }

  @override
  String historyCloverDelta(int count) {
    return '🍀 클로버 -$count';
  }

  @override
  String get storeTitle => '소원 상점';

  @override
  String get storeOwnedLabel => '보유한 클로버';

  @override
  String storeCloverCount(int count) {
    return '$count개';
  }

  @override
  String get storeAddWish => '+ 나만의 소원 추가하기';

  @override
  String get storeWishHint => '이루고 싶은 나만의 소원';

  @override
  String get storeRequiredClovers => '필요한 클로버';

  @override
  String get commonCancel => '취소';

  @override
  String get storeAddWishConfirm => '소원 추가';

  @override
  String get storeDepositFull => '담기 완료';

  @override
  String get storeDeposit => '클로버 담기';

  @override
  String get storeNotEnough => '클로버 부족';

  @override
  String get depositTitleComplete => '소원을 완성할까요?';

  @override
  String get depositTitle => '클로버를 담을까요?';

  @override
  String get depositDescComplete => '이 클로버를 담으면 소원이 이루어져요.';

  @override
  String get depositDesc => '보유 클로버 1개를 담아요. 담은 클로버는 되돌릴 수 없어요.';

  @override
  String get depositConfirmComplete => '완성하기';

  @override
  String get depositConfirm => '담기';

  @override
  String get dexTitle => '소원 도감';

  @override
  String get dexSubtitle => '전한 소원들이 이곳에 모여요';

  @override
  String get dexEmptyTitle => '아직 전한 소원이 없어요.';

  @override
  String get dexEmptyDesc => '클로버를 다 모아 소원을 전하면 이곳에 담겨요.';

  @override
  String get dexDelivered => '전달 완료';

  @override
  String get dexTalismanLabel => '부적';

  @override
  String get grantTitle => '소원을 전달하고 오겠습니다.';

  @override
  String get toastWishDelivered => '소원을 전했어요 · 도감에 담겼어요 🍀';

  @override
  String get talismanTitle => '행운 부적';

  @override
  String get talismanPortrait => '세로형';

  @override
  String get talismanSquare => '정사각형';

  @override
  String get talismanSave => '앨범 저장';

  @override
  String get talismanShare => '공유하기';

  @override
  String get toastSavedToAlbum => '사진 앨범에 저장했어요 🍀';

  @override
  String get talismanSaveFail => '저장하려면 사진 접근 권한이 필요해요.';

  @override
  String get talismanRetry => '잠시 후 다시 시도해 주세요.';

  @override
  String get talismanShareText =>
      '제 소원이 이루어졌어요 🍀\n당신에게도 이 행운이 닿기를.\n\nooloo — 선행으로 채우는 네잎클로버';

  @override
  String get talismanLabel => '소원 성취 부적';

  @override
  String get talismanCenterLine => '이 소원이 이루어졌어요';

  @override
  String get talismanTagline => '선행으로 채우는 네잎클로버';

  @override
  String get languageSheetTitle => '언어';

  @override
  String get languageSystem => '시스템 설정 따르기';
}
