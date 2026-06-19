import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ooloo/models/app_state.dart';
import 'package:ooloo/models/deed.dart';
import 'package:ooloo/models/wish.dart';
import 'package:ooloo/state/app_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  ProviderContainer makeContainer() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('초기 상태: 잎 2, 클로버 5, 소원 4개', () {
    final c = makeContainer();
    final s = c.read(appControllerProvider);
    expect(s.leaves, 2);
    expect(s.clovers, 5);
    expect(s.wishes.length, 4);
    expect(s.completedWishes, isEmpty);
    expect(s.wishes.first.deposited, 2); // cost 4, deposited 2
  });

  test('선행 기록 → 잎 +1, 모은 기록 추가', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    final completed = n.recordDeed('문을 잡아드렸다');
    final s = c.read(appControllerProvider);
    expect(completed, false); // 2 → 3, 아직 미완성
    expect(s.leaves, 3);
    expect(s.statLeaves, 35);
    expect(s.history.first.text, '문을 잡아드렸다');
    expect(s.history.first.positive, true);
  });

  test('4잎 완성 → completed=true, 완성 연출 트리거', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    n.recordDeed('1');
    final completed = n.recordDeed('2'); // 2 → 3 → 4
    expect(completed, true);
    expect(c.read(appControllerProvider).leaves, 4);
    expect(c.read(appControllerProvider).celebrate, true);
  });

  test('빈 문자열은 기록되지 않는다', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    final before = c.read(appControllerProvider).leaves;
    n.recordDeed('   ');
    expect(c.read(appControllerProvider).leaves, before);
  });

  test('클로버 담기 → deposited +1, 보유 클로버 -1', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    final wish = c.read(appControllerProvider).wishes.first; // cost 4, deposited 2, clovers 5
    final justCompleted = n.depositClover(wish);
    final s = c.read(appControllerProvider);
    expect(justCompleted, false); // 2 → 3, 아직 미완성
    expect(s.wishes.first.deposited, 3);
    expect(s.clovers, 4); // 5 → 4
  });

  test('소원 완성 → 도감 이동 + 사용 기록 추가', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    final wish = c.read(appControllerProvider).wishes.first; // cost 4, deposited 2
    n.depositClover(wish); // 3/4
    final justCompleted = n.depositClover(wish); // 4/4
    expect(justCompleted, true);
    n.completeWish(wish); // 오버레이가 광고 종료 후 호출하는 단계
    final s = c.read(appControllerProvider);
    expect(s.wishes.any((w) => w.id == wish.id), false); // 활성 목록에서 제거
    expect(s.completedWishes.first.id, wish.id);
    expect(s.completedWishes.first.completedAt, isNotNull);
    expect(s.tab, AppTab.dex); // 완성 후 도감 탭으로 이동
    expect(s.clovers, 3); // 5 → 3 (2개 담음)
    expect(s.statWishes, 7);
    expect(s.history.first.text, wish.text); // 접두어 없이 소원 텍스트만 저장
    expect(s.history.first.kind, HistoryKind.wish);
    expect(s.history.first.positive, false);
  });

  test('목록에 없는 소원은 담기지 않는다', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    const ghost = Wish(id: 999, text: '없는 소원', cost: 3);
    expect(n.depositClover(ghost), false);
    expect(c.read(appControllerProvider).clovers, 5); // 변화 없음
  });

  test('보유 클로버 0이면 더 담기지 않는다', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    // 보유 클로버 5개를 모두 소진한다(가득 차지 않은 소원에 차례로 담기).
    var guard = 0;
    while (c.read(appControllerProvider).clovers > 0 && guard < 20) {
      final active =
          c.read(appControllerProvider).wishes.firstWhere((w) => w.deposited < w.cost);
      n.depositClover(active);
      guard++;
    }
    expect(c.read(appControllerProvider).clovers, 0);
    final any = c.read(appControllerProvider).wishes.first;
    expect(n.depositClover(any), false); // 보유 0 → 담기 불가
  });

  test('사용 기록 필터가 부정(소원) 항목만 보여준다', () {
    final c = makeContainer();
    final s = c.read(appControllerProvider);
    final spend = s.history.where((h) => !h.positive).toList();
    expect(spend.every((h) => h.kind == HistoryKind.wish), true);
  });

  test('상태가 JSON 으로 직렬화/복원된다', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    n.recordDeed('테스트 선행');
    final json = c.read(appControllerProvider).toJson();
    final restored = AppState.fromJson(json);
    expect(restored.leaves, c.read(appControllerProvider).leaves);
    expect(restored.history.length, c.read(appControllerProvider).history.length);
  });
}
