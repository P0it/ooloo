/// 기록 항목 — 선행으로 잎을 모은 내역, 또는 소원 성취(클로버 사용) 내역.
/// positive=true 면 "모은 기록", false 면 "사용 기록".
class HistoryEntry {
  final int id;
  final String date; // 'YYYY.MM.DD'
  final String text;
  final String delta; // 예: '🍀 잎 +1' / '🍀 클로버 -2'
  final bool positive;

  const HistoryEntry({
    required this.id,
    required this.date,
    required this.text,
    required this.delta,
    required this.positive,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'date': date, 'text': text, 'delta': delta, 'positive': positive};

  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
        id: j['id'] as int,
        date: j['date'] as String,
        text: j['text'] as String,
        delta: j['delta'] as String,
        positive: j['positive'] as bool,
      );
}
