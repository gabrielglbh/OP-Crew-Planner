import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// BANNER
/// Always appear on the main screen above the search bar
/// Always appear on the bottom of the unit data info
///
/// INTERSTITIAL
/// Appears upon creating a new unit, team or rumble team
/// Appears upon performing an operation in the backup

class AdManager {
  /// false --> RELEASE
  /// --------------------------
  /// true --> DEVELOPMENT
  static const bool test = false;

  static BannerAd? _bannerAd;
  static InterstitialAd? _interstitialAd;

  static const int _maxFailedLoadAttempts = 3;
  static int _numInterstitialLoadAttempts = 0;

  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return "[GOOGLE-ANDROID-AD-BANNER-ID]";
    } else if (Platform.isIOS) {
      return "[GOOGLE-iOS-AD-BANNER-ID]";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "[GOOGLE-ANDROID-AD-INTERSTITIAL-ID]";
    } else if (Platform.isIOS) {
      return "[GOOGLE-iOS-AD-INTERSTITIAL-ID]";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static createBanner(
      {required Function onLoaded, required Function onFailed}) {
    _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(onAdLoaded: (Ad ad) {
          print("AD LOADED ------------- Ad Code: ${ad.adUnitId}");
          onLoaded();
        }, onAdFailedToLoad: (Ad ad, err) {
          print("AD ERROR ------------- Error: ${err.message}.");
          onFailed();
          ad.dispose();
        }));
    _bannerAd?.load();
  }

  static Container showBanner() {
    if (_bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        child: AdWidget(ad: _bannerAd!),
        width: _bannerAd?.size.width.toDouble(),
        height: _bannerAd?.size.height.toDouble(),
      );
    } else {
      return Container();
    }
  }

  static createInterstitial(
      {required Function onLoaded,
      required Function onFailed,
      required Function onClosed}) {
    InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          onLoaded();
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd?.setImmersiveMode(true);
        }, onAdFailedToLoad: (LoadAdError error) {
          onFailed();
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= _maxFailedLoadAttempts) {
            createInterstitial(
                onLoaded: onLoaded, onFailed: onFailed, onClosed: onClosed);
          }
        }));
  }

  static void showInterstitial(
      {required Function onLoaded,
      required Function onFailed,
      required Function onClosed}) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd?.fullScreenContentCallback =
        FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      onClosed();
      createInterstitial(
          onLoaded: onLoaded, onFailed: onFailed, onClosed: onClosed);
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      createInterstitial(
          onLoaded: onLoaded, onFailed: onFailed, onClosed: onClosed);
    });
    _interstitialAd?.show();
    _interstitialAd = null;
  }

  static void disposeBanner() => _bannerAd?.dispose();

  static void disposeInterstitial() => _interstitialAd?.dispose();
}
