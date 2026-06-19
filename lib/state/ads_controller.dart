import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/ad_config.dart';

/// 전면(인터스티셜) 광고 관리.
/// 광고 ID 설정은 [AdConfig] (lib/config/ad_config.dart) 한 곳에서 관리합니다.
class AdsController {
  AdsController._();
  static final AdsController instance = AdsController._();

  InterstitialAd? _interstitial;
  bool _loading = false;
  int _retries = 0;
  static const _maxRetries = 4;

  bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// 앱 시작 시 1회, 그리고 광고 소비 후마다 미리 로드.
  /// 로드 실패(No fill 등)는 일시적일 수 있어 지수 백오프로 재시도한다.
  void preload() {
    if (!_supported || _loading || _interstitial != null) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _loading = false;
          _retries = 0;
        },
        onAdFailedToLoad: (err) {
          _interstitial = null;
          _loading = false;
          debugPrint('Interstitial load failed: $err');
          // 일시적 실패는 재시도(2s, 4s, 8s, 16s). 소진 시 다음 소비 때 다시 시도.
          if (_retries < _maxRetries) {
            _retries++;
            Future.delayed(Duration(seconds: 1 << _retries), preload);
          }
        },
      ),
    );
  }

  /// 전면 광고를 보여준다. 광고가 닫히거나 표시 불가하면 [onDone] 호출.
  /// 광고 유무와 무관하게 [onDone] 은 반드시 한 번 실행된다.
  void showInterstitial({required VoidCallback onDone}) {
    final ad = _interstitial;
    if (!_supported || ad == null) {
      onDone();
      preload(); // 다음 기회를 위해 재시도
      return;
    }
    _interstitial = null; // 소비

    var finished = false;
    void finishOnce() {
      if (finished) return;
      finished = true;
      preload(); // 다음 광고 미리 로드
      onDone();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        finishOnce();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        debugPrint('Interstitial show failed: $err');
        finishOnce();
      },
    );
    ad.show();
  }
}
