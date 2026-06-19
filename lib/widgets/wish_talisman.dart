import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/wish.dart';
import '../theme/app_theme.dart';
import 'clover_mark.dart';

/// 부적 이미지의 출력 형태.
/// - portrait: 9:16 세로 — 잠금/배경화면용
/// - square:   1:1 정사각 — 홈 위젯용
enum TalismanFormat { portrait, square }

extension TalismanFormatX on TalismanFormat {
  /// 캡처/렌더의 기준 논리 크기. 캡처 시 pixelRatio 3 → 1080px 기준.
  Size get canvas => this == TalismanFormat.portrait
      ? const Size(360, 640)
      : const Size(360, 360);

  bool get isPortrait => this == TalismanFormat.portrait;
}

/// 완성된 소원을 "행운 부적" 한 장으로 그려내는 위젯.
/// 화면 미리보기와 PNG 캡처 양쪽에 같은 위젯을 쓴다(고정 논리 크기).
/// 과한 장식 없이 — 클로버 문양 + 소원 한 줄 + 날짜 + ooloo 워드마크.
class WishTalisman extends StatelessWidget {
  final Wish wish;
  final TalismanFormat format;
  const WishTalisman({super.key, required this.wish, this.format = TalismanFormat.portrait});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final size = format.canvas;
    final p = format.isPortrait;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          // 전체를 채우는 은은한 세로 그라데이션 (배경화면 시 모서리 빈틈 없음).
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF7FBF3), Color(0xFFE9F2DF)],
                ),
              ),
            ),
          ),
          // 배경에 크게 깔리는 클로버 워터마크.
          Positioned.fill(
            child: Center(
              child: Transform.rotate(
                angle: -12 * math.pi / 180,
                child: CloverMark(
                  size: p ? 300 : 230,
                  withStem: true,
                  color: AppColors.accent.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          // 부적 느낌의 얇은 내부 프레임 (절제된 장식).
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(p ? 14 : 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.20), width: 1.4),
              ),
            ),
          ),
          // 본문.
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: p ? 38 : 30, vertical: p ? 46 : 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(l, p),
                  _center(l, p),
                  _footer(l, p),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(AppLocalizations l, bool p) => Text(
        l.talismanLabel,
        style: AppText.base(
          size: p ? 12 : 11,
          weight: FontWeight.w800,
          color: AppColors.accent,
          letterSpacingEm: 0.34,
        ),
      );

  Widget _center(AppLocalizations l, bool p) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CloverMark(size: p ? 88 : 58, withStem: true),
          SizedBox(height: p ? 26 : 16),
          Text(
            l.talismanCenterLine,
            textAlign: TextAlign.center,
            style: AppText.base(
                size: p ? 13 : 11, weight: FontWeight.w600, color: AppColors.muted),
          ),
          SizedBox(height: p ? 12 : 8),
          Text(
            wish.text,
            textAlign: TextAlign.center,
            maxLines: p ? 4 : 3,
            overflow: TextOverflow.ellipsis,
            style: AppText.base(
              size: p ? 23 : 17,
              weight: FontWeight.w800,
              height: 1.42,
              letterSpacingEm: -0.03,
            ),
          ),
          SizedBox(height: p ? 20 : 14),
          Wrap(
            spacing: p ? 6 : 5,
            runSpacing: p ? 6 : 5,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < wish.cost; i++) CloverMark(size: p ? 16 : 13),
            ],
          ),
        ],
      );

  Widget _footer(AppLocalizations l, bool p) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            wish.completedAt ?? '',
            style: AppText.base(
                size: p ? 12 : 11, weight: FontWeight.w700, color: AppColors.muted),
          ),
          SizedBox(height: p ? 12 : 8),
          Container(width: p ? 26 : 20, height: 1.4, color: AppColors.accent.withValues(alpha: 0.25)),
          SizedBox(height: p ? 12 : 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CloverMark(size: p ? 16 : 14),
              SizedBox(width: p ? 6 : 5),
              Text('ooloo',
                  style: AppText.base(
                      size: p ? 16 : 14, weight: FontWeight.w800, letterSpacingEm: -0.02)),
            ],
          ),
          SizedBox(height: p ? 4 : 3),
          Text(l.talismanTagline,
              style: AppText.base(
                  size: p ? 10.5 : 9.5, weight: FontWeight.w600, color: AppColors.muted)),
        ],
      );
}
