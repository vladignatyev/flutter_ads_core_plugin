package me.taplika.flutter_ads_core_plugin.adfactory.base;

import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.MediaContent;

public final class NativeAdContent {
    public String store;
    public String advertiser;
    public String headline;
    public String body;
    public String cta;
    public String price;
    public Double starRating;
    public NativeAd.Image icon;

    public MediaContent mediaContent;

    public NativeAdContent(NativeAd nativeAd) {
        store = nativeAd.getStore();
        advertiser = nativeAd.getAdvertiser();
        headline = nativeAd.getHeadline();
        body = nativeAd.getBody();
        cta = nativeAd.getCallToAction();
        price = nativeAd.getPrice();
        starRating = nativeAd.getStarRating();
        icon = nativeAd.getIcon();
        mediaContent = nativeAd.getMediaContent();
    }
}