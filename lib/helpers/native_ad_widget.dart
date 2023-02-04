import 'package:flutter/material.dart';
import 'package:flutter_ads_core_plugin/shared/custom_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeletons/skeletons.dart';


class NativeAdWidget extends StatefulWidget {
  final String adUnitId;
  final VoidCallback? onClick;
  final VoidCallback? onShow;

  final CustomOptions nativeAdWidgetOptions;

  /// use NativeAdFabricNames class
  final String nativeFactoryName;

  const NativeAdWidget(
      {Key? key,
      required this.adUnitId,
      this.onClick,
      this.onShow,
      required this.nativeAdWidgetOptions,      
      required this.nativeFactoryName})
      : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? nativeAd;
  bool isLoading = true;
  AdWithView? adWithView;

  double blockHeight = 150; // TODO:

  @override
  void initState() {
    super.initState();

    print("NATIVE AD loading..");

    Map<String, Object> options = widget.nativeAdWidgetOptions.convertToMap();

    // if (widget.nativeAdWidgetOptions.showMedia == true) {
    //   options['showMedia'] = 'true';
    //   blockHeight = widget.nativeAdWidgetOptions.heightWithMedia;
    // } else {
    //   blockHeight = widget.nativeAdWidgetOptions.heightWithoutMedia;
    // }

    NativeAd(
            nativeAdOptions: NativeAdOptions(
                videoOptions: VideoOptions(
                    startMuted: true,
                    customControlsRequested: false,
                    clickToExpandRequested: false)),
            adUnitId: widget.adUnitId,
            customOptions: options,
            factoryId: widget.nativeFactoryName,
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
      height: blockHeight,
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
          ),
          // widget.nativeAdWidgetOptions.showMedia
          //     ? const Padding(
          //         padding: EdgeInsets.all(12),
          //         child: SkeletonLine(style: SkeletonLineStyle(height: 180)),
          //       )
          //     :
          Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return skeletonWidget(context);
    } else {
      return SizedBox(height: blockHeight, child: AdWidget(ad: adWithView!));
    }
  }
}
