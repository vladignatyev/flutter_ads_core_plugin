package me.taplika.flutter_ads_core_plugin.adfactory.base;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import me.taplika.flutter_ads_core_plugin.adfactory.CustomOptions;

import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;


abstract public class NativeAdFactory implements GoogleMobileAdsPlugin.NativeAdFactory {
    final private String TAG = "NativeAdFactory";

    private Context context;

    public void setContext(Context context) {
        this.context = context;
    }

    protected int layoutId;

    public void setLayoutId(int layoutId) {
        this.layoutId = layoutId;
    }

    @SuppressWarnings("unused")
    protected @NonNull NativeAdView inflate(@NonNull Context context,
                                            @NonNull NativeAdContent adContent) {
        return (NativeAdView) LayoutInflater.from(context).inflate(layoutId, null);
    }

    abstract protected void bindView(@NonNull NativeAdView nativeAdView,
                                     @NonNull NativeAdContent adContent);

    protected void applyCustomOptions(@NonNull View inflatedView,
                                      @NonNull CustomOptions customOptions) {
        customOptions.applyToView(inflatedView);
    }

    @SuppressWarnings("unused")
    @Override
    public NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptionsMap) {
        if (context == null) {
            throw new IllegalStateException("createNativeAd() called on NativeAdFactory but context is not bound.");
        }

        NativeAdContent adContent = new NativeAdContent(nativeAd);

        NativeAdView nativeAdView = inflate(context, adContent);

        applyCustomOptions(nativeAdView,
                CustomOptions.fromHashMap(customOptionsMap));

        bindView(nativeAdView, adContent);

        nativeAdView.setNativeAd(nativeAd);

        return nativeAdView;
    }
}