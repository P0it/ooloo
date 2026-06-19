import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/wish.dart';
import '../theme/app_theme.dart';
import 'clover_mark.dart';
import 'pressable.dart';

/// 클로버 담기 확인 시트. [담기]/[완성하기] 시 true 반환.
/// 이번 담기로 소원이 가득 차면 완성 문구로 바뀐다.
Future<bool> showDepositConfirmSheet(BuildContext context, Wish wish) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.backdrop,
    builder: (_) => _DepositConfirmSheet(wish: wish),
  );
  return result ?? false;
}

class _DepositConfirmSheet extends StatelessWidget {
  final Wish wish;
  const _DepositConfirmSheet({required this.wish});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final next = wish.deposited + 1; // 담은 후 개수
    final willComplete = next >= wish.cost;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        boxShadow: [BoxShadow(color: Color(0x24191F28), blurRadius: 30, offset: Offset(0, -8))],
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 20),
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppRadius.chipFull),
                ),
              ),
            ),
          ),
          Text(willComplete ? l.depositTitleComplete : l.depositTitle,
              style: AppText.base(size: 22, weight: FontWeight.w700, letterSpacingEm: -0.03)),
          const SizedBox(height: 6),
          Text(
            willComplete ? l.depositDescComplete : l.depositDesc,
            style: AppText.base(size: 14, weight: FontWeight.w500, color: AppColors.muted, height: 1.45),
          ),
          const SizedBox(height: 20),
          // 소원 카드 (진행 미리보기)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wish.text,
                    style: AppText.base(size: 17, weight: FontWeight.w600, height: 1.4)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (var i = 0; i < wish.cost; i++)
                      CloverMark(
                        size: 22,
                        color: i < wish.deposited
                            ? null // 이미 담긴 것: accent
                            : i == wish.deposited
                                ? AppColors.accent.withValues(alpha: 0.4) // 이번에 담을 칸
                                : AppColors.emptyLeaf,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('클로버 ${wish.deposited} / ${wish.cost}  →  $next / ${wish.cost}',
                    style: AppText.base(
                        size: 13, weight: FontWeight.w700, color: AppColors.accent)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Pressable(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    child: Text(l.commonCancel,
                        style: AppText.base(
                            size: 16, weight: FontWeight.w700, color: AppColors.sub)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Pressable(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(willComplete ? l.depositConfirmComplete : l.depositConfirm,
                        style: AppText.base(
                            size: 16, weight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
