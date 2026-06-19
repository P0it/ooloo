import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/wish.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/clover_mark.dart';
import '../widgets/pressable.dart';
import 'wish_talisman_screen.dart';

/// 소원 도감 — 완성되어 모인 소원을 2열 그리드로 보여준다.
class DexScreen extends ConsumerWidget {
  const DexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final done = ref.watch(appControllerProvider.select((s) => s.completedWishes));

    return ListView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 4),
          child: Text(l.dexTitle,
              style: AppText.base(size: 30, weight: FontWeight.w800, letterSpacingEm: -0.035)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Text(l.dexSubtitle,
              style: AppText.base(size: 14, weight: FontWeight.w500, color: AppColors.muted)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
          child: done.isEmpty
              ? _emptyState(context)
              : GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.92,
                  children: [for (final w in done) _DexCard(wish: w)],
                ),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Opacity(opacity: 0.5, child: const CloverMark(size: 30, withStem: true)),
          const SizedBox(height: 12),
          Text(l.dexEmptyTitle,
              style: AppText.base(size: 15, weight: FontWeight.w600, color: AppColors.sub)),
          const SizedBox(height: 6),
          Text(l.dexEmptyDesc,
              style: AppText.base(size: 13, weight: FontWeight.w500, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _DexCard extends StatelessWidget {
  final Wish wish;
  const _DexCard({required this.wish});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Pressable(
      onTap: () => Navigator.of(context).push(wishTalismanRoute(wish)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 달성 배지
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.chipFull),
              ),
              child: Text(l.dexDelivered,
                  style: AppText.base(
                      size: 11, weight: FontWeight.w700, color: AppColors.accent)),
            ),
            const SizedBox(height: 10),
            Text(wish.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.base(size: 15, weight: FontWeight.w600, height: 1.4)),
            const Spacer(),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [for (var i = 0; i < wish.cost; i++) const CloverMark(size: 18)],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(wish.completedAt ?? '',
                    style: AppText.base(
                        size: 12, weight: FontWeight.w600, color: AppColors.muted)),
                const Spacer(),
                // 부적으로 만들기 힌트
                Icon(Icons.ios_share_rounded, size: 13, color: AppColors.accent),
                const SizedBox(width: 3),
                Text(l.dexTalismanLabel,
                    style: AppText.base(
                        size: 11, weight: FontWeight.w700, color: AppColors.accent)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
