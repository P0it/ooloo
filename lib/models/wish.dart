/// 소원 — 소원 상점의 항목. 클로버를 소모해 빌 수 있다.
class Wish {
  final int id;
  final String text;
  final int cost;

  const Wish({required this.id, required this.text, required this.cost});

  Wish copyWith({int? id, String? text, int? cost}) =>
      Wish(id: id ?? this.id, text: text ?? this.text, cost: cost ?? this.cost);

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'cost': cost};

  factory Wish.fromJson(Map<String, dynamic> j) =>
      Wish(id: j['id'] as int, text: j['text'] as String, cost: j['cost'] as int);
}
