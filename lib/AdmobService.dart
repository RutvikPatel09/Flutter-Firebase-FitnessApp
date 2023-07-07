import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3571059927510987/8066630031';
    } else {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('Ad loaded.'),
      onAdOpened: (ad) => debugPrint('Ad opened'),
      onAdClosed: (ad) => debugPrint('Ad closed'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad Failed to load: $error');
      });
}
