/// 소원 — 소원 상점의 항목. 클로버를 하나씩 담아(deposited) 채워간다.
class Wish {
  final int id;
  final String text;
  final int cost; // 완성에 필요한 클로버 수
  final int deposited; // 현재 담긴 클로버 수
  final String? completedAt; // 완성일 'YYYY.MM.DD' (활성 소원은 null)

  const Wish({
    required this.id,
    required this.text,
    required this.cost,
    this.deposited = 0,
    this.completedAt,
  });

  bool get isFull => deposited >= cost;

  Wish copyWith({int? id, String? text, int? cost, int? deposited, String? completedAt}) =>
      Wish(
        id: id ?? this.id,
        text: text ?? this.text,
        cost: cost ?? this.cost,
        deposited: deposited ?? this.deposited,
        completedAt: completedAt ?? this.completedAt,
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'text': text, 'cost': cost, 'deposited': deposited, 'completedAt': completedAt};

  factory Wish.fromJson(Map<String, dynamic> j) => Wish(
        id: j['id'] as int,
        text: j['text'] as String,
        cost: j['cost'] as int,
        deposited: j['deposited'] as int? ?? 0,
        completedAt: j['completedAt'] as String?,
      );
}
