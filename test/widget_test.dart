import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ooloo/config/daily_quotes.dart';
import 'package:ooloo/l10n/app_localizations.dart';
import 'package:ooloo/screens/home_shell.dart';
import 'package:ooloo/state/ads_controller.dart';
import 'package:ooloo/util/text_wrap.dart';
import 'package:ooloo/theme/app_theme.dart';

// 테스트는 한국어 로케일로 고정해 기존 한글 단언을 그대로 검증한다.
Widget _app() => ProviderScope(
      child: MaterialApp(
        theme: buildAppTheme(),
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeShell(),
      ),
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
    expect(find.text(DailyQuotes.forToday('ko').keepAll), findsOneWidget);
    expect(find.text('오늘의 선행 기록하기'), findsOneWidget);
  });

  testWidgets('탭으로 네 화면을 모두 오갈 수 있다', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('소원 상점'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('보유한 클로버'), findsOneWidget);
    expect(find.text('면접에서 좋은 결과 받기'), findsOneWidget);

    await tester.tap(find.text('소원 도감'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('전한 소원들이 이곳에 모여요'), findsOneWidget);
    expect(find.text('아직 전한 소원이 없어요.'), findsOneWidget);

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

  testWidgets('담기 → 완성(전달 연출 → 광고 스킵) → 소원이 도감으로 이동', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('소원 상점'));
    await tester.pump(const Duration(milliseconds: 400)); // 홈 클로버 dispose 까지 전환 완료

    // 첫 소원(면접, cost 4, deposited 2, 보유 5) → 담기 → 확인 시트 → 담기 → 3/4 (연출 없음)
    await tester.tap(find.text('클로버 담기').first);
    await tester.pumpAndSettle(); // 확인 시트 진입
    expect(find.text('클로버를 담을까요?'), findsOneWidget);
    await tester.tap(find.text('담기'));
    await tester.pumpAndSettle(); // 시트 닫힘
    expect(find.text('3 / 4'), findsOneWidget);

    // 한 번 더 담기 → 확인 시트가 '완성' 문구 → 완성하기 → 전달 연출 진입
    await tester.tap(find.text('클로버 담기').first);
    await tester.pumpAndSettle();
    expect(find.text('소원을 완성할까요?'), findsOneWidget);
    await tester.tap(find.text('완성하기'));
    await tester.pumpAndSettle(); // 전달 오버레이 진입 + 연출 정착
    expect(find.text('소원을 전달하고 오겠습니다.'), findsOneWidget);

    // 광고 타이머(1.5s) 발화 → 스킵 → completeWish → 오버레이 pop
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle(); // pop 전환 정착
    await tester.pump(const Duration(milliseconds: 2200)); // 토스트 타이머 flush

    // 완성 후 자동으로 소원 도감 탭으로 이동하고, 소원이 도감에 담긴다.
    expect(find.text('전한 소원들이 이곳에 모여요'), findsOneWidget); // 도감 화면이 떠 있음
    expect(find.text('면접에서 좋은 결과 받기'), findsOneWidget);
    expect(find.text('전달 완료'), findsWidgets);
  });
}
