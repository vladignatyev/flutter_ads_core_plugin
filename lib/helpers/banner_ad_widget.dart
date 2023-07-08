import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeletons/skeletons.dart';

typedef OnAdFailedToLoadCallback = void Function(String errorMessage);

class BannerAdWidget extends StatefulWidget {
  final String adUnit;
  final bool showSkeleton;
  final int timeoutMillis;
  final VoidCallback? onLoaded;
  final OnAdFailedToLoadCallback? onFailedToLoad;
  const BannerAdWidget(
      {Key? key,
      required this.adUnit,
      this.onFailedToLoad,
      required this.onLoaded,
      required this.showSkeleton,      
      this.timeoutMillis = 5000})
      : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  AdWidget? adWidget;

  @override
  void initState() {
    final bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: widget.adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              adWidget = AdWidget(ad: ad as AdWithView);
            });

            if (widget.onLoaded != null) {
              widget.onLoaded!();
            }
          },
          onAdFailedToLoad: (ad, error) {
            if (widget.onFailedToLoad != null) {
              widget.onFailedToLoad!(error.message);
            } else {
              print(error);
            }
          },
        ),
        request: AdRequest(httpTimeoutMillis: widget.timeoutMillis));

    bannerAd.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      double adWidth = AdSize.fullBanner.width.toDouble();
      double adHeight = AdSize.fullBanner.height.toDouble();
      if (adWidget == null) {
        if (widget.showSkeleton) {
          return SizedBox(
              width: adWidth,
              height: adHeight,
              child: SkeletonLine(
                  style: SkeletonLineStyle(width: adWidth, height: adHeight)));
        } else {
          return Container();
        }
      } else {
        return SizedBox(width: adWidth, height: adHeight, child: adWidget);
      }
    });
  }
}
