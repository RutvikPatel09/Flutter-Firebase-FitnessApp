import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'AdmobService.dart';

class TestADS extends StatefulWidget {
  const TestADS({super.key});

  @override
  State<TestADS> createState() => _TestADSState();
}

class _TestADSState extends State<TestADS> {
  BannerAd? _banner;
  String? statusToString;
  @override
  void initState() {
    super.initState();
    loadStatusData();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();
    // }
  }

  void loadStatusData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("controlGoogleAds");
    QuerySnapshot querySnapshot = await collectionReference.get();

    final status = querySnapshot.docs.map((e) => e['AdStatus']);
    String statusToString1 = status.join();
    setState(() {
      statusToString = statusToString1;
      //print(statusToString.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: statusToString == 'false'
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              ));
  }
}
