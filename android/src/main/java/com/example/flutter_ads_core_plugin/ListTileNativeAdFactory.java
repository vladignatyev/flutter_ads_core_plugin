package com.example.flutter_ads_core_plugin;

import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.Map;
import java.util.Objects;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

class ListTileNativeAdFactory implements GoogleMobileAdsPlugin.NativeAdFactory {

    private final Context context;

    private String TAG = "NativeAdFactory";

    ListTileNativeAdFactory(Context context) {
        this.context = context;
    }

    @Override
    public NativeAdView createNativeAd(
            NativeAd nativeAd, Map<String, Object> customOptions) {

        NativeAdView nativeAdView = (NativeAdView) LayoutInflater.from(context)
                .inflate(R.layout.list_tile_native_ad, null);

        String store = nativeAd.getStore();
        String advertiser = nativeAd.getAdvertiser();
        String headline = nativeAd.getHeadline();
        String body = nativeAd.getBody();
        String cta = nativeAd.getCallToAction();
        String price = nativeAd.getPrice();
        Double starRating = nativeAd.getStarRating();
        NativeAd.Image icon = nativeAd.getIcon();

        TextView storeView = nativeAdView.findViewById(R.id.store);
        TextView advertiserView = nativeAdView.findViewById(R.id.advertiser);
        TextView headlineView = nativeAdView.findViewById(R.id.headline);
        TextView bodyView = nativeAdView.findViewById(R.id.body);
        TextView ctaView = nativeAdView.findViewById(R.id.cta_button);
        TextView priceView = nativeAdView.findViewById(R.id.ad_price);
        TextView starRatingView = nativeAdView.findViewById(R.id.rating_value);
        LinearLayout starRatingLayoutview = nativeAdView.findViewById(R.id.rating_layout);
        ImageView iconView = nativeAdView.findViewById(R.id.ad_icon);
        MediaView mediaView = nativeAdView.findViewById(R.id.ad_media);

        if (icon != null) {
            iconView.setImageDrawable(icon.getDrawable());
            nativeAdView.setIconView(iconView);
        } else {
            iconView.setVisibility(View.GONE);
        }

        if (headline != null) {
            headlineView.setText(headline);
            nativeAdView.setHeadlineView(headlineView);
        } else {
            headlineView.setVisibility(View.GONE);
        }


        if (body != null) {
            bodyView.setText(body);
            nativeAdView.setBodyView(bodyView);
        } else {
            bodyView.setVisibility(View.INVISIBLE);
        }


        if (price != null) {
            priceView.setText(price);
            nativeAdView.setPriceView(priceView);
        } else {
            priceView.setVisibility(View.GONE);
        }

        if (store != null) {
            storeView.setText(store);
            nativeAdView.setStoreView(storeView);
        } else {
            storeView.setVisibility(View.GONE);
        }

        if (advertiser != null) {
            advertiserView.setText(advertiser);
            nativeAdView.setAdvertiserView(advertiserView);
        } else {
            advertiserView.setVisibility(View.GONE);
        }

        if (starRating != null) {
            starRatingView.setText(starRating.toString());
            nativeAdView.setStarRatingView(starRatingView);
        } else {
            starRatingLayoutview.setVisibility(View.GONE);
        }

        if (cta != null) {
            ctaView.setText(cta);
            nativeAdView.setCallToActionView(ctaView);
        } else {
            ctaView.setVisibility(View.GONE);
        }

        if (customOptions != null) {
            if (customOptions.containsKey("showMedia")) {
                nativeAdView.setMediaView(mediaView);
            }

            if (customOptions.containsKey("headlineColor")) {
                String colorValue = Objects.requireNonNull(customOptions.get("headlineColor")).toString();
                if (!colorValue.isEmpty()) headlineView.setTextColor(Color.parseColor(colorValue));
            }

            if (customOptions.containsKey("bodyTextColor")) {
                String colorValue = Objects.requireNonNull(customOptions.get("bodyTextColor")).toString();
                if (!colorValue.isEmpty()) {
                    bodyView.setTextColor(Color.parseColor(colorValue));
                    starRatingView.setTextColor(Color.parseColor(colorValue));
                    advertiserView.setTextColor(Color.parseColor(colorValue));
                    storeView.setTextColor(Color.parseColor(colorValue));
                    priceView.setTextColor(Color.parseColor(colorValue));
                }
            }

            if (customOptions.containsKey("backgroundColor")) {
                String colorValue = Objects.requireNonNull(customOptions.get("backgroundColor")).toString();
                if (!colorValue.isEmpty())
                    nativeAdView.setBackgroundColor(Color.parseColor(colorValue));
            }

            if (customOptions.containsKey("buttonBackground")) {
                String colorValue = Objects.requireNonNull(customOptions.get("buttonBackground")).toString();
                if (!colorValue.isEmpty()) ctaView.setBackgroundColor(Color.parseColor(colorValue));
            }

            if (customOptions.containsKey("buttonTextColor")) {
                String colorValue = Objects.requireNonNull(customOptions.get("buttonTextColor")).toString();
                if (!colorValue.isEmpty()) ctaView.setTextColor(Color.parseColor(colorValue));
            }
        }

        nativeAdView.setNativeAd(nativeAd);

        return nativeAdView;
    }
}