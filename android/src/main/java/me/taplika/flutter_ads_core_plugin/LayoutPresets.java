package me.taplika.flutter_ads_core_plugin;

import java.util.HashMap;
import java.util.Map;

import me.taplika.flutter_ads_core_plugin.adfactory.BasicNativeAd;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;

import me.taplika.flutter_ads_core_plugin.R;

public class LayoutPresets {
    public static Map<String, NativeAdFactory> factories = new HashMap<String, NativeAdFactory>() {{
        put("in_feed_left", new BasicNativeAd(R.layout.in_feed_left));
        put("in_feed_right", new BasicNativeAd(R.layout.in_feed_right));
        put("large_centered", new BasicNativeAd(R.layout.large_centered));
        put("large_media_top", new BasicNativeAd(R.layout.large_media_top));
        put("large_media_bottom", new BasicNativeAd(R.layout.large_media_bottom));
        put("no_media_centered", new BasicNativeAd(R.layout.no_media_centered));
    }};
}
