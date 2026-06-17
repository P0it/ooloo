import 'package:flutter/material.dart';

import '../models/wish.dart';
import '../theme/app_theme.dart';
import 'clover_mark.dart';
import 'pressable.dart';

/// 소원 사용 확인 시트. [사용 확인] 시 true 반환.
Future<bool> showWishConfirmSheet(BuildContext context, Wish wish) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.backdrop,
    builder: (_) => _WishConfirmSheet(wish: wish),
  );
  return result ?? false;
}

class _WishConfirmSheet extends StatelessWidget {
  final Wish wish;
  const _WishConfirmSheet({required this.wish});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
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
          Text('이 소원을 빌까요?',
              style: AppText.base(size: 22, weight: FontWeight.w700, letterSpacingEm: -0.03)),
          const SizedBox(height: 6),
          Text('소원을 빌면 클로버를 소모해요.',
              style: AppText.base(size: 14, weight: FontWeight.w500, color: AppColors.muted)),
          const SizedBox(height: 20),
          // 소원 카드
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
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CloverMark(size: 16),
                    const SizedBox(width: 5),
                    Text('${wish.cost}개 소모',
                        style: AppText.base(
                            size: 14, weight: FontWeight.w600, color: AppColors.muted)),
                  ],
                ),
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
                    child: Text('취소',
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
                    child: Text('사용 확인',
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
