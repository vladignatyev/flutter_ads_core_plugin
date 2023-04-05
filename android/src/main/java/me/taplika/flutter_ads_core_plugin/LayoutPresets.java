package me.taplika.flutter_ads_core_plugin;

import java.util.HashMap;
import java.util.Map;

import me.taplika.flutter_ads_core_plugin.adfactory.AspectRatioDependentNativeAd;
import me.taplika.flutter_ads_core_plugin.adfactory.BasicNativeAd;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;

public class LayoutPresets {
    public static Map<String, NativeAdFactory> factories = new HashMap<String, NativeAdFactory>() {{
        put("in_feed_left", new BasicNativeAd(R.layout.in_feed_left, BasicNativeAd.TextMeasureVariant.side_icon));
        put("in_feed_right", new BasicNativeAd(R.layout.in_feed_right, BasicNativeAd.TextMeasureVariant.side_icon));
        put("large_centered", new BasicNativeAd(R.layout.large_centered, BasicNativeAd.TextMeasureVariant.full_width));
        put("large_media_top", new BasicNativeAd(R.layout.large_media_top, BasicNativeAd.TextMeasureVariant.side_icon));
        put("large_media_top_tall", new BasicNativeAd(R.layout.large_media_top_tall, BasicNativeAd.TextMeasureVariant.side_icon));
        put("large_media_bottom", new BasicNativeAd(R.layout.large_media_bottom, BasicNativeAd.TextMeasureVariant.side_icon));
        put("no_media_centered", new BasicNativeAd(R.layout.no_media_centered, BasicNativeAd.TextMeasureVariant.full_width));
        put("large_media_top_flex", new AspectRatioDependentNativeAd(R.layout.large_media_top,
                R.layout.large_media_side));
    }};
}
