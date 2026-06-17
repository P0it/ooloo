import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ooloo/screens/home_shell.dart';
import 'package:ooloo/state/ads_controller.dart';
import 'package:ooloo/theme/app_theme.dart';

Widget _app() => ProviderScope(
      child: MaterialApp(theme: buildAppTheme(), home: const HomeShell()),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // 모달/시트가 화면 안에 들어오도록 폰 크기 캔버스로 설정.
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_app());
    await tester.pump();
  }

  testWidgets('홈 화면이 렌더링된다 (클로버 페인터 포함)', (tester) async {
    await pumpApp(tester);
    expect(find.text('오늘도 따뜻한 하루'), findsOneWidget);
    expect(find.text('오늘의 선행 기록하기'), findsOneWidget);
  });

  testWidgets('탭으로 세 화면을 모두 오갈 수 있다', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('소원 상점'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('보유한 클로버'), findsOneWidget);
    expect(find.text('면접에서 좋은 결과 받기'), findsOneWidget);

    await tester.tap(find.text('나의 기록'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('나의 선행 기록'), findsOneWidget);
    expect(find.text('총 채운 잎'), findsOneWidget);

    await tester.tap(find.text('홈'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('오늘의 선행 기록하기'), findsOneWidget);
  });

  testWidgets('선행 기록 시트로 잎을 채운다', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('오늘의 선행 기록하기'));
    await tester.pump(); // 모달 entrance 시작
    await tester.pump(const Duration(milliseconds: 400)); // entrance 진행 완료(화면 안)
    expect(find.text('어떤 선행을 베푸셨나요?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '쓰레기를 주웠다');
    await tester.pump();
    await tester.tap(find.text('기록 완료하고 잎 채우기'));
    await tester.pump(); // 탭 처리 → pop 예약 + 토스트 삽입
    await tester.pump(const Duration(milliseconds: 400)); // 시트 닫힘 애니메이션
    await tester.pump(const Duration(milliseconds: 400)); // 라우트 제거 + 정착

    // 시트가 닫히고 잎 채움 토스트가 뜬다.
    expect(find.text('어떤 선행을 베푸셨나요?'), findsNothing);
    expect(find.text('잎을 채웠어요'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200)); // 토스트 타이머 flush
  });

  testWidgets('AdsController 는 비-모바일에서 광고를 스킵하고 onDone 을 호출한다', (tester) async {
    bool done = false;
    AdsController.instance.showInterstitial(onDone: () => done = true);
    expect(done, true);
  });

  testWidgets('소원 사용 플로우: 확인 → 전달 연출 → (광고 스킵) → 클로버 차감', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('소원 상점'));
    await tester.pump(const Duration(milliseconds: 400)); // 홈 클로버 dispose 까지 전환 완료

    // 첫 소원(면접, cost 2, 보유 2) → 소원 빌기 (스토어 탭엔 무한 애니메이션이 없어 settle 가능)
    await tester.tap(find.text('소원 빌기').first);
    await tester.pumpAndSettle();
    expect(find.text('이 소원을 빌까요?'), findsOneWidget);

    await tester.tap(find.text('사용 확인'));
    await tester.pumpAndSettle(); // 전달 오버레이 진입 + 연출 정착
    expect(find.text('소원을 전달하고 오겠습니다.'), findsOneWidget);

    // 광고 타이머(1.5s) 발화 → 스킵 → 커밋 → 오버레이 pop
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle(); // pop 전환 정착
    await tester.pump(const Duration(milliseconds: 2200)); // 토스트 타이머 flush

    // 보유 클로버가 2 → 0 으로 차감되어 더 이상 빌 수 없음
    expect(find.text('클로버 부족'), findsWidgets);
  });
}
