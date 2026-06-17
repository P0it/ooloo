import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wish.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/clover_mark.dart';
import '../widgets/dashed_rect.dart';
import '../widgets/pressable.dart';
import '../widgets/wish_confirm_sheet.dart';
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

  // 소원 사용 → 확인 → 햅틱/애니메이션/광고 → 확정.
  Future<void> _useWish(Wish w) async {
    final confirmed = await showWishConfirmSheet(context, w);
    if (!confirmed || !mounted) return;
    // 확정 직전 재확인 (그 사이 클로버가 부족해졌을 수 있음).
    if (!ref.read(appControllerProvider.notifier).canAfford(w)) return;
    await runWishGrantFlow(context, ref, w);
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
              Text('소원 상점',
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
                    Text('보유한 클로버',
                        style: AppText.base(
                            size: 14, weight: FontWeight.w600, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    const CloverMark(size: 17),
                    const SizedBox(width: 4),
                    Text('${s.clovers}개',
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
                  affordable: s.clovers >= w.cost,
                  onUse: () => _useWish(w),
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
          child: Text('+ 나만의 소원 추가하기',
              style: AppText.base(size: 15, weight: FontWeight.w600, color: AppColors.muted)),
        ),
      ),
    );
  }

  Widget _buildAddForm() {
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
                hintText: '이루고 싶은 나만의 소원',
                hintStyle: AppText.base(size: 15, weight: FontWeight.w500, color: AppColors.muted),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('필요한 클로버',
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
                    child: Text('취소',
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
                    child: Text('소원 추가',
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
  final bool affordable;
  final VoidCallback onUse;

  const _WishCard({required this.wish, required this.affordable, required this.onUse});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wish.text,
                    style: AppText.base(size: 16, weight: FontWeight.w600, height: 1.4)),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CloverMark(size: 14),
                    const SizedBox(width: 4),
                    Text('${wish.cost}개 소모',
                        style: AppText.base(
                            size: 13, weight: FontWeight.w600, color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Pressable(
            onTap: affordable ? onUse : null,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: affordable ? AppColors.accent : AppColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                affordable ? '소원 빌기' : '클로버 부족',
                style: AppText.base(
                  size: 14,
                  weight: FontWeight.w700,
                  color: affordable ? Colors.white : AppColors.disabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
