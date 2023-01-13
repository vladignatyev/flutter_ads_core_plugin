import 'package:flutter/material.dart';

class NativeAdContainer {
  final Widget? adView;

  NativeAdContainer(this.adView);

  Widget getView() {    
    return adView ?? Container();
  }
}
