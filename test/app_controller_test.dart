import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ooloo/models/app_state.dart';
import 'package:ooloo/models/wish.dart';
import 'package:ooloo/state/app_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  ProviderContainer makeContainer() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('초기 상태: 잎 2, 클로버 2, 소원 4개', () {
    final c = makeContainer();
    final s = c.read(appControllerProvider);
    expect(s.leaves, 2);
    expect(s.clovers, 2);
    expect(s.wishes.length, 4);
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

  test('소원 빌기 → 클로버 차감 + 사용 기록 추가', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    final wish = c.read(appControllerProvider).wishes.first; // cost 2, clovers 2
    expect(n.canAfford(wish), true);
    n.grantWish(wish);
    final s = c.read(appControllerProvider);
    expect(s.clovers, 0);
    expect(s.statWishes, 7);
    expect(s.history.first.text, '[소원 성취] ${wish.text}');
    expect(s.history.first.positive, false);
  });

  test('클로버 부족 시 소원이 빌어지지 않는다', () {
    final c = makeContainer();
    final n = c.read(appControllerProvider.notifier);
    const expensive = Wish(id: 999, text: '비싼 소원', cost: 99);
    expect(n.canAfford(expensive), false);
    n.grantWish(expensive);
    expect(c.read(appControllerProvider).clovers, 2); // 변화 없음
  });

  test('사용 기록 필터가 부정(소원) 항목만 보여준다', () {
    final c = makeContainer();
    final s = c.read(appControllerProvider);
    final spend = s.history.where((h) => !h.positive).toList();
    expect(spend.every((h) => h.text.startsWith('[소원 성취]')), true);
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
