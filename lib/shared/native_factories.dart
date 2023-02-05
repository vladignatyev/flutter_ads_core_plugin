
class NativeAdViewOptions {
  final double height;

  const NativeAdViewOptions({this.height = 80});
}

class NativeAdFactory {
  final String factoryName;
  final NativeAdViewOptions viewOptions;

  const NativeAdFactory({required this.factoryName, required this.viewOptions});
}

class NativeAdFactories {
  static NativeAdFactory inFeedLeft =
      const NativeAdFactory(factoryName: "in_feed_left", viewOptions: NativeAdViewOptions());

  static NativeAdFactory inFeedRight =
      const NativeAdFactory(factoryName: "in_feed_right", viewOptions: NativeAdViewOptions());

  static NativeAdFactory largeCentered =
      const NativeAdFactory(factoryName: "large_centered", viewOptions: NativeAdViewOptions());

  static NativeAdFactory largeMediaTop =
      const NativeAdFactory(factoryName: "large_media_top", viewOptions: NativeAdViewOptions());

  static NativeAdFactory largeMediaBottom =
      const NativeAdFactory(factoryName: "large_media_bottom", viewOptions: NativeAdViewOptions());

  static NativeAdFactory noMediaCentered =
      const NativeAdFactory(factoryName: "no_media_centered", viewOptions: NativeAdViewOptions());
}

// class NativeFactoryNames {
//   static const String inFeedLeft = "in_feed_left";
//   static const String inFeedRight = "in_feed_right";
//   static const String largeCentered = "large_centered";
//   static const String largeMediaTop = "large_media_top";
//   static const String largeMediaBottom = "large_media_bottom";
//   static const String noMediaCentered = "no_media_centered";
// }
