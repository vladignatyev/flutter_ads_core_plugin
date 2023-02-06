import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';

class NativeAdViewOptions {
  final double height;

  const NativeAdViewOptions({this.height = 80});
}

class ViewOptions {
  static const Map<String, NativeAdViewOptions> _options = {
    NativeFactoryNames.inFeedLeft : NativeAdViewOptions(height: 80),
    NativeFactoryNames.inFeedRight : NativeAdViewOptions(height: 80),
    NativeFactoryNames.largeCentered : NativeAdViewOptions(height: 80),
    NativeFactoryNames.largeMediaTop : NativeAdViewOptions(height: 80),
    NativeFactoryNames.largeMediaBottom : NativeAdViewOptions(height: 80),
    NativeFactoryNames.noMediaCentered : NativeAdViewOptions(height: 80)
  };

  static NativeAdViewOptions getOptions(String factoryId) {
    return _options[factoryId] ?? const NativeAdViewOptions();
  }
}
