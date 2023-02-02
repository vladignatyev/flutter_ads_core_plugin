package me.taplika.flutter_ads_core_plugin.adfactory;

import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdContent;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;
import me.taplika.flutter_ads_core_plugin.R;


import java.util.Map;
import java.util.Objects;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;


import android.content.Context;

public class ListMediaButtonNativeAd extends NativeAdFactory {
    public ListMediaButtonNativeAd(Context context) { super(context); }

    @Override
    protected NativeAdView inflate(Context context, Map<String, Object> customOptions, NativeAdContent adContent) {
        return (NativeAdView) LayoutInflater.from(context).inflate(R.layout.list_tile_native_ad, null);
    }

    @Override
    protected void bindView(NativeAdView nativeAdView, Map<String, Object> customOptions, NativeAdContent adContent) {
        /* 2. Obtaining views for showing ads content. */
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

        /* 3. Provide views to ads SDK. */
        nativeAdView.setHeadlineView(headlineView);
        nativeAdView.setBodyView(bodyView);
        nativeAdView.setCallToActionView(ctaView);
        nativeAdView.setIconView(iconView);
        nativeAdView.setPriceView(priceView);
        nativeAdView.setStarRatingView(starRatingView);
        nativeAdView.setStoreView(storeView);
        nativeAdView.setAdvertiserView(advertiserView);
        nativeAdView.setMediaView(mediaView);

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

        if (adContent.mediaContent != null) {
            mediaView.setMediaContent(adContent.mediaContent);
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
            starRatingView.setText(adContent.starRating.toString());
        } else {
            starRatingLayoutview.setVisibility(View.INVISIBLE);
        }

        if (adContent.cta != null) {
            ctaView.setText(adContent.cta);
        } else {
            ctaView.setVisibility(View.INVISIBLE);
        }

        if (customOptions != null) {
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
    }
}