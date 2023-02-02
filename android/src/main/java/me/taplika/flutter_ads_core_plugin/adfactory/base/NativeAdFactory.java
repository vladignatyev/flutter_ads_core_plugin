package me.taplika.flutter_ads_core_plugin.adfactory.base;

import android.content.Context;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;


abstract public class NativeAdFactory implements GoogleMobileAdsPlugin.NativeAdFactory {

    private String TAG = "NativeAdFactory";
    private Context context;
    public void setContext(Context context) {
        this.context = context;
    }

    protected int layoutId;

    public void setLayoutId(int layoutId) {
        this.layoutId = layoutId;
    }

    abstract protected NativeAdView inflate(Context context, Map<String, Object> customOptions, NativeAdContent adContent);
    abstract protected void bindView(NativeAdView nativeAdView, Map<String, Object> customOptions, NativeAdContent adContent);

    @Override
    public NativeAdView createNativeAd(
            NativeAd nativeAd, Map<String, Object> customOptions) {
        if (context == null) {
            throw new IllegalStateException("createNativeAd() called on NativeAdFactory but context is not bound.");
        }
        NativeAdContent adContent = new NativeAdContent(nativeAd);

        NativeAdView nativeAdView = inflate(context, customOptions, adContent);
        bindView(nativeAdView, customOptions, adContent);
        nativeAdView.setNativeAd(nativeAd);

        return nativeAdView;
    }
}