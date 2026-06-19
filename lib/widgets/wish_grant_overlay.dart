import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/wish.dart';
import '../state/ads_controller.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import 'clover_mark.dart';
import 'ooloo_toast.dart';

/// 소원 전달 → 전면 광고 → 확정 까지의 전체 플로우.
/// 확인 시트에서 [사용 확인] 후 호출.
Future<void> runWishGrantFlow(BuildContext context, WidgetRef ref, Wish wish) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) => _WishGrantOverlay(wish: wish),
      transitionsBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    ),
  );
}

class _WishGrantOverlay extends ConsumerStatefulWidget {
  final Wish wish;
  const _WishGrantOverlay({required this.wish});

  @override
  ConsumerState<_WishGrantOverlay> createState() => _WishGrantOverlayState();
}

class _WishGrantOverlayState extends ConsumerState<_WishGrantOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _burst; // 클로버 팝 + 광채
  late final AnimationController _text; // 카피 페이드
  bool _adStarted = false;

  @override
  void initState() {
    super.initState();
    _burst = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..forward();
    _text = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    // 소원이 이뤄지는 느낌의 단계적 햅틱.
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 160), HapticFeedback.mediumImpact);
    Future.delayed(const Duration(milliseconds: 340), HapticFeedback.lightImpact);
    Future.delayed(const Duration(milliseconds: 520), HapticFeedback.selectionClick);

    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _text.forward();
    });
    // 연출 후 전면 광고.
    Future.delayed(const Duration(milliseconds: 1500), _showAd);
  }

  void _showAd() {
    if (_adStarted || !mounted) return;
    _adStarted = true;
    AdsController.instance.showInterstitial(onDone: _commit);
  }

  void _commit() {
    // 광고 종료 후 소원 완성 처리(도감 이동 + 기록). 클로버는 담기 단계에서 이미 차감됨.
    ref.read(appControllerProvider.notifier).completeWish(widget.wish);
    if (!mounted) return;
    final nav = Navigator.of(context);
    // 토스트는 루트 오버레이에 삽입되어 pop 이후에도 유지된다.
    showOolooToast(context, AppLocalizations.of(context).toastWishDelivered);
    nav.pop();
  }

  @override
  void dispose() {
    _burst.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: AnimatedBuilder(
                animation: _burst,
                builder: (_, _) {
                  final t = Curves.easeOut.transform(_burst.value);
                  // 클로버 팝: 0 → 1.15 → 1
                  final pop = t < 0.5 ? 1.15 * (t / 0.5) : 1.15 - 0.15 * ((t - 0.5) / 0.5);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(240, 240),
                        painter: _BurstPainter(_burst.value),
                      ),
                      Transform.scale(
                        scale: pop.clamp(0.0, 1.2),
                        child: const CloverMark(size: 150, withStem: true),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 36),
            FadeTransition(
              opacity: _text,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(
                    CurvedAnimation(parent: _text, curve: Curves.easeOut)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).grantTitle,
                        textAlign: TextAlign.center,
                        style: AppText.base(
                            size: 21, weight: FontWeight.w700, letterSpacingEm: -0.03),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.wish.text,
                        textAlign: TextAlign.center,
                        style: AppText.base(
                            size: 15, weight: FontWeight.w500, color: AppColors.muted, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 광채 링 + 스파클 버스트.
class _BurstPainter extends CustomPainter {
  final double t; // 0..1
  _BurstPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);

    // 두 겹 확산 링
    for (var r = 0; r < 2; r++) {
      final lt = (t - r * 0.12).clamp(0.0, 1.0);
      if (lt <= 0) continue;
      final radius = 40 + (size.width * 0.5) * lt;
      final opacity = (0.45 * (1 - lt)).clamp(0.0, 1.0);
      canvas.drawCircle(
        c,
        radius,
        Paint()
          ..color = AppColors.accent.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    // 스파클 12개
    final sp = t < 0.4 ? (t / 0.4) : (1 - (t - 0.4) / 0.6);
    final spScale = (t < 0.4 ? 1.4 * (t / 0.4) : 1.4 * (1 - (t - 0.4) / 0.6)).clamp(0.0, 1.4);
    final spOpacity = sp.clamp(0.0, 1.0);
    final dist = 70 + 30 * t;
    for (var k = 0; k < 12; k++) {
      final ang = (k * 30) * math.pi / 180;
      final p = c + Offset(dist * math.cos(ang), dist * math.sin(ang));
      canvas.drawCircle(
        p,
        3.2 * spScale,
        Paint()..color = AppColors.accent.withValues(alpha: spOpacity),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}
