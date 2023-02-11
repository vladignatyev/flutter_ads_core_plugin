package me.taplika.flutter_ads_core_plugin.adfactory;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAdView;

import java.util.Objects;

import me.taplika.flutter_ads_core_plugin.R;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdContent;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;

public class BasicNativeAd extends NativeAdFactory {
    public BasicNativeAd(int layoutId) {
        super();
        setLayoutId(layoutId);
    }


    protected void bindMediaView(NativeAdView nativeAdView, @Nullable MediaView mediaView, NativeAdContent adContent) {
        if (mediaView != null && adContent.mediaContent != null) {
            if (!adContent.mediaContent.hasVideoContent())
                mediaView.setImageScaleType(ImageView.ScaleType.CENTER_CROP);

            mediaView.setMediaContent(adContent.mediaContent);
            nativeAdView.setMediaView(mediaView);
        }
    }

    protected void bindStarRating(NativeAdView nativeAdView, @Nullable View starRating, NativeAdContent adContent) {
        if (starRating == null) {
            return;
        }

        RatingBar starRatingView = (RatingBar) starRating;
        if (adContent.starRating != null) {
            starRatingView.setRating(adContent.starRating);
            nativeAdView.setStarRatingView(starRatingView);
        } else {
            starRatingView.setVisibility(View.GONE);
        }
    }

    public void bindView(@NonNull NativeAdView nativeAdView,
                            @NonNull NativeAdContent adContent) {
        @NonNull TextView headlineView = Objects.requireNonNull(nativeAdView.findViewById(R.id.headline));
        @NonNull TextView ctaView = Objects.requireNonNull(nativeAdView.findViewById(R.id.cta_button));

        @Nullable TextView bodyView = nativeAdView.findViewById(R.id.body);
        @Nullable RatingBar ratingBar = nativeAdView.findViewById(R.id.ad_rating_bar);

        @Nullable ImageView iconView = nativeAdView.findViewById(R.id.ad_icon);
        @Nullable MediaView mediaView = nativeAdView.findViewById(R.id.ad_media);

        @Nullable TextView storeView = nativeAdView.findViewById(R.id.store);
        @Nullable TextView advertiserView = nativeAdView.findViewById(R.id.advertiser);
        @Nullable TextView priceView = nativeAdView.findViewById(R.id.ad_price);

        headlineView.setText(adContent.headline);
        nativeAdView.setHeadlineView(headlineView);

        if (adContent.cta != null) {
            ctaView.setText(adContent.cta);
        }

        nativeAdView.setCallToActionView(ctaView);

        bindMediaView(nativeAdView, mediaView, adContent);
        bindStarRating(nativeAdView, ratingBar, adContent);


        // Visibility, either GONE or INVISIBLE may affect revenues and concern an invalid traffic.
        if (iconView != null) {
            if (adContent.icon != null) {
                iconView.setImageDrawable(adContent.icon.getDrawable());
                nativeAdView.setIconView(iconView);
            } else {
                iconView.setVisibility(View.GONE);
            }
        }

        if (bodyView != null) {
            if (adContent.body != null) {
                bodyView.setText(adContent.body);
                nativeAdView.setBodyView(bodyView);
            } else {
                bodyView.setVisibility(View.INVISIBLE);
            }
        }

        /* OPTIONAL FIELDS */
        if (priceView != null) {
            if (adContent.price != null) {
                priceView.setText(adContent.price);
                nativeAdView.setPriceView(priceView);
            } else {
                priceView.setVisibility(View.GONE);
            }
        }

        if (storeView != null) {
            if (adContent.store != null) {
                storeView.setText(adContent.store);
                nativeAdView.setStoreView(storeView);
            } else {
                storeView.setVisibility(View.GONE);
            }
        }

        if (advertiserView != null) {
            if (adContent.advertiser != null) {
                advertiserView.setText(adContent.advertiser);
                nativeAdView.setAdvertiserView(advertiserView);
            } else {
                advertiserView.setVisibility(View.GONE);
            }
        }
    }
}