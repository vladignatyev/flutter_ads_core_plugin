package me.taplika.flutter_ads_core_plugin.adfactory;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;

import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;

import com.google.android.gms.ads.MediaContent;
import com.google.android.gms.ads.nativead.NativeAdView;

import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdContent;
import me.taplika.flutter_ads_core_plugin.adfactory.base.NativeAdFactory;

public class AspectRatioDependentNativeAd extends BasicNativeAd {
    final private String TAG = "AspectRatioDependentNativeAd";

    @LayoutRes int verticalLayoutId;

    public AspectRatioDependentNativeAd(int defaultLayoutId, int verticalLayoutId) {
        super(defaultLayoutId, TextMeasureVariant.side_media);

        this.verticalLayoutId = verticalLayoutId;
    }

    @Override
    public @NonNull NativeAdView inflate(@NonNull Context context,
                                         @NonNull NativeAdContent adContent) {
        if (adContent.mediaContent != null) {
            float aspect = adContent.mediaContent.getAspectRatio();
            Log.d(TAG, String.format("Obtained aspect ratio of the MediaContent: %f", aspect));
            if (aspect < 1.0f) {
                Log.d(TAG, "Thus inflating vertical layout...");
                setLayoutId(this.verticalLayoutId);


            }
        }

        return super.inflate(context, adContent);
    }

}