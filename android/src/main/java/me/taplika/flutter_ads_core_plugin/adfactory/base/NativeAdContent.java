package me.taplika.flutter_ads_core_plugin.adfactory.base;

import androidx.annotation.Nullable;

import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.MediaContent;

public final class NativeAdContent {
    public @Nullable String store;
    public @Nullable String advertiser;
    public @Nullable String headline;
    public @Nullable String body;
    public @Nullable String cta;
    public @Nullable String price;
    public @Nullable Float starRating;
    public @Nullable NativeAd.Image icon;

    public @Nullable MediaContent mediaContent;

    public NativeAdContent(NativeAd nativeAd) {
        store = nativeAd.getStore();
        advertiser = nativeAd.getAdvertiser();
        headline = nativeAd.getHeadline();
        body = nativeAd.getBody();
        cta = nativeAd.getCallToAction();
        price = nativeAd.getPrice();

        if (nativeAd.getStarRating() != null)
            starRating = nativeAd.getStarRating().floatValue();

        icon = nativeAd.getIcon();
        mediaContent = nativeAd.getMediaContent();
    }
}