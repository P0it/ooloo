import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/wish.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/clover_mark.dart';
import '../widgets/dashed_rect.dart';
import '../widgets/deposit_confirm_sheet.dart';
import '../widgets/pressable.dart';
import '../widgets/wish_grant_overlay.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  bool _adding = false;
  final _wishController = TextEditingController();
  int _cost = 1;

  @override
  void dispose() {
    _wishController.dispose();
    super.dispose();
  }

  // 클로버 1개 담기 → 확인 → (가득 차면) 완성 연출/광고 플로우 진입.
  Future<void> _deposit(Wish w) async {
    final confirmed = await showDepositConfirmSheet(context, w);
    if (!confirmed || !mounted) return;
    final justCompleted = ref.read(appControllerProvider.notifier).depositClover(w);
    if (justCompleted && mounted) runWishGrantFlow(context, ref, w);
  }

  void _addWish() {
    final text = _wishController.text.trim();
    if (text.isEmpty) return;
    ref.read(appControllerProvider.notifier).addWish(text, _cost);
    setState(() {
      _adding = false;
      _wishController.clear();
      _cost = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(appControllerProvider);

    return ListView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        // ---- 헤더 ----
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.storeTitle,
                  style: AppText.base(size: 30, weight: FontWeight.w800, letterSpacingEm: -0.035)),
              const SizedBox(height: 12),
              // 보유 클로버 칩
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.chipFull),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0D191F28), blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.storeOwnedLabel,
                        style: AppText.base(
                            size: 14, weight: FontWeight.w600, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    const CloverMark(size: 17),
                    const SizedBox(width: 4),
                    Text(l.storeCloverCount(s.clovers),
                        style: AppText.base(size: 16, weight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
        // ---- 소원 리스트 ----
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            children: [
              for (final w in s.wishes) ...[
                _WishCard(
                  wish: w,
                  owned: s.clovers,
                  onDeposit: () => _deposit(w),
                ),
                const SizedBox(height: 12),
              ],
              if (_adding) _buildAddForm() else _buildAddButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Pressable(
      onTap: () => setState(() => _adding = true),
      child: DashedRect(
        color: AppColors.dashed,
        radius: AppRadius.card,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Text(AppLocalizations.of(context).storeAddWish,
              style: AppText.base(size: 15, weight: FontWeight.w600, color: AppColors.muted)),
        ),
      ),
    );
  }

  Widget _buildAddForm() {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0F191F28), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            child: TextField(
              controller: _wishController,
              style: AppText.base(size: 15, weight: FontWeight.w500),
              cursorColor: AppColors.accent,
              decoration: InputDecoration.collapsed(
                hintText: l.storeWishHint,
                hintStyle: AppText.base(size: 15, weight: FontWeight.w500, color: AppColors.muted),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.storeRequiredClovers,
                  style: AppText.base(size: 14, weight: FontWeight.w600, color: AppColors.sub)),
              Row(
                children: [
                  _stepBtn('−', () => setState(() => _cost = (_cost - 1).clamp(1, 9))),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 20,
                    child: Text('$_cost',
                        textAlign: TextAlign.center,
                        style: AppText.base(size: 16, weight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 14),
                  _stepBtn('+', () => setState(() => _cost = (_cost + 1).clamp(1, 9))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Pressable(
                  onTap: () => setState(() {
                    _adding = false;
                    _wishController.clear();
                    _cost = 1;
                  }),
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(l.commonCancel,
                        style: AppText.base(
                            size: 15, weight: FontWeight.w700, color: AppColors.sub)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Pressable(
                  onTap: _addWish,
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(l.storeAddWishConfirm,
                        style: AppText.base(
                            size: 15, weight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepBtn(String label, VoidCallback onTap) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: AppText.base(size: 18, weight: FontWeight.w700, color: AppColors.sub)),
      ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final Wish wish;
  final int owned; // 보유 클로버
  final VoidCallback onDeposit;

  const _WishCard({required this.wish, required this.owned, required this.onDeposit});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final full = wish.deposited >= wish.cost;
    final canDeposit = owned > 0 && !full;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 진행 칩
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(wish.text,
                    style: AppText.base(size: 16, weight: FontWeight.w600, height: 1.4)),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadius.chipFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CloverMark(size: 13),
                    const SizedBox(width: 4),
                    Text('${wish.deposited} / ${wish.cost}',
                        style: AppText.base(
                            size: 13, weight: FontWeight.w700, color: AppColors.accent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 채워지는 클로버 줄
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < wish.cost; i++)
                CloverMark(size: 22, color: i < wish.deposited ? null : AppColors.emptyLeaf),
            ],
          ),
          const SizedBox(height: 16),
          // 담기 버튼
          Pressable(
            onTap: canDeposit ? onDeposit : null,
            child: Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: canDeposit ? AppColors.accent : AppColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                full
                    ? l.storeDepositFull
                    : canDeposit
                        ? l.storeDeposit
                        : l.storeNotEnough,
                style: AppText.base(
                  size: 14,
                  weight: FontWeight.w700,
                  color: canDeposit ? Colors.white : AppColors.disabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
