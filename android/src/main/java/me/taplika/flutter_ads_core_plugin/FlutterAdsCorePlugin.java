package me.taplika.flutter_ads_core_plugin;

import android.content.Context;
import android.util.Log;

import java.util.HashMap;
import java.util.Objects;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import me.taplika.flutter_ads_core_plugin.adfactory.BasicNativeAd;


/**
 * FlutterAdsCorePlugin
 */
public class FlutterAdsCorePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private static final String TAG = "FlutterAdsCorePlugin";

    private FlutterEngine flutterEngine;

    private MethodChannel channel;

    public void bindAdFactories(ActivityPluginBinding binding) {
        Log.d(TAG, "bindAdFactories");

        Context context = (Context) binding.getActivity();

        LayoutPresets.factories.forEach((factoryName, factory) ->
                factory.setContext(context));
    }

    public void unbindAdFactories() {
        Log.d(TAG, "unbindAdFactories");

//        LayoutPresets.factories.forEach((factoryName, factory) ->
//                factory.setContext(null));
    }


    private void registerAdFactories() {
        Log.d(TAG, "registerAdFactories");

        LayoutPresets.factories.forEach((factoryName, factory) ->
                GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, factoryName, factory));
    }

    private void unregisterAdFactories() {
        Log.d(TAG, "unregisterAdFactories");

        LayoutPresets.factories.forEach((factoryName, factory) ->
                GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, factoryName));
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine");

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_ads_core_plugin");
        channel.setMethodCallHandler(this);

        flutterEngine = flutterPluginBinding.getFlutterEngine();
        flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding ignoredBinding) {
        Log.d(TAG, "onDetachedFromEngine");

        channel.setMethodCallHandler(null);

        unbindAdFactories();
        unregisterAdFactories();
        flutterEngine = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        if (Objects.equals(call.method, "getLastNativeAdMeasureHeight")) {
            BasicNativeAd nativeAd = ((BasicNativeAd) LayoutPresets.factories.get(call.<String>argument("factoryId")));

            if (nativeAd != null) {
                result.success(nativeAd.measureHeight);
            } else {
                result.error("0", "Factory not found", null);
            }

        }
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "onAttachedToActivity");

        bindAdFactories(binding);
        registerAdFactories();

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges");

        unbindAdFactories();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "onReattachedToActivityForConfigChanges");

        bindAdFactories(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity");

        unbindAdFactories();
    }
}
