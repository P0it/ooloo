import 'deed.dart';
import 'wish.dart';

enum AppTab { home, store, archive }

enum ArchiveFilter { earn, spend }

/// 앱 전역 상태. Clover.dc.html 의 `state` 를 그대로 옮긴다.
class AppState {
  final AppTab tab;
  final ArchiveFilter archiveFilter;
  final int leaves; // 현재 클로버에 채워진 잎 (0~4)
  final int clovers; // 보유한 완성 클로버
  final bool celebrate; // 4잎 완성 축하 애니메이션 트리거
  final int bounceKey; // 잎 팝 애니메이션 재생용 키

  final int statLeaves; // 총 채운 잎
  final int statClovers; // 탄생한 클로버
  final int statWishes; // 이룬 소원

  final List<Wish> wishes;
  final List<HistoryEntry> history;

  const AppState({
    this.tab = AppTab.home,
    this.archiveFilter = ArchiveFilter.earn,
    this.leaves = 2,
    this.clovers = 2,
    this.celebrate = false,
    this.bounceKey = 0,
    this.statLeaves = 34,
    this.statClovers = 8,
    this.statWishes = 6,
    this.wishes = const [],
    this.history = const [],
  });

  /// 프로토타입 초기값.
  factory AppState.initial() => AppState(
        wishes: const [
          Wish(id: 101, text: '면접에서 좋은 결과 받기', cost: 2),
          Wish(id: 102, text: '새로운 좋은 인연이 찾아오기', cost: 3),
          Wish(id: 103, text: '아픈 곳 없이 건강해지기', cost: 3),
          Wish(id: 104, text: '미뤄둔 시험에 합격하기', cost: 4),
        ],
        history: const [
          HistoryEntry(
              id: 3,
              date: '2026.06.16',
              text: '무거운 짐을 드신 할머니를 도와드림.',
              delta: '🍀 잎 +1',
              positive: true),
          HistoryEntry(
              id: 2,
              date: '2026.06.14',
              text: '팀원들에게 따뜻한 아메리카노 기프티콘을 보냄.',
              delta: '🍀 잎 +1',
              positive: true),
          HistoryEntry(
              id: 1,
              date: '2026.06.12',
              text: '[소원 성취] 면접에서 좋은 결과 받기',
              delta: '🍀 클로버 -2',
              positive: false),
        ],
      );

  AppState copyWith({
    AppTab? tab,
    ArchiveFilter? archiveFilter,
    int? leaves,
    int? clovers,
    bool? celebrate,
    int? bounceKey,
    int? statLeaves,
    int? statClovers,
    int? statWishes,
    List<Wish>? wishes,
    List<HistoryEntry>? history,
  }) {
    return AppState(
      tab: tab ?? this.tab,
      archiveFilter: archiveFilter ?? this.archiveFilter,
      leaves: leaves ?? this.leaves,
      clovers: clovers ?? this.clovers,
      celebrate: celebrate ?? this.celebrate,
      bounceKey: bounceKey ?? this.bounceKey,
      statLeaves: statLeaves ?? this.statLeaves,
      statClovers: statClovers ?? this.statClovers,
      statWishes: statWishes ?? this.statWishes,
      wishes: wishes ?? this.wishes,
      history: history ?? this.history,
    );
  }

  /// 영구 저장 대상(탭/애니메이션 등 UI 휘발 상태는 제외).
  Map<String, dynamic> toJson() => {
        'leaves': leaves,
        'clovers': clovers,
        'statLeaves': statLeaves,
        'statClovers': statClovers,
        'statWishes': statWishes,
        'wishes': wishes.map((w) => w.toJson()).toList(),
        'history': history.map((h) => h.toJson()).toList(),
      };

  factory AppState.fromJson(Map<String, dynamic> j) => AppState(
        leaves: j['leaves'] as int? ?? 2,
        clovers: j['clovers'] as int? ?? 2,
        statLeaves: j['statLeaves'] as int? ?? 34,
        statClovers: j['statClovers'] as int? ?? 8,
        statWishes: j['statWishes'] as int? ?? 6,
        wishes: (j['wishes'] as List<dynamic>?)
                ?.map((e) => Wish.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        history: (j['history'] as List<dynamic>?)
                ?.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
