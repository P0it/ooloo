import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/locale_controller.dart';
import '../theme/app_theme.dart';
import 'pressable.dart';

/// 언어 선택 바텀시트. '나의 기록' 헤더의 언어 아이콘에서 올라온다.
/// deposit_confirm_sheet 의 시트 패턴(투명 배경 + 핸들 바 + 흰 시트)을 따른다.
Future<void> showLanguageSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.backdrop,
    builder: (_) => const _LanguageSheet(),
  );
}

class _LangOption {
  final String label;
  final Locale? locale; // null = 시스템 따르기
  const _LangOption(this.label, this.locale);
}

class _LanguageSheet extends ConsumerWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final current = ref.watch(localeProvider);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final options = <_LangOption>[
      _LangOption(l.languageSystem, null),
      const _LangOption('한국어', Locale('ko')),
      const _LangOption('English', Locale('en')),
      const _LangOption('日本語', Locale('ja')),
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        boxShadow: [BoxShadow(color: Color(0x24191F28), blurRadius: 30, offset: Offset(0, -8))],
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들 인디케이터
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 18),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
            child: Text(l.languageSheetTitle,
                style: AppText.base(size: 22, weight: FontWeight.w700, letterSpacingEm: -0.03)),
          ),
          for (final opt in options)
            _row(
              context,
              ref,
              opt,
              selected: current?.languageCode == opt.locale?.languageCode,
            ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, WidgetRef ref, _LangOption opt,
      {required bool selected}) {
    return Pressable(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(opt.locale);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(opt.label,
                  style: AppText.base(
                      size: 16,
                      weight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected ? AppColors.accent : AppColors.title)),
            ),
            if (selected)
              const Icon(Icons.check_rounded, size: 20, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
