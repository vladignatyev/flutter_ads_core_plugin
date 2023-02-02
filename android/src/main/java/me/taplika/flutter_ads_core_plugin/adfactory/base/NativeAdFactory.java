package me.taplika.flutter_ads_core_plugin.adfactory.base;

import android.content.Context;

import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdContent;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;


abstract public class NativeAdFactory implements GoogleMobileAdsPlugin.NativeAdFactory {



    protected Context context;

    private String TAG = "MediaNativeAd";



    public NativeAdFactory(Context context) {
        this.context = context;
    }

    abstract protected NativeAdView inflate(Context context, Map<String, Object> customOptions, NativeAdContent adContent);
    abstract protected void bindView(NativeAdView nativeAdView, Map<String, Object> customOptions, NativeAdContent adContent);

    @Override
    public NativeAdView createNativeAd(
            NativeAd nativeAd, Map<String, Object> customOptions) {
        NativeAdContent adContent = new NativeAdContent(nativeAd);

        NativeAdView nativeAdView = inflate(context, customOptions, adContent);
        bindView(nativeAdView, customOptions, adContent);
        nativeAdView.setNativeAd(nativeAd);

        return nativeAdView;
    }
}