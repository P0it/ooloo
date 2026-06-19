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
  void setArchiveView(ArchiveView v) =>
      state = state.copyWith(archiveView: v);

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
            kind: HistoryKind.deed,
            text: deed,
            amount: 1),
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
  /// 소원에 클로버 1개를 담는다. 보유 클로버 -1, 해당 소원 deposited +1.
  /// 반환값: 이번 담기로 소원이 가득 찼는지(완성됐는지) 여부.
  bool depositClover(Wish w) {
    if (state.clovers <= 0) return false;
    final idx = state.wishes.indexWhere((x) => x.id == w.id);
    if (idx < 0) return false;
    final cur = state.wishes[idx];
    if (cur.deposited >= cur.cost) return false; // 이미 가득
    final updated = cur.copyWith(deposited: cur.deposited + 1);
    final list = [...state.wishes]..[idx] = updated;
    state = state.copyWith(clovers: state.clovers - 1, wishes: list);
    _persist();
    return updated.deposited >= updated.cost;
  }

  /// 소원 완성 처리 — 활성 목록에서 빼서 도감으로 이동 + 기록.
  /// 클로버는 담기 단계에서 이미 차감됐으므로 여기선 차감하지 않는다.
  /// 광고 종료 후 오버레이가 호출한다.
  void completeWish(Wish w) {
    final idx = state.wishes.indexWhere((x) => x.id == w.id);
    if (idx < 0) return;
    final cur = state.wishes[idx];
    final done = cur.copyWith(deposited: cur.cost, completedAt: _today());
    final remaining = [...state.wishes]..removeAt(idx);
    state = state.copyWith(
      tab: AppTab.dex, // 전달 후 소원 도감으로 이동(하이라이트 + 바로 확인)
      wishes: remaining,
      completedWishes: [done, ...state.completedWishes],
      statWishes: state.statWishes + 1,
      history: [
        HistoryEntry(
            id: DateTime.now().millisecondsSinceEpoch,
            date: _today(),
            kind: HistoryKind.wish,
            text: done.text,
            amount: done.cost),
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
