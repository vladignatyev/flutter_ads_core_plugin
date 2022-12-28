import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeletons/skeletons.dart';

class NativeAdWidget extends StatefulWidget {
  final String adUnitId;
  final VoidCallback? onClick;
  final VoidCallback? onShow;

  /// height if showMedia = true, default 150
  final double heightWithoutMedia;

  /// height if showMedia = false, default 420
  final double heightWithMedia;

  final Color? headlineColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final bool showMedia;

  const NativeAdWidget(
      {Key? key,
      required this.adUnitId,
      this.onClick,
      this.onShow,
      this.headlineColor,
      this.textColor,
      this.backgroundColor,
      this.buttonColor,
      this.buttonTextColor,
      this.showMedia = false,
      this.heightWithoutMedia = 150,
      this.heightWithMedia = 350})
      : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? nativeAd;
  bool isLoading = true;
  AdWithView? adWithView;

  double blockHeight = 150;

  String colorToString(Color color) {
    return '#${color.toString().split('(0x')[1].split(')').first.substring(2).toUpperCase()}';
  }

  @override
  void initState() {
    super.initState();

    print("NATIVE AD loading..");

    Map<String, Object> options = {};
    if (widget.textColor != null) {
      options['bodyTextColor'] = colorToString(widget.textColor!);
    }

    if (widget.headlineColor != null) {
      options['headlineColor'] = colorToString(widget.headlineColor!);
    }

    if (widget.backgroundColor != null) {
      options['backgroundColor'] = colorToString(widget.backgroundColor!);
    }

    if (widget.buttonColor != null) {
      options['buttonBackground'] = colorToString(widget.buttonColor!);
    }

    if (widget.buttonTextColor != null) {
      options['buttonTextColor'] = colorToString(widget.buttonTextColor!);
    }

    if (widget.showMedia == true) {
      options['showMedia'] = 'true';
      blockHeight = widget.heightWithMedia;
    } else {
      blockHeight = widget.heightWithoutMedia;
    }

    NativeAd(
            nativeAdOptions: NativeAdOptions(
                videoOptions: VideoOptions(
                    startMuted: true,
                    customControlsRequested: false,
                    clickToExpandRequested: false)),
            adUnitId: widget.adUnitId,
            customOptions: options,
            factoryId: 'listTile',
            listener: NativeAdListener(
              onAdFailedToLoad: (ad, error) {
                print(error);
              },
              onAdLoaded: (ad) {
                adWithView = ad as NativeAd?;
                print("HUJ");

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

          widget.showMedia ? const Padding(
            padding: EdgeInsets.all(12),
            child: SkeletonLine(style: SkeletonLineStyle(height: 180)),
          ) : Container()
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
