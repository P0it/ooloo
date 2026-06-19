// ════════════════════════════════════════════════════════════════
//  매일 바뀌는 홈 화면 명언 — 친절·선행·따뜻함에 대한 한마디.
//
//  날짜(연중 일수)를 기준으로 하나를 고르므로,
//  같은 날에는 항상 같은 문구가 나오고 날이 바뀌면 다음 문구로 넘어갑니다.
//
//  단순 번역이 아니라 각 언어권 정서에 맞춰 "직접 각색"한 문구입니다.
//  네잎클로버=행운이라는 '설명'에 기대지 않고, "오늘의 작은 행운/다정함"
//  이라는 보편 감정에 맞춰 작성했습니다. (동아시아권에서 숫자 4를 한자 四로
//  강조하면 죽음을 연상시키므로 그런 표현은 피했습니다.)
//
//  언어별 문구 개수는 서로 달라도 됩니다(리스트 길이로 순환).
// ════════════════════════════════════════════════════════════════
class DailyQuotes {
  const DailyQuotes._();

  // 줄바꿈 지점(\n)은 어구 경계에 맞춰 직접 넣어둡니다.
  static const Map<String, List<String>> _byLang = {
    'ko': [
      '선행 적립 중...\n곧 행운으로 환급돼요',
      '친절하기 딱 좋은 날씨네요',
      '누군가의 흐린 날에\n우산을 빌려주는 건 어때요',
      '오늘, 누군가의\n영웅이 되어볼까요?',
      '먼저 웃는 사람이 이긴대요',
      '기분 좋은 흔적 남기기',
      '다정함은 닳지 않으니까요',
      '오늘의 선행은\n잔액이 무제한이에요',
      '친절은 반품 불가\n대신 평생 보장이래요',
      '작은 배려 한 스푼\n누군가에겐 한 끼예요',
      '웃음은 나눠줘도\n줄어들지 않아요',
      '오늘 뿌린 다정함\n어딘가에서 싹틀 거예요',
      '지나가는 인사 한 번이\n누군가의 하루를 켜요',
      '친절은 와이파이처럼\n조용히 퍼져요',
      '좋은 마음은\n표현할 때 비로소 켜져요',
      '누군가의 하루에\n깜짝 보너스가 되어볼까요',
      '오늘만큼은\n내가 먼저 다정해볼게요',
      '받은 친절은\n다음 사람에게 패스!',
      '작은 선행이란 건\n세상에 없대요',
      '다정한 사람\n오늘부터 시작이에요',
    ],
    'en': [
      'Kindness, now saving...\nsoon paid back as luck',
      'Perfect weather\nfor being kind',
      'Lend someone an umbrella\non their cloudy day',
      'Be someone’s hero today',
      'Whoever smiles first wins',
      'Leave a little\ngood behind you',
      'Kindness never wears out',
      'Today’s good deeds\nhave no limit',
      'Kindness has no returns —\nbut a lifetime warranty',
      'A spoonful of care\ncan be someone’s whole day',
      'Shared smiles\nnever run low',
      'The kindness you sow today\nwill sprout somewhere',
      'A passing hello\ncan light up a day',
      'Kindness spreads quietly,\nlike Wi-Fi',
      'A good heart shines\nonly when you show it',
      'Be a little surprise\nin someone’s day',
      'Today, let me be\nthe first to be kind',
      'Pass the kindness\non to the next person',
      'There’s no such thing\nas a small good deed',
      'A kinder you\nstarts today',
    ],
    'ja': [
      '善い行い、積立中...\nもうすぐ幸運で還元',
      '親切にぴったりの\n陽気ですね',
      '誰かの曇り空に\n傘を貸してみませんか',
      '今日、誰かの\nヒーローになってみよう',
      '先に笑った人の勝ちだそう',
      'いい気分の\n足あとを残そう',
      'やさしさは\nすり減らないから',
      '今日の善い行いは\n残高むげんだい',
      '親切は返品不可\nでも一生保証つき',
      'ひとさじの思いやりが\n誰かの一日になる',
      '笑顔は分けても\n減らないよ',
      '今日まいたやさしさは\nどこかで芽を出す',
      'すれ違いの挨拶ひとつが\n誰かの一日をともす',
      'やさしさはWi-Fiみたいに\nそっと広がる',
      'いい心は\n表してこそ灯る',
      '誰かの一日に\nうれしいおまけを',
      '今日くらいは\nわたしから先にやさしく',
      'もらった親切は\n次の人へパス！',
      '小さな善い行いなんて\n存在しないって',
      'やさしい人、\n今日から始めよう',
    ],
  };

  static const _fallbackLang = 'en';

  /// [lang] 언어의 오늘 문구. 미지원 언어는 영어로 폴백.
  /// [now] 미지정 시 현재 시각 기준.
  static String forToday(String lang, [DateTime? now]) {
    final list = _byLang[lang] ?? _byLang[_fallbackLang]!;
    final d = now ?? DateTime.now();
    final startOfYear = DateTime(d.year, 1, 1);
    final dayOfYear = d.difference(startOfYear).inDays; // 0..365
    return list[dayOfYear % list.length];
  }
}
