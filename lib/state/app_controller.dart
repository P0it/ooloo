import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_state.dart';
import '../models/deed.dart';
import '../models/wish.dart';

const _prefsKey = 'ooloo_app_state_v1';

final appControllerProvider =
    NotifierProvider<AppController, AppState>(AppController.new);

class AppController extends Notifier<AppState> {
  SharedPreferences? _prefs;

  @override
  AppState build() {
    _load();
    return AppState.initial();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_prefsKey);
    if (raw != null) {
      try {
        state = AppState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        /* corrupted -> keep initial */
      }
    }
  }

  Future<void> _persist() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_prefsKey, jsonEncode(state.toJson()));
  }

  String _today() {
    final d = DateTime.now();
    String p(int n) => n.toString().padLeft(2, '0');
    return '${d.year}.${p(d.month)}.${p(d.day)}';
  }

  // ---- navigation ----
  void setTab(AppTab t) => state = state.copyWith(tab: t);
  void setArchiveFilter(ArchiveFilter f) =>
      state = state.copyWith(archiveFilter: f);

  // ---- 선행 기록 ----
  /// 잎 하나를 채운다. 반환값: 이번 기록으로 클로버가 완성되었는지 여부.
  bool recordDeed(String rawDeed) {
    final deed = rawDeed.trim();
    if (deed.isEmpty) return false;
    final leaves = state.leaves + 1;
    state = state.copyWith(
      leaves: leaves,
      statLeaves: state.statLeaves + 1,
      bounceKey: state.bounceKey + 1,
      celebrate: leaves >= 4,
      history: [
        HistoryEntry(
            id: DateTime.now().millisecondsSinceEpoch,
            date: _today(),
            text: deed,
            delta: '🍀 잎 +1',
            positive: true),
        ...state.history,
      ],
    );
    _persist();
    if (leaves >= 4) {
      // 완성 축하 애니메이션 후 잎 초기화 + 보유 클로버 +1.
      Future.delayed(const Duration(milliseconds: 1100), finishCloverCelebration);
    }
    return leaves >= 4;
  }

  /// 클로버 완성 연출 후 잎 초기화 + 보유 클로버 +1.
  void finishCloverCelebration() {
    if (state.leaves < 4) return;
    state = state.copyWith(
      leaves: 0,
      celebrate: false,
      clovers: state.clovers + 1,
      statClovers: state.statClovers + 1,
    );
    _persist();
  }

  // ---- 소원 ----
  bool canAfford(Wish w) => state.clovers >= w.cost;

  /// 소원 확정(차감 + 기록). 수익화 플로우의 광고 종료 후 호출된다.
  void grantWish(Wish w) {
    if (state.clovers < w.cost) return;
    state = state.copyWith(
      clovers: state.clovers - w.cost,
      statWishes: state.statWishes + 1,
      history: [
        HistoryEntry(
            id: DateTime.now().millisecondsSinceEpoch,
            date: _today(),
            text: '[소원 성취] ${w.text}',
            delta: '🍀 클로버 -${w.cost}',
            positive: false),
        ...state.history,
      ],
    );
    _persist();
  }

  void addWish(String rawText, int cost) {
    final t = rawText.trim();
    if (t.isEmpty) return;
    state = state.copyWith(
      wishes: [
        ...state.wishes,
        Wish(id: DateTime.now().millisecondsSinceEpoch, text: t, cost: cost),
      ],
    );
    _persist();
  }
}
