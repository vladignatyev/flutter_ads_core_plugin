package me.taplika.flutter_ads_core_plugin.adfactory;

import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdContent;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;



import java.util.Map;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;

import me.taplika.flutter_ads_core_plugin.R;

import android.content.Context;

public class BasicNativeAd extends NativeAdFactory {
    public BasicNativeAd(int layoutId) {
        super();
        setLayoutId(layoutId);
    }

    @Override
    protected NativeAdView inflate(Context context, Map<String, Object> customOptions, NativeAdContent adContent) {
        return (NativeAdView) LayoutInflater.from(context).inflate(layoutId, null);  //
    }

    protected void bindMediaView(NativeAdView nativeAdView, MediaView mediaView, Map<String, Object> customOptions, NativeAdContent adContent) {
        if (mediaView != null && adContent.mediaContent != null) {
            mediaView.setMediaContent(adContent.mediaContent);
            nativeAdView.setMediaView(mediaView);
        }
    }

    @Override
    protected void bindView(NativeAdView nativeAdView, Map<String, Object> customOptions, NativeAdContent adContent) {
        /* 1. Obtaining views for showing ads content. */
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


        bindMediaView(nativeAdView, mediaView, customOptions, adContent);

        /* 2. Populate nativeAdView with our views */
        nativeAdView.setHeadlineView(headlineView);
        nativeAdView.setBodyView(bodyView);
        nativeAdView.setCallToActionView(ctaView);
        nativeAdView.setIconView(iconView);
        nativeAdView.setPriceView(priceView);
        nativeAdView.setStarRatingView(starRatingView);
        nativeAdView.setStoreView(storeView);
        nativeAdView.setAdvertiserView(advertiserView);


        /* 4. Fulfilling views with content of ads. */

        /* The headline and media content must present in ads content. */

        /* MUST FIELDS */
        headlineView.setText(adContent.headline);

        // Visibility, either GONE or INVISIBLE may affect revenues and concern an invalid traffic.
        if (adContent.icon != null) {
            iconView.setImageDrawable(adContent.icon.getDrawable());
        } else {
            iconView.setVisibility(View.GONE);
        }

        if (adContent.body != null) {
            bodyView.setText(adContent.body);
        } else {
            bodyView.setVisibility(View.INVISIBLE);
        }

        /* OPTIONAL FIELDS */
        if (adContent.price != null) {
            priceView.setText(adContent.price);
        } else {
            priceView.setVisibility(View.INVISIBLE);
        }

        if (adContent.store != null) {
            storeView.setText(adContent.store);
        } else {
            storeView.setVisibility(View.GONE);
        }

        if (adContent.advertiser != null) {
            advertiserView.setText(adContent.advertiser);
        } else {
            advertiserView.setVisibility(View.INVISIBLE);
        }

        if (adContent.starRating != null) {
            starRatingView.setText(String.format("★ %.1f", adContent.starRating.floatValue()));
        } else {
            starRatingLayoutview.setVisibility(View.INVISIBLE);
        }

        if (adContent.cta != null) {
            ctaView.setText(adContent.cta);
        } else {
            ctaView.setVisibility(View.INVISIBLE);
        }

//        if (customOptions != null) {
//            if (customOptions.containsKey("headlineColor")) {
//                String colorString = Objects.requireNonNull(customOptions.get("headlineColor")).toString();
//                if (!colorString.isEmpty()) {
//                    int colorValue = Color.parseColor(colorString);
//
//                    headlineView.setTextColor(Color.parseColor(colorValue));
//                }
//            }
//
//            if (customOptions.containsKey("bodyTextColor")) {
//                String colorString = Objects.requireNonNull(customOptions.get("bodyTextColor")).toString();
//                if (!colorString.isEmpty()) {
//                    int colorValue = Color.parseColor(colorString);
//
//                    bodyView.setTextColor(colorValue);
//                    starRatingView.setTextColor(colorValue);
//                    advertiserView.setTextColor(colorValue);
//                    storeView.setTextColor(colorValue);
//                    priceView.setTextColor(colorValue);
//                }
//            }
//
//            if (customOptions.containsKey("backgroundColor")) {
//                String colorString = Objects.requireNonNull(customOptions.get("backgroundColor")).toString();
//                if (!colorString.isEmpty()) {
//                    int colorValue = Color.parseColor(colorString);
//
//                    nativeAdView.setBackgroundColor(colorValue);
//                }
//            }
//
//            if (customOptions.containsKey("buttonBackground")) {
//                String colorValue = Objects.requireNonNull(customOptions.get("buttonBackground")).toString();
//                if (!colorValue.isEmpty()) ctaView.setBackgroundColor(Color.parseColor(colorValue));
//            }
//
//            if (customOptions.containsKey("buttonTextColor")) {
//                String colorValue = Objects.requireNonNull(customOptions.get("buttonTextColor")).toString();
//                if (!colorValue.isEmpty()) ctaView.setTextColor(Color.parseColor(colorValue));
//            }
//        }
    }
}