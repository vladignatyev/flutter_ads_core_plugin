import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';

class NativeAdViewOptions {
  final double height;

  const NativeAdViewOptions({this.height = 80});
}

class ViewOptions {
  static const Map<String, NativeAdViewOptions> _options = {
    NativeFactoryNames.inFeedLeft : NativeAdViewOptions(height: 140),
    NativeFactoryNames.inFeedRight : NativeAdViewOptions(height: 140),
    NativeFactoryNames.largeCentered : NativeAdViewOptions(height: 580),
    NativeFactoryNames.largeMediaTop : NativeAdViewOptions(height: 360),
    NativeFactoryNames.largeMediaBottom : NativeAdViewOptions(height: 360),
    NativeFactoryNames.noMediaCentered : NativeAdViewOptions(height: 240),
		NativeFactoryNames.largeMediaFlex : NativeAdViewOptions(height: 360)
  };

  static NativeAdViewOptions getOptions(String factoryId) {
    return _options[factoryId] ?? const NativeAdViewOptions();
  }
}
