package me.taplika.flutter_ads_core_plugin;

import java.util.HashMap;
import java.util.Map;

import me.taplika.flutter_ads_core_plugin.adfactory.BasicNativeAd;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;

import me.taplika.flutter_ads_core_plugin.R;

public class LayoutPresets {
    public static Map<String, NativeAdFactory> factories = new HashMap<String, NativeAdFactory>() {{
        put("listTile", new BasicNativeAd(R.layout.list_tile_native_ad));
    }};
}
