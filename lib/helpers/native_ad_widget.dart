import 'package:flutter/material.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:flutter_ads_core_plugin/shared/custom_options.dart';
import 'package:flutter_ads_core_plugin/shared/view_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeletons/skeletons.dart';

class NativeAdWidget extends StatefulWidget {
  final String adUnitId;
  final VoidCallback? onClick;
  final VoidCallback? onShow;

  final CustomOptions nativeAdWidgetOptions;

  /// Use NativeAdFactories class
  final String nativeAdFactory;

  const NativeAdWidget(
      {Key? key,
      required this.adUnitId,
      this.onClick,
      this.onShow,
      required this.nativeAdWidgetOptions,
      required this.nativeAdFactory})
      : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? nativeAd;
  bool isLoading = true;
  AdWithView? adWithView;  

  @override
  void initState() {
    super.initState();

    print("NATIVE AD loading..");

    Map<String, Object> options = widget.nativeAdWidgetOptions.convertToMap();

    NativeAd(
            nativeAdOptions: NativeAdOptions(
                videoOptions: VideoOptions(
                    startMuted: true,
                    customControlsRequested: false,
                    clickToExpandRequested: false)),
            adUnitId: widget.adUnitId,
            customOptions: options,
            factoryId: widget.nativeAdFactory,
            listener: NativeAdListener(
              onAdFailedToLoad: (ad, error) {
                print(error);
              },
              onAdLoaded: (ad) {
                adWithView = ad as NativeAd?;

                isLoading = false;

                setState(() {});
              },
            ),
            request: const AdRequest())
        .load();
  }

  Widget skeletonWidget(BuildContext context) {
    return SizedBox(
      height: ViewOptions.getOptions(widget.nativeAdFactory).height,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.rectangle, width: 80, height: 80),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                      lines: 5,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 15,
                        minLength: MediaQuery.of(context).size.width * 0.3,
                        maxLength: MediaQuery.of(context).size.width * 0.7,
                      )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return skeletonWidget(context);
    } else {
      return SizedBox(height: ViewOptions.getOptions(widget.nativeAdFactory).height, child: AdWidget(ad: adWithView!));
    }
  }
}
